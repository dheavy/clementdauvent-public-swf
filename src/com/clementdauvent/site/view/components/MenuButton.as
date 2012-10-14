package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.context.ApplicationContext;
	import com.clementdauvent.site.controller.events.MenuEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class MenuButton extends Sprite
	{
		public static const HEIGHT:Number = 25;
		
		protected var _id:int;
		protected var _labelStr:String;
		protected var _url:String;
		
		protected var _background:Shape;
		protected var _overlay:Shape;
		protected var _labelTxt:TextField;
		
		public function MenuButton(id:int, label:String, url:String, width:Number)
		{
			_id = id;
			_labelStr = label;
			_url = url;
			
			init(width);
		}
		
		protected function init(width:Number):void
		{
			_background = new Shape();
			_background.graphics.beginFill(0x111111);
			_background.graphics.drawRect(0, 0, width, HEIGHT);
			_background.graphics.endFill();
			addChild(_background);
			
			_overlay = new Shape();
			_overlay.graphics.beginFill(0xAAAAAA);
			_overlay.graphics.drawRect(0, 0, width, HEIGHT);
			_overlay.graphics.endFill();
			_overlay.scaleY = 0;
			addChild(_overlay);
			
			var font:NormalFont = new NormalFont();
			var format:TextFormat = new TextFormat(font.fontName, 12, 0xFFFFFF);
			format.align = TextFormatAlign.CENTER;
			format.letterSpacing = -.25;
			_labelTxt = new TextField();
			_labelTxt.height = 20;
			_labelTxt.embedFonts = true;
			_labelTxt.defaultTextFormat = format;
			_labelTxt.width = width;
			_labelTxt.y = (_background.height - _labelTxt.height) / 2;
			_labelTxt.antiAliasType = AntiAliasType.ADVANCED;
			_labelTxt.selectable = false;
			_labelTxt.text = _labelStr.toUpperCase();
			_labelTxt.mouseEnabled = false;
			addChild(_labelTxt);
			
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function mouseOverHandler(e:MouseEvent):void
		{
			TweenMax.to(_overlay, .25, { scaleY: 1, ease: Circ.easeOut } );
		}
		
		protected function mouseOutHandler(e:MouseEvent):void
		{
			TweenMax.to(_overlay, .25, { scaleY: 0, ease: Circ.easeOut } );
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.MENU_CLICKED, _id, true));
		}
	}
}