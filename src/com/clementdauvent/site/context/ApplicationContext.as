package com.clementdauvent.site.context
{
	import com.clementdauvent.site.ClementDauventPublicSite;
	import com.clementdauvent.site.controller.commands.*;
	import com.clementdauvent.site.controller.events.*;
	import com.clementdauvent.site.model.*;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.*;
	import com.clementdauvent.site.view.mediators.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.mvcs.Context;
	
	/**
	 * <p>Defines a context for the application, following Robotlegs' apparatus.</p>
	 */
	public class ApplicationContext extends Context
	{
		/**
		 * @public	ApplicationContext
		 * @param	contextView:DisplayObjectContainer	A display object container to use as context. Defaut to null.
		 * @param	autoStartup:Boolean	Should it call the startup() method automatically or not? Defaults to true.
		 * @return	this
		 * 
		 * Defines a context for the application, following Robotlegs' apparatus.
		 */
		public function ApplicationContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		/**
		 * @public	startup
		 * @return	void
		 * 
		 * Starts the app.
		 */
		override public function startup():void
		{
			// Defines Controller tier.
			commandMap.mapEvent(DataFetchEvent.BEGIN, StartupCommand);
			commandMap.mapEvent(DataFetchEvent.COMPLETE, ContainerViewBuildCommand);
			commandMap.mapEvent(DataFetchEvent.REQUIRE_DATA_FOR_IMAGES, ImagesAndTextsSetupCommand);
			commandMap.mapEvent(KeyboardEvent.KEY_DOWN, PrevNextCommand);
			commandMap.mapEvent(DataFetchEvent.FINISH, MenuBuildCommand);
			commandMap.mapEvent(MenuEvent.MENU_CLICKED, MenuClickedCommand);
			
			// Defines Model tier.
			injector.mapSingleton(ApplicationModel);
			injector.mapSingleton(ContainerViewBuildModel);
			
			// Defines View tier.
			mediatorMap.mapView(ClementDauventPublicSite, StageMediator);
			mediatorMap.mapView(ContainerView, ContainerViewMediator);
			mediatorMap.mapView(Image, ImageMediator);
			mediatorMap.mapView(TextElement, TextElementMediator);
			mediatorMap.mapView(DescriptionBar, DescriptionBarMediator);
			mediatorMap.mapView(MiniMap, MiniMapMediator);
			mediatorMap.mapView(Menu, MenuMediator);
			injector.mapValue(ClementDauventPublicSite, this.contextView);
			
			// Start app.
			dispatchEvent(new DataFetchEvent(DataFetchEvent.BEGIN));
			
			Logger.print("[INFO] ApplicationContext started");
		}
	}
}