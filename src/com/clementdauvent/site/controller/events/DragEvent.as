package com.clementdauvent.site.controller.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * <p>Event class used when dragging surface/mainScreen or viewport in minimap.</p>
	 */
	public class DragEvent extends Event
	{
		/**
		 * Event type for "dragSurface".
		 */
		public static const DRAG_SURFACE:String = "dragSurface";
		
		/**
		 * Event type for "dragMiniMapViewport".
		 */
		public static const DRAG_MINIMAP_VIEWPORT:String = "dragMiniMapViewport";
		
		/**
		 * Point instance used to render current position in minimap or mainscreen.
		 */
		public var pos:Point;
		
		/**
		 * @public	DragEvent
		 * @param	type:String	The event type.
		 * @param	pos:Point	The point instance used to render current possition of minimap or mainscreen.
		 * @param	bubbles:Boolean	Whether or not the event should bubble.
		 * @param	cancelable:Boolean	Whether or not the event should be cancelable.
		 * 
		 * Creates an instance of DragEvent, for updating position of mainscreen and minimap.
		 */
		public function DragEvent(type:String, pos:Point, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.pos = pos;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @public	clone
		 * @return	An instance cloned from this one.
		 */
		override public function clone():Event
		{
			return new DragEvent(type, pos, bubbles, cancelable);
		}
		
		/**
		 * @public	toString
		 * @return	A String-formatted representation of this instance.
		 */
		override public function toString():String
		{
			return formatToString("DragEvent", "pos", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}