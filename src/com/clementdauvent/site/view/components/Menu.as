package com.clementdauvent.site.view.components
{
	import com.clementdauvent.site.model.vo.TextVO;
	import com.clementdauvent.site.utils.Logger;
	import com.clementdauvent.site.view.components.MenuButton;
	
	import flash.display.Sprite;
	
	public class Menu extends Sprite
	{
		public static const VERTICAL_BUTTONS_OFFSET:Number = 2;
		
		protected var _buttons:Vector.<MenuButton>;
		protected var _container:Sprite;
		
		public function Menu()
		{
			_buttons = new Vector.<MenuButton>();
		}
		
		public function createButton(id:int, label:String, url:String, width:Number, yPos:Number):void
		{
			var b:MenuButton = new MenuButton(id, label, url, width);
			_buttons.push(b);
			b.y = yPos;
			addChild(b);
			Logger.print("[INFO] MenuButton '" + label + "' added to menu.");
		}
		
		public function build(data:Vector.<TextVO>, btnWidth:Number):void
		{
			var i:int = 0;
			var len:int = data.length;
			
			for (i; i < len; i++) {
				var vo:TextVO = data[i];
				createButton(vo.id, vo.title, formatTitleForURL(vo.title), btnWidth, i * (MenuButton.HEIGHT + Menu.VERTICAL_BUTTONS_OFFSET)); 
			}
			
			Logger.print("[INFO] Menu is built");
		}
		
		protected function formatTitleForURL(title:String):String
		{
			title = title.replace(/[àáâãäå]/g, "a");
			title = title.replace(/[ÀÁÂÃÄÅ]/g, "A");
			title = title.replace(/[èéêë]/g, "e");
			title = title.replace(/[ËÉÊÈ]/g, "E");
			title = title.replace(/[ìíîï]/g, "i");
			title = title.replace(/[ÌÍÎÏ]/g, "I");
			title = title.replace(/[ðòóôõöø]/g, "o");
			title = title.replace(/[ÐÒÓÔÕÖØ]/g, "O");
			title = title.replace(/[ùúûü]/g, "u");
			title = title.replace(/[ÙÚÛÜ]/g, "U");
			title = title.replace(/[ýýÿ]/g, "y");
			title = title.replace(/[ÝÝŸ]/g, "Y");
			title = title.replace(/[ç]/g, "c");
			title = title.replace(/[Ç]/g, "C");
			title = title.replace(/[ñ]/g, "n");
			title = title.replace(/[Ñ]/g, "N");
			title = title.replace(/[š]/g, "s");
			title = title.replace(/[Š]/g, "S");
			title = title.replace(/[ž]/g, "z");
			title = title.replace(/[Ž]/g, "Z");
			title = title.replace(/[æ]/g, "ae");
			title = title.replace(/[Æ]/g, "AE");
			title = title.replace(/[œ]/g, "oe");
			title = title.replace(/[Œ]/g, "OE");
			title = title.toLowerCase();
			var whitespace:RegExp = /(\t|\n|\s{2,})/g; 	
			title = title.replace(whitespace, '-');
			return title;
		}
	}
}