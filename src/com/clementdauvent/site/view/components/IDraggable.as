package com.clementdauvent.site.view.components
{
	/**
	 * <p>Interface for draggable objects.</p>
	 */
	public interface IDraggable
	{
		function get id():uint;
		function get x():Number;
		function get y():Number;
		function get isFirst():Boolean;
		function get scale():Number;
		function toString():String;
	}
}