package com.clementdauvent.site.controller.events
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const MENU_CLICKED:String = "menuClicked";
		
		public var id:int;
		
		public function MenuEvent(type:String, id:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.id = id;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new MenuEvent(type, id, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("MenuEvent", "id", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}