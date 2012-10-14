package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.model.vo.TextVO;
	import com.clementdauvent.site.view.components.IDraggable;
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import NormalFont;
	import HeaderFont;
	
	/**
	 * <p>Draggable element on MainView containing text content</p>
	 */
	public class TextElement extends Sprite implements IDraggable
	{
		/**
		 * Default width of TextElement.
		 */
		public static const WIDTH:Number = 800;
		
		/**
		 * Default height of TextElement.
		 */
		public static const HEIGHT:Number = 600;
		
		private const FONT_COLOR:uint = 0x333333;
		private const OFFSET:Number = 30;
		
		/**
		 * @private	UID of this instance.
		 */
		protected var _id:uint;
		
		/**
		 * @private	Text for the title of this element.
		 */
		protected var _title:String;
		
		/**
		 * @private	Text for the content of this element.
		 */
		protected var _content:String;
		
		/**
		 * @private	Whether or not this element should be the opening element on the website.
		 */
		protected var _isFirst:Boolean;
		
		/**
		 * @private	The background shape of this instance.
		 */
		protected var _background:Shape;
		
		/**
		 * @private	The container for textfields in this instance.
		 */
		protected var _fieldsContainer:Sprite;
		
		/**
		 * @private	The textfield for the title.
		 */
		protected var _titleField:TextField;
		
		/**
		 * @private	The textfield for the content.
		 */
		protected var _contentField:TextField;
		
		/**
		 * @private	The scale of the element.
		 */
		protected var _scale:Number;
		
		/**
		 * @public	TextElement
		 * @param	id:uint	The UID for this instance.
		 * @param	title:String	The title of this element.
		 * @param	content:String	The text content of this element.
		 * @return	this	
		 * 
		 * Creates an instance of TextElement, draggable element in MainView containing text.
		 */
		public function TextElement(id:uint, title:String, content:String)
		{
			_id = id;
			_title = title;
			_content = content;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * @public	id
		 * @return	The UID of this instance.
		 */
		public function get id():uint
		{
			return _id;
		}
		
		/**
		 * @public	isFirst
		 * @return	Whether or not this instance should be the opening element on the website.
		 */
		public function get isFirst():Boolean
		{
			return false;
		}
		
		/**
		 * @public	elementWidth
		 * @return	The width of this element.
		 */
		public function get elementWidth():Number
		{
			return TextElement.WIDTH;
		}
		
		/**
		 * @public	elementHeight
		 * @return	The height of this element.
		 */
		public function get elementHeight():Number
		{
			return TextElement.HEIGHT;
		}
		
		/**
		 * @public	scale
		 * @return	The scale of the element.
		 */
		public function get scale():Number
		{
			return _scale;
		}
		
		/**
		 * @public	scale
		 * @param	The new value for scale.
		 * 
		 * Sets the scale of the element.
		 */
		public function set scale(value:Number):void
		{
			_scale = value;
			if (_fieldsContainer) {
				_fieldsContainer.scaleX = _fieldsContainer.scaleY = _scale;
				if (_background) {
					_fieldsContainer.x = (_background.width - _fieldsContainer.width) / 2;
					_fieldsContainer.y = (_background.height - _fieldsContainer.height) / 2;
				}
			}
		}
		
		/**
		 * @public	serialize
		 * @return	A TextVO instance, serialized version of the TextElement.
		 */
		public function serialize():TextVO
		{
			return new TextVO(id, _title, _content, isFirst, x, y);
		}
		
		/**
		 * @public	promote
		 * @param	value:Boolean	True is element is promoted, false otherwise.
		 * @return	void
		 * 
		 * Show visually if element is promoted as opening element of the website, or not.
		 */
		public function promote(value:Boolean):void
		{
			if (value) {
				TweenMax.to(_background, 1, { colorTransform: { tint: 0x00CCFF, tintAmount: .5 } }); 
			} else {
				TweenMax.to(_background, .5, { colorTransform: { tint: 0x00CCFF, tintAmount: 0 } }); 
			}
		}
		
		/**
		 * @public	toString
		 * @return	A string representation of this instance.
		 */
		override public function toString():String
		{
			return "[TextElement — id: " + id + ", title: " + _title + ", content: " + _content + ", isFirst: " + isFirst + ", x: " + x + ", y: " + y + "]";
		}
		
		/**
		 * @private	init
		 * @param	e:Event	The Event object passed during the process.
		 * @return	void
		 * 
		 * Builds the instance visually.
		 */
		protected function init(e:Event):void
		{
			_background = new Shape();
			_background.graphics.beginFill(0x000000, 0);
			_background.graphics.drawRect(0, 0, TextElement.WIDTH, TextElement.HEIGHT);
			_background.graphics.endFill();
			addChild(_background);
			
			var format1:TextFormat = new TextFormat(new HeaderFont().fontName);
			format1.color = FONT_COLOR;
			format1.size = 42;
			
			var format2:TextFormat = new TextFormat(new NormalFont().fontName);
			format2.color = FONT_COLOR;
			format2.size = 24;
			
			_fieldsContainer = new Sprite();
			addChild(_fieldsContainer);
			
			_titleField = new TextField();
			_titleField.embedFonts = true;
			_titleField.defaultTextFormat = format1;
			_titleField.text = _title;
			_titleField.selectable = false;
			_titleField.autoSize = TextFieldAutoSize.LEFT;
			_fieldsContainer.addChild(_titleField);
						
			_contentField = new TextField();
			_contentField.embedFonts = true;
			_contentField.multiline = true;
			_contentField.defaultTextFormat = format2;
			_contentField.htmlText = _content;
			_contentField.autoSize = TextFieldAutoSize.LEFT;
			_contentField.x = _titleField.x;
			_contentField.y = _titleField.y + _titleField.height + 30;
			_contentField.selectable = false;
			_fieldsContainer.addChild(_contentField);
			
			var line:Shape = new Shape();
			var lineWidth:Number = _titleField.width > _contentField.width ? _titleField.width : _contentField.width;
			line.graphics.lineStyle(1, FONT_COLOR);
			line.graphics.lineTo(lineWidth, 0);
			line.graphics.endFill();
			line.x = _contentField.x;
			line.y = _contentField.y - OFFSET / 2 - 5;
			_fieldsContainer.addChild(line);
			
			_fieldsContainer.x = (_background.width - _fieldsContainer.width) / 2;
			_fieldsContainer.y = (_background.height - _fieldsContainer.height) / 2;
			_fieldsContainer.mouseEnabled = false;
			
			// Force rescaling.
			scale = _scale;
		}		
	}
}