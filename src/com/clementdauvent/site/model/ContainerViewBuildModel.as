package com.clementdauvent.site.model
{
	import com.clementdauvent.site.model.vo.BitmapDataVO;
	import com.clementdauvent.site.utils.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 * <p>Model in charge of setting up the bitmapdata needed to build the main view (including
	 * the minimap).</p>
	 * <p>In order to build a bitmap-based view wider than the limited 2880x2880 bitmapdata,
	 * we load a bitmap wider than this, "hijack" its bitmapdata, and inject it later in
	 * a new bitmap. Flash forbids creating bitmapdata wider than the limit but this is
	 * a workaround.</p>
	 */
	public class ContainerViewBuildModel extends Actor
	{
		/**
		 * Event constant used to alert of the availability of the data.
		 */
		public static const READY:String = "mainViewReady";
		
		/**
		 * @private	The Loader loading the image resource.
		 */
		protected var _fileLoader:Loader;
		
		/**
		 * @private	The bitmap data container resulting for this manipulation.
		 */
		protected var _vo:BitmapDataVO;
		
		/**
		 * @public	MainViewBuilderModel
		 * @return	this
		 * 
		 * Creates an instance of MainViewBuilderModel, the model in charge of creating
		 * the bitmapdata needed to generate a bitmap-based view wider than the Flash limit,
		 * which is 2880x2880 pixels wide.
		 * 
		 * @usage
		 * var m:MainViewBuilderModel = new MainViewBuilderModel();
		 * m.eventDispatcher.addEventListener(MainViewBuilderModel.READY, handler);
		 * m.buildDataForMainView();
		 * 
		 * function handler(e:Event):void {
		 * 	var bmpD:BitmapData = (e.target as MainViewBuilderModel).mainViewData;
		 *  var bmp:Bitmap = new Bitmap(bmpD);
		 * }
		 */
		public function ContainerViewBuildModel()
		{
			_vo = new BitmapDataVO();
		}
		
		/**
		 * @public	buildDataForMainView
		 * @param	dummySrc:String	URL of the image resource used to generate the bitmap data.
		 * @return	void
		 * 
		 * Initialized the bitmap data loading and acquisition process.
		 * Must be invoked AFTER this instance has had a listener registering for its custom READY event.
		 */
		public function buildDataForMainView(dummySrc:String):void
		{
			_fileLoader = new Loader();
			_fileLoader.contentLoaderInfo.addEventListener(Event.INIT, fileLoader_initHandler);
			_fileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fileLoader_ioErrorHandler);
			_fileLoader.load(new URLRequest(dummySrc));
		}
		
		/**
		 * @public	vo
		 * @return	The BitmapData generated that should be injected in a new bitmap instance to create a bitmap whose dimensions bypasses the original limit of 2880x2880 px.
		 */
		public function get vo():BitmapDataVO
		{
			if (_vo.data == null) {
				Logger.print("[ERROR] ContainerViewBuildModel has not yet built bitmapdata for main view.");
			}
			
			return _vo;
		}
		
		/**
		 * @private	removeLoaderListeners
		 * @return	void
		 * 
		 * Removes all listeners created during the loading process, as well as the loader itself.
		 */
		protected function removeLoaderListeners():void
		{
			if (_fileLoader) {
				_fileLoader.contentLoaderInfo.removeEventListener(Event.INIT, fileLoader_initHandler);
				_fileLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, fileLoader_ioErrorHandler);
			}
			_fileLoader = null;
		}
		
		
		/**
		 * @private	fileLoader_initHandler
		 * @return	void
		 * 
		 * Event handler triggered when the image has loaded successfully.
		 * Makes the bitmap data available in the appropriate getter of this instance.
		 */
		protected function fileLoader_initHandler(e:Event):void
		{
			_vo.data = (_fileLoader.content as Bitmap).bitmapData;
			eventDispatcher.dispatchEvent(new Event(ContainerViewBuildModel.READY));
			removeLoaderListeners();
			Logger.print("[INFO] ContainerViewBuildModel has acquired the data needed to build the main view");
		}
		
		/**
		 * @private	fileLoader_ioErrorHandler
		 * @return	void
		 * 
		 * Event handler triggered when the loader has failed loading the image.
		 * Displays an error message.
		 */
		protected function fileLoader_ioErrorHandler(e:IOErrorEvent):void
		{
			Logger.print("[ERROR] ContainerViewBuildModel could not load its image resource. " + e.text);
			removeLoaderListeners();
		}
	}
}