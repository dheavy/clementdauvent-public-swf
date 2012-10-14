package com.clementdauvent.site.model.vo
{
	/**
	 * <p>Value Object holding references to element constitutive of Text sections.</p>
	 */
	public class TextVO
	{
		protected var _id:int;
		
		/**
		 * @private	The title of the text content.
		 */
		protected var _title:String;
		
		/**
		 * @private	The actual content of this text section.
		 */
		protected var _content:String;
		
		/**
		 * @private	Whether or not this section displays itself first on the website.
		 */
		protected var _isFirst:Boolean;
		
		/**
		 * @private	The horizontal offset, in pixels, from the previous element in the list.
		 */
		protected var _xOffset:Number;
		
		/**
		 * @private	The vertical offset, in pixels, from the previous element in the list.
		 */
		protected var _yOffset:Number;
		
		/**
		 * @private	The reference scale to use when creating the content.
		 */
		protected var _scale:Number;
		
		/**
		 * @public 	TextVO
		 * @param	id:int				ID of the content.
		 * @param	title:String		The title of the text content.
		 * @param	content:String		The actual content of this text section.
		 * @param	isFirst:Boolean		Whether or not this section displays itself first on the website.
		 * @param	xOffset:Number		The horizontal offset, in pixels, from the previous element in the list. Defaults to 0.
		 * @param	yOffset:Number		The vertical offset, in pixels, from the previous element in the list. Defaults to 0.
		 * @param	scale:Number		The reference scale to use when creating the element.
		 * 
		 * Creates a new instance of TextVO, a Value Object holding references to element constitutive of Text sections.
		 */
		public function TextVO(id:int, title:String, content:String, isFirst:Boolean, xOffset:Number = 0, yOffset:Number = 0, scale:Number = 1)
		{
			_id = id;
			_title = title;
			_content = content;
			_isFirst = isFirst;
			_xOffset = xOffset;
			_yOffset = yOffset;
			_scale = scale;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		/**
		 * @return	The title of the text section.
		 */
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * @return	The content of the text section.
		 */
		public function get content():String
		{
			return _content;
		}
		
		/**
		 * @return	The horizontal offset of the element relative to the previous element in the list.
		 */
		public function get xOffset():Number
		{
			return _xOffset;
		}
		
		/**
		 * @return	The vertical offset of the element relative to the previous element in the list.
		 */
		public function get yOffset():Number
		{
			return _yOffset;
		}
		
		/**
		 * @return	The scale of the element.
		 */
		public function get scale():Number
		{
			return _scale;
		}
		
		/**
		 * @public	Sets the scale of the element.
		 * @param	value:Number	New value for scale.
		 */
		public function set scale(value:Number):void
		{
			_scale = value;
		}
		
		/**
		 * @private Sets the string used as title for the text section.
		 * @param	value:String	New value for title.
		 */
		public function set title(value:String):void
		{
			_title = value;
		}
		
		/**
		 * @private	Sets the string used as content for the text section.
		 * @param	value:String	New value for content.
		 */
		public function set content(value:String):void
		{
			_content = value;
		}
		
		/**
		 * @private	Sets the value of whether this section appears first on the website.
		 * @param	value:Boolean	New value for isFirst.
		 */
		public function set isFirst(value:Boolean):void
		{
			_isFirst = value;
		}
		
		/**
		 * @private	Sets the horizontal offset from the previous element on the list.
		 * @param	value:Number	New value for xOffset.
		 */
		public function set xOffset(value:Number):void
		{
			_xOffset = value;
		}
		
		/**
		 * @private	Sets the vertical offset from the previous element on the list.
		 * @param	value:Number	New value for yOffset.
		 */
		public function set yOffset(value:Number):void
		{
			_yOffset = value;
		}
	}
}