package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.view.components.Image;
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.utils.Logger;
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator for img instance.</p>
	 */
	public class ImageMediator extends Mediator
	{
		/**
		 * The injected img instance this mediator mediates. 
		 */		
		[Inject]
		public var img:Image;
		
		/**
		 * An injected dependency of the singleton instance of the ContainerView, parent for instances of img. 
		 */		
		[Inject]
		public var surface:ContainerView;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Registers a listener to trigger initialization when the view is added to the display list.
		 */
		override public function onRegister():void
		{
			img.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		/**
		 * @private	initView
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Initializes the mediation for the view.
		 */
		protected function initView(e:Event):void
		{
			img.removeEventListener(Event.ADDED_TO_STAGE, initView);			
		}
		
		/**
		 * @private	monitorMouseInBounds
		 * @param	e:Event		The Event passed during the process.
		 * @return	void
		 * 
		 * Check if mouse cursor leaves the boundaries of the main view and stops dragging if it happens.
		 */
		protected function monitorMouseInBounds(e:Event):void
		{
			var mouseX:Number = surface.mouseX;
			var mouseY:Number = surface.mouseY;
			if (mouseX < 0 || mouseX > surface.elementWidth || mouseY < 0 || mouseY > surface.elementHeight) {
				img.stopDrag();
			}
		}
	}
}