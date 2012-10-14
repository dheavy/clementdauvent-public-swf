package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.controller.events.MenuEvent;
	import com.clementdauvent.site.model.ApplicationModel;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.Menu;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MenuMediator extends Mediator
	{
		[Inject]
		public var view:Menu;
		
		[Inject]
		public var model:ApplicationModel;
		
		override public function onRegister():void
		{
			view.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		protected function initView(e:Event):void
		{
			view.removeEventListener(Event.ADDED_TO_STAGE, initView);
			view.build(model.data.texts, model.hudWidth);
			view.addEventListener(MenuEvent.MENU_CLICKED, menu_clickedHandler);
		}
		
		protected function menu_clickedHandler(e:MenuEvent):void
		{
			dispatch(e);
		}
	}
}