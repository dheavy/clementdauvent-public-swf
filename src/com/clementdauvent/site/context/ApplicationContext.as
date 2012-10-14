package com.clementdauvent.site.context
{
	import com.clementdauvent.site.ClementDauventPublicSite;
	import com.clementdauvent.site.controller.commands.ContainerViewBuildCommand;
	import com.clementdauvent.site.controller.commands.ImageSelectCommand;
	import com.clementdauvent.site.controller.commands.ImagesAndTextsSetupCommand;
	import com.clementdauvent.site.controller.commands.PrevNextCommand;
	import com.clementdauvent.site.controller.commands.StartupCommand;
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.controller.events.ElementEvent;
	import com.clementdauvent.site.model.ApplicationModel;
	import com.clementdauvent.site.model.ContainerViewBuildModel;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.view.components.DescriptionBar;
	import com.clementdauvent.site.view.components.Image;
	import com.clementdauvent.site.view.components.MiniMap;
	import com.clementdauvent.site.view.components.TextElement;
	import com.clementdauvent.site.view.mediators.ContainerViewMediator;
	import com.clementdauvent.site.view.mediators.DescriptionBarMediator;
	import com.clementdauvent.site.view.mediators.ImageMediator;
	import com.clementdauvent.site.view.mediators.MiniMapMediator;
	import com.clementdauvent.site.view.mediators.StageMediator;
	import com.clementdauvent.site.view.mediators.TextElementMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.mvcs.Context;
	
	public class ApplicationContext extends Context
	{
		public function ApplicationContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			// Defines Controller tier.
			commandMap.mapEvent(DataFetchEvent.BEGIN, StartupCommand);
			commandMap.mapEvent(DataFetchEvent.COMPLETE, ContainerViewBuildCommand);
			commandMap.mapEvent(DataFetchEvent.REQUIRE_DATA_FOR_IMAGES, ImagesAndTextsSetupCommand);
			commandMap.mapEvent(ElementEvent.SELECT, ImageSelectCommand);
			commandMap.mapEvent(KeyboardEvent.KEY_DOWN, PrevNextCommand);
			
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
			injector.mapValue(ClementDauventPublicSite, this.contextView);
			
			// Start app.
			dispatchEvent(new DataFetchEvent(DataFetchEvent.BEGIN));
			
			Logger.print("[INFO] ApplicationContext started");
		}
	}
}