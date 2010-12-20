package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Menu extends b2Level
	{
		public static const DOWNLOADING:int = 10;
		public static const FIGHTING:int = 20;
		public static const GLOATING:int = 30;
		
		public var name:String;
		public var creator:String;
		public var serverID:String;
		
		public var paused:Boolean = false;
		public var state:int = DOWNLOADING;
		
		public var ui:Sprite = new Sprite;
		
		public var time:int;
		
		public var contactListener:ContactListener;
		
		public function Menu ()
		{
			super();
			
			addGraphic(new Stamp(Level.bgGfx), 0);
			
			ui.addChild(new MyTextField(320, 20, "Dinosaur\nDance-Off", "center", 50));
			
			var button:Button = new Button("Create dinosaur", 30);
			
			button.x = 320 - button.width * 0.5;
			
			ui.addChild(button);
			
			button.addEventListener(MouseEvent.CLICK, function ():void {
				FP.world = new Level;
			});
			
			var list:Array = getDinoList();
			
			if (list.length) {
				button.y = 160;
				
				var hereY:Number = 160 + 30 + list.length * 30;
				for (var i:int = 0; i < list.length; i++) {
					var dino:Object = list[i];

					var useDino:DisplayObject = addDinoButton(dino);
					useDino.y = hereY;
					
					hereY -= 30;
			
					ui.addChild(useDino);
				}
			} else {
				button.y = 240 - button.height*0.5;
			}
		}
		
		private function addDinoButton (dino:Object):DisplayObject {
			var url:String = Main.url + "?dino=" + dino.serverID;
			var ss:StyleSheet = new StyleSheet();
			ss.parseCSS("a:hover { text-decoration: underline; } a { text-decoration: none; }");
			
			var urlText:MyTextField = new MyTextField(320, 0, url, "center", 20);
			
			urlText.mouseEnabled = true;
			
			urlText.htmlText = '<a href="' + url + '">' + dino.name + '</a>';
			urlText.styleSheet = ss;
			
			return urlText;
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.F1)) { debug = !debug; }
		
			//if (Input.pressed(Key.P)) { paused = !paused; }
			
			if (paused) { return; }
			
			time++;
			
			super.update();
		}
		
		private function getDinoList ():Array
		{
			if (Level.so.data.dinos) return Level.so.data.dinos;
			
			Level.so.data.dinos = new Array;
			
			Level.so.flush();
			
			return Level.so.data.dinos;
		}
		
		public override function render (): void
		{
			super.render();
		}
		
		public override function begin (): void
		{
			super.begin();
			FP.engine.addChild(ui);
		}
		
		public override function end (): void
		{
			super.end();
			FP.engine.removeChild(ui);
		}
	}
}

