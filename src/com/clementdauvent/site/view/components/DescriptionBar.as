package com.clementdauvent.site.view.components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import com.greensock.TweenMax;
	
	public class DescriptionBar extends Sprite
	{
		public static const HEIGHT:Number = 50;
		
		protected var _background:Shape;
		protected var _textfield:TextField;
		
		public function DescriptionBar()
		{
			init();
		}
		
		public function drawBackground():void
		{
			if (_background && stage) {
				_background.graphics.beginFill(0xFFFFFF);
				_background.graphics.drawRect(0, 0, stage.stageWidth, DescriptionBar.HEIGHT);
				_background.graphics.endFill();
				
				repositionText();
			}
		}
		
		public function setDescription(value:String):void
		{
			TweenMax.to(_textfield, 0, { alpha: 0 });
			_textfield.text = value;
			TweenMax.to(_textfield, .25, { alpha: 1 });
		}
		
		protected function init():void
		{
			_background = new Shape();
			drawBackground();
			addChild(_background);
			
			var font:NormalFont = new NormalFont();
			var format:TextFormat = new TextFormat(font.fontName, 14, 0x111111, null, null, null, null, null, TextFormatAlign.CENTER);
			_textfield = new TextField();
			_textfield.embedFonts = true;
			_textfield.defaultTextFormat = format;
			_textfield.antiAliasType = AntiAliasType.ADVANCED;
			_textfield.selectable = false;
			addChild(_textfield);
			repositionText();
		}
		
		protected function repositionText():void
		{
			if (_background && _textfield) {
				_textfield.x = 0;
				_textfield.width = _background.width;
				_textfield.height = HEIGHT / 2;
				_textfield.y = HEIGHT / 4;
			}
		}
	}
}