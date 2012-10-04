package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.ClementDauventPublicSite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>The Mediator for the main Stage instance grabbed from the Main class of the app.</p>
	 */
	public class StageMediator extends Mediator
	{
		/**
		 * Dependency injection of the app's main class. 
		 */
		[Inject]
		public var application:ClementDauventPublicSite;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Method invoked when Mediator is registered.
		 * Registers listeners on Stage to make stage events available throughout the application.
		 */
		override public function onRegister():void
		{
			application.stage.addEventListener(Event.RESIZE, stage_resizeHandler);	
			application.stage.addEventListener(MouseEvent.CLICK, stage_clickHandler);
		}
		
		/**
		 * @public	stage_resizeHandler
		 * @return	void
		 * 
		 * Event handler triggered when stage is resized.
		 * Dispatch it throughout the application via EventDispatcher module.
		 */
		protected function stage_resizeHandler(e:Event):void
		{
			eventDispatcher.dispatchEvent(e);
		}
		
		/**
		 * @private	stage_clickHandler
		 * @return	void
		 * 
		 * Event handler triggered when stage is clicked.
		 * Dispatch it throughout the application via EventDispatcher module.
		 */
		protected function stage_clickHandler(e:MouseEvent):void
		{
			eventDispatcher.dispatchEvent(e); 
		}
	}
}