package com.clementdauvent.site.model
{
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.controller.events.ElementEvent;
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
		
		protected var _currentIndex:int;
		
		protected var _numElements:int;
		
		protected var _hudWidth:Number;
		
		protected var _mainScreenScale:Number;
		
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
		
		public function prev():void
		{
			if (_currentIndex > 0) {
				_currentIndex -= 1;
			} else {
				_currentIndex = _numElements - 1;
			}
			
			showElement(_currentIndex);
		}
		
		public function next():void
		{
			if (_currentIndex < _numElements - 1) {
				_currentIndex += 1;
			} else {
				_currentIndex = 0;
			}
 			
			showElement(_currentIndex);
		}
		
		public function showElement(index:int):void
		{
			eventDispatcher.dispatchEvent(new ElementEvent(ElementEvent.SELECT, index));
			// TODO: Add swfaddress apparatus.
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
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function get hudWidth():Number
		{
			return _hudWidth;
		}
		
		public function set hudWidth(value:Number):void
		{
			_hudWidth = value;
		}
		
		public function get mainScreenScale():Number
		{
			return _mainScreenScale;
		}
		
		public function set mainScreenScale(value:Number):void
		{
			_mainScreenScale = value;
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
			var id:int = 0;
			
			for (var i:int = 0; i < imagesArr.length; i++) {
				var o:Object = imagesArr[i];
				var iVO:ImageVO = new ImageVO(o.src, o.originalWidth, o.originalHeight, o.isFirst, o.xOffset, o.yOffset, o.scale, o.description);
				images.push(iVO);
				
				// Captures the element used as opening, and use its scale as reference.
				if (o.isFirst) {
					referenceScale = o.scale;
					referenceHeight = o.originalHeight;
					_currentIndex = id;
				}
				
				id++;
			}
			
			for (i = 0; i < textsArr.length; i++) {
				o = textsArr[i];
				var tVO:TextVO = new TextVO(id, o.title, o.content, o.isFirst, o.xOffset, o.yOffset);
				texts.push(tVO);
				
				// Captures the element used as opening, and use its scale as reference.
				if (o.isFirst) {
					referenceScale = o.scale;
					referenceHeight = o.originalHeight;
					_currentIndex = id;
				}
				
				id++;
			}
			
			// Store the overall number of elements.
			_numElements = imagesArr.length + textsArr.length;
			
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