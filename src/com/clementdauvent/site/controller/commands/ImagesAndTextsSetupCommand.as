package com.clementdauvent.site.controller.commands
{
	import com.clementdauvent.site.ClementDauventPublicSite;
	import com.clementdauvent.site.model.ApplicationModel;
	import com.clementdauvent.site.model.vo.ImageVO;
	import com.clementdauvent.site.model.vo.TextVO;
	import com.clementdauvent.site.view.components.Image;
	import com.clementdauvent.site.view.components.ContainerView;
	import com.clementdauvent.site.view.components.TextElement;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * <p>Command in charge of setting up images and texts on the MainView.</p>
	 */
	public class ImagesAndTextsSetupCommand extends Command
	{
		/**
		 * The injected singleton instance of the main application model, where the data is contained for building these elements. 
		 */
		[Inject]
		public var model:ApplicationModel;
		
		/**
		 * The injected singleton instance of the ContainerView, where the elements should appear. 
		 */
		[Inject]
		public var view:ContainerView;
		
		/**
		 * @public	execute
		 * @return	void
		 * 
		 * Executes the command, effectively building and adding to the ContainerView the set of Image and Text instances constitutive of this application.
		 */
		override public function execute():void
		{
			var images:Vector.<ImageVO> = model.data.images;
			var texts:Vector.<TextVO> = model.data.texts;
			
			var i:int = 0, j:int = 0;
			var length:int = images.length;
			
			for (i; i < length; i++) {
				var iVo:ImageVO = images[i];
				var img:Image = new Image(i, iVo.src, iVo.originalWidth, iVo.originalHeight, iVo.scale, iVo.description);
				img.x = iVo.xOffset;
				img.y = iVo.yOffset;
				view.addElement(img);
			}
			
			var k:int = 0, l:int = 0;
			length = texts.length;
			for (k; k < length; k++) {
				var tVo:TextVO = texts[k];
				var t:TextElement = new TextElement(i, tVo.title, tVo.content);
				t.x = tVo.xOffset;
				t.y = tVo.yOffset;
				t.scale = model.referenceScale;
				view.addElement(t);
			}
		}
	}
}