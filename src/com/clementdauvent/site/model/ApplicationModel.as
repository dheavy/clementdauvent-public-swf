package com.clementdauvent.site.model
{
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.model.vo.DataVO;
	import com.clementdauvent.site.model.vo.ImageVO;
	import com.clementdauvent.site.model.vo.TextVO;
	import com.clementdauvent.site.utils.Logger;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * <p>The main model class for the app.</p>
	 * 
	 * @author	Davy Peter Braun
	 * @date	2012-08-16
	 */
	public class ApplicationModel extends Actor
	{
		/**
		 * @private	URLLoader to fetch JSON file.
		 */
		protected var _jsonLoader:URLLoader;
		
		/**
		 * @private	DataVO instance holding model data.
		 */
		protected var _data:DataVO;
		
		/**
		 * @private	The scale used as reference to rescale some elements. Based on the scale of the opening ("first") element.
		 */
		protected var _referenceScale:Number;
		
		/**
		 * @private	The height of the opening element, used to compute the zoom level of the app.
		 */
		protected var _referenceHeight:Number;
		
		/**
		 * @public	ApplicationModel
		 * @return	this
		 * 
		 * Creates an instance of ApplicationModel, the main model class for the app.
		 */
		public function ApplicationModel()
		{
			// Silence is golden...
		}
		
		/**
		 * @public	loadJSON
		 * @param	dataSrc:String
		 * @return	void
		 * 
		 * Loads the JSON formatted data from given URL, effectively kickstarting the application.
		 */
		public function loadJSON(dataSrc:String):void 
		{
			_jsonLoader = new URLLoader();
			_jsonLoader.addEventListener(Event.COMPLETE, jsonLoader_completeHandler);
			_jsonLoader.addEventListener(IOErrorEvent.IO_ERROR, jsonLoader_ioErrorHandler);
			_jsonLoader.load(new URLRequest(dataSrc));
		}
		
		/**
		 * @public	data
		 * @return	DataVO object holding the application fetched data.
		 */
		public function get data():DataVO
		{
			return _data;
		}
		
		/**
		 * @public	referenceScale
		 * @return	The reference value used for scaling.
		 */
		public function get referenceScale():Number
		{
			return _referenceScale;
		}
		
		/**
		 * @public	referenceScale
		 * @param	value:Number	The value to use as reference for scaling throughout the app.
		 * @return	void
		 */
		public function set referenceScale(value:Number):void
		{
			_referenceScale = value;
		}
		
		/**
		 * @public	referenceHeight
		 * @return	The reference height used to compute the zoom level of the app.
		 */
		public function get referenceHeight():Number
		{
			return _referenceHeight;
		}
		
		/**
		 * @public	referenceHeight
		 * @param	New value for referenceHeight.
		 * @return	void
		 */
		public function set referenceHeight(value:Number):void
		{
			_referenceHeight = value;
		}
		
		/**
		 * @private	removeLoaderListeners
		 * @return	void
		 * 
		 * Cleans up the listeners used by the loader for JSON data.
		 */
		protected function removeLoaderListeners():void
		{
			if (_jsonLoader) {
				_jsonLoader.removeEventListener(Event.COMPLETE, jsonLoader_completeHandler);
				_jsonLoader.removeEventListener(IOErrorEvent.IO_ERROR, jsonLoader_ioErrorHandler);
			}
		}
		
		/**
		 * @private	jsonLoader_completeHandler
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered if JSON file loading is successful.
		 */
		protected function jsonLoader_completeHandler(e:Event):void
		{
			removeLoaderListeners();
			
			// Parse JSON and populate vector lists of images and texts from its data.
			var json:Object = JSON.parse(e.target.data);
			var imagesArr:Array = json.images;
			var textsArr:Array = json.texts;
			var images:Vector.<ImageVO> = new Vector.<ImageVO>();
			var texts:Vector.<TextVO> = new Vector.<TextVO>();
			
			for (var i:int = 0; i < imagesArr.length; i++) {
				var o:Object = imagesArr[i];
				var iVO:ImageVO = new ImageVO(o.src, o.originalWidth, o.originalHeight, o.isFirst, o.xOffset, o.yOffset, o.scale, o.description);
				images.push(iVO);
				
				// Captures the element used as opening, and use its scale as reference.
				if (o.isFirst) {
					referenceScale = o.scale;
					referenceHeight = o.originalHeight;
				}
			}
			
			for (i = 0; i < textsArr.length; i++) {
				o = textsArr[i];
				var tVO:TextVO = new TextVO(o.title, o.content, o.isFirst, o.xOffset, o.yOffset);
				texts.push(tVO);
				
				// Captures the element used as opening, and use its scale as reference.
				if (o.isFirst) {
					referenceScale = o.scale;
					referenceHeight = o.originalHeight;
				}
			}
			
			// Store the data in the Model.
			_data = new DataVO(images, texts);
			
			Logger.print("[INFO] ApplicationModel has stored data from JSON");
			
			// Tell the app we're done and we can continue, by broadcasting a
			// DataFetchEvent.COMPLETE with a payload of data.
			eventDispatcher.dispatchEvent(new DataFetchEvent(DataFetchEvent.COMPLETE, _data));
		}
		
		/**
		 * @private	jsonLoader_ioErrorHandler
		 * @param	e:IOErrorEvent	The Event object passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered if JSON file loading fails.
		 */
		protected function jsonLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			Logger.print("[ERROR] ApplicationModel — " + e.text);
			removeLoaderListeners();
		}
	}
}