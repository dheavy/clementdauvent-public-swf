package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.controller.events.ElementEvent;
	import com.clementdauvent.site.view.components.DescriptionBar;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class DescriptionBarMediator extends Mediator
	{
		[Inject]
		public var view:DescriptionBar;
		
		override public function onRegister():void
		{
			view.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		public function setDescription(desc:String):void
		{
			view.setDescription(desc);
		}
		
		protected function initView(e:Event):void
		{
			view.removeEventListener(Event.ADDED_TO_STAGE, initView);
			
			eventDispatcher.addEventListener(Event.RESIZE, positionView);
			eventDispatcher.addEventListener(ElementEvent.IMG_MOUSE_OVER, eventBus_imgMouseOverHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_OVER, eventBus_stageMouseOverHandler);
			eventDispatcher.addEventListener(ElementEvent.DISPLAY_DESCRIPTION, eventBus_displayDescriptionHandler);
			
			positionView();
		}
		
		protected function positionView(e:Event = null):void
		{
			view.drawBackground();
			view.x = 0;
			view.y = view.stage.stageHeight - view.height;
		}
		
		protected function eventBus_imgMouseOverHandler(e:ElementEvent):void
		{
			setDescription((e.info) as String);
		}
		
		protected function eventBus_stageMouseOverHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			setDescription('');
		}
		
		protected function eventBus_displayDescriptionHandler(e:ElementEvent):void
		{
			setDescription(e.info);
		}
	}
}