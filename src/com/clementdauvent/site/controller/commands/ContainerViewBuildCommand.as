package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.ClementDauventPublicSite;
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.model.ContainerViewBuildModel;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.view.components.MiniMap;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command fetching the data to build the main view.</p>
	 */
	public class ContainerViewBuildCommand extends Command
	{
		/**
		 * Injected instance of the model. 
		 */
		[Inject]
		public var containerModel:ContainerViewBuildModel;
		
		/**
		 * Injected instance of the main view.
		 **/
		[Inject]
		public var mainView:ClementDauventPublicSite;
		
		protected var _dummySrc:String;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Initializes the fetching of the data on the model.
		 */
		override public function execute():void
		{
			_dummySrc = mainView.loaderInfo.parameters.dummySrc || 'img/DummyBitmapDataSite.gif';
			Logger.print("[INFO] ContainerViewBuildCommand fetched the following URL for the dummy bitmap image: " + _dummySrc);
			eventDispatcher.addEventListener(ContainerViewBuildModel.READY, readyHandler);
			containerModel.buildDataForMainView(_dummySrc);
		}
		
		/**
		 * @private	readyHandler
		 * @return	void
		 * 
		 * Event handler triggered when data is available on the model.
		 * Broadcasts the news as an event in eventDispatcher.
		 */
		protected function readyHandler(e:Event):void
		{
			eventDispatcher.removeEventListener(ContainerViewBuildModel.READY, readyHandler);
			createMainView();
			prepareMiniMap();
			callDataForImages();
		}
		
		/**
		 * @private	createMainView
		 * @return	void
		 * 
		 * Creates and adds to the root view class an instance of MainView.
		 */
		protected function createMainView():void
		{
			// Create the main view.
			var containerView:ContainerView = new ContainerView();
			containerView.create(containerModel.vo.data);
			
			// Use the injector to turn this ContainerView instance into a singleton.
			injector.mapValue(ContainerView, containerView);
			
			// Add the view to the display list.
			mainView.addChild(containerView);
			
			Logger.print("[INFO] ContainerViewBuildCommand has created the ContainerView instance and added it to the display list");
		}
		
		protected function prepareMiniMap():void
		{
			var map:MiniMap = new MiniMap();
			map.prepare(containerModel.vo.data);
			mainView.addChild(map);
		}
		
		protected function callDataForImages():void
		{
			// Use the event bus to require data from the main model and initialize the build of images views.
			eventDispatcher.dispatchEvent(new DataFetchEvent(DataFetchEvent.REQUIRE_DATA_FOR_IMAGES));
		}
	}
}