package com.clementdauvent.site.view.mediators
{
	import com.clementdauvent.site.controller.events.DataFetchEvent;
	import com.clementdauvent.site.model.ApplicationModel;
	import com.clementdauvent.site.model.vo.DataVO;
	import com.clementdauvent.site.model.vo.ImageVO;
	import com.clementdauvent.site.model.vo.TextVO;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.view.components.IDraggable;
	import com.clementdauvent.site.view.components.Image;
	import com.clementdauvent.site.view.components.TextElement;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.utils.Timer;
	
	import org.robotlegs.mvcs.Context;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * <p>Mediator dealing with the ContainerView view component.</p>
	 */
	public class ContainerViewMediator extends Mediator
	{
		/**
		 * Max value for velocity.
		 */
		public static const MAX_VELOCITY:Number = 60;
		
		/**
		 * The injected ContainerView instance mediated by this Mediator. 
		 */
		[Inject]
		public var view:ContainerView;
		
		/**
		 * The injected ApplicationModel instance.
		 */
		[Inject]
		public var model:ApplicationModel;
		
		/**
		 * @private	The reference to MainScreen inside ContainerView.
		 */
		protected var _surface:Sprite;
		
		/**
		 * @private	Whether or not the user is currently trying to move around the gridded view.
		 */
		protected var _isDragged:Boolean = false;
		
		/**
		 * @private	A calculated horizontal offset between the click point and the top-left corner of the view.
		 */
		protected var _offsetX:Number = 0;
		
		/**
		 * @private	A calculated vertical offset between the click point and the top-left corner of the view.
		 */
		protected var _offsetY:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _prevX:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _prevY:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _vx:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _vy:Number = 0;
		
		/**
		 * @private	Used to compute interia.
		 */
		protected var _friction:Number = .8;
		
		/**
		 * @public	onRegister
		 * @return	void
		 * 
		 * Invoked when this mediator is registered. Add a listener reacting to addition of the view to the display list, launching setup around it.
		 */
		override public function onRegister():void
		{
			view.addEventListener(Event.ADDED_TO_STAGE, initView);
		}
		
		/**
		 * @public	viewAll
		 * @return	void
		 * 
		 * Sets the zoom level in a way that it displays fully, covering up the most possible Stage real-estate as possible.
		 */
		public function viewAll():void
		{
			var ratio:Number = _surface.stage.stageHeight / _surface.height;
			_surface.scaleX = _surface.scaleY = ratio;
			_surface.x = (_surface.stage.stageWidth - _surface.width) / 2;
			_surface.y = (_surface.stage.stageHeight - _surface.height) / 2;
		}
		
		public function zoomOnOpening():void
		{
			var ratio:Number = model.referenceHeight / _surface.height;
			_surface.scaleX = _surface.scaleY = ratio;
		}
		
		/**
		 * @private	initView
		 * @param	e:MouseEvent	The Event object passed during the process.
		 * @return	void
		 * 
		 * Invoked when the mediated view is added to the display list: starts configuring it.
		 */
		protected function initView(e:Event):void
		{
			view.removeEventListener(Event.ADDED_TO_STAGE, initView);
			_surface = view.mainScreen;
			
			_surface.addEventListener(Event.ENTER_FRAME, monitorDrag);
			_surface.addEventListener(MouseEvent.MOUSE_DOWN, view_mouseDownHandler);
			_surface.addEventListener(MouseEvent.MOUSE_UP, view_mouseReleaseHandler);
			_surface.addEventListener(MouseEvent.MOUSE_OUT, view_mouseReleaseHandler);
			
			Logger.print("[INFO] ContainerViewMediator finished configuring the ContainerView instance");
			
			zoomOnOpening();
		}
		
		/**
		 * @private	monitorDrag
		 * @param	e:MouseEvent	The Event object passed during the process.
		 * @return	void
		 * 
		 * Monitors and applies behaviour on the view when it is dragged or released with inertia.
		 */
		protected function monitorDrag(e:Event):void
		{	
			if (_isDragged) {
				_vx = _surface.stage.mouseX - _prevX;
				_vy = _surface.stage.mouseY - _prevY;
				if (Math.abs(_vx) > MAX_VELOCITY) {
					if (_vx < 0) _vx = -MAX_VELOCITY;
					if (_vx >= 0) _vx = MAX_VELOCITY;
				}
				if (Math.abs(_vy) > MAX_VELOCITY) {
					if (_vy < 0) _vy = -MAX_VELOCITY;
					if (_vy >= 0) _vy = MAX_VELOCITY;
				}
				_prevX = _surface.stage.mouseX;
				_prevY = _surface.stage.mouseY;
				_surface.x = _surface.stage.mouseX - _offsetX;
				_surface.y = _surface.stage.mouseY - _offsetY;				
			} else {
				_vx *= _friction;
				_vy *= _friction;
				_surface.x += _vx;
				_surface.y += _vy;
			}
			
			if (Math.abs(_vx) <= .1) _vx = 0;
			if (Math.abs(_vy) <= .1) _vy = 0;
			
			trace(_vx, _vy);
			
			// Keep surface (MainScreen) within stage's boudaries.
			if (_surface.x > 0) _surface.x = 0;
			if (_surface.x < (_surface.stage.stageWidth - _surface.width)) _surface.x = _surface.stage.stageWidth - _surface.width;
			if (_surface.y > 0) _surface.y = 0;
			if (_surface.y < (_surface.stage.stageHeight - _surface.height)) _surface.y = _surface.stage.stageHeight - _surface.height;
		}
		
		/**
		 * @private	view_mouseDownHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user holds down mouse button on the view.
		 * Starts dragging it.
		 */
		protected function view_mouseDownHandler(e:MouseEvent):void
		{
			_prevX = _surface.stage.mouseX;
			_prevY = _surface.stage.mouseY;
			_offsetX = _surface.stage.mouseX - _surface.x;
			_offsetY = _surface.stage.mouseY - _surface.y;
			_isDragged = true;
		}
		
		/**
		 * @private	view_mouseReleaseHandler
		 * @param	e:MouseEvent	The MouseEvent passed during the process.
		 * @return	void
		 * 
		 * Event handler triggered when user releases the mouse button.
		 * Stops dragging the view.
		 */
		protected function view_mouseReleaseHandler(e:MouseEvent):void
		{
			_isDragged = false;	
		}			
	}
}