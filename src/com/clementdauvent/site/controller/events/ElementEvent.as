package com.clementdauvent.site.controller.events
{
	import flash.events.Event;
	
	public class ElementEvent extends Event
	{
		public static const SELECT:String = "imageSelect";
		public static const IMG_MOUSE_OVER:String = "imageMouseOver";
		public static const DISPLAY_DESCRIPTION:String = "displayDescription";
		
		public var info:*;
		
		public function ElementEvent(type:String, info:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.info = info;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @public	clone
		 * @return	An instance of ImageEvent cloned from this one.
		 */
		override public function clone():Event
		{
			return new ElementEvent(type, info, bubbles, cancelable);
		}
		
		/**
		 * @public	toString
		 * @return	A String-formatted representation of this instance.
		 */
		override public function toString():String
		{
			return formatToString("ElementEvent", "info", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}