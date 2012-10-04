package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.view.components.TextElement;
	import com.clementdauvent.site.utils.Logger;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator for TextElement instances.</p>
	 */
	public class TextElementMediator extends Mediator
	{
		/**
		 * The injected TextElement to mediate.
		 */
		[Inject]
		public var txt:TextElement;
		
		/**
		 * The injected singleton reference of the MainView where the TextElement is stored.
		 */
		[Inject]
		public var surface:ContainerView;
		
		/**
		 * @private	Whether or not the SHIFT key is being pressed by the user.
		 */
		protected var _shiftKeyPressed:Boolean;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Register listener for when TextElement is added to stage, in order to initialize its behaviours.
		 */
		override public function onRegister():void
		{
			_shiftKeyPressed = false;
			txt.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		/**
		 * @private	initView
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Initializes the behaviour of the view.
		 */
		protected function initView(e:Event):void
		{
			txt.removeEventListener(Event.ADDED_TO_STAGE, initView);
		}
	}
}