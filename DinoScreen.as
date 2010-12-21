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
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class DinoScreen extends b2Level
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
		
		public function DinoScreen (data:Object)
		{
			super();
			
			addGraphic(new Stamp(Level.bgGfx), 0);
			
			add(new Catcher(Input.mouseX / SCALE));
			
			contactListener = new ContactListener();
			physics.SetContactListener(contactListener);
			
			name = data.name;
			creator = data.creator;
			serverID = data.serverID;
			
			Level.buildDino(this, data.data, Input.mouseX / SCALE);
			
			var list:Array = getDinoList();
			
			var isYours:Boolean = false;
			
			for each (var dino:Object in list) {
				if (dino.serverID == serverID) {
					isYours = true;
					break;
				}
			}
			
			var challengeString:String = isYours ? "You should challenge\nsomeone to a dance-off!" : "It wants to challenge\nyou to a dance-off!";
			
			ui.addChild(new MyTextField(320, 10, name + "\nwas discovered by\n" + creator + "\n\n" + challengeString, "center", 20));
			
			if (isYours) {
				var tweet:DisplayObject = new TweetButton(name, serverID);
				tweet.x = 320 - tweet.width*0.5;
				tweet.y = 65;
				ui.addChild(tweet);
				return;
			}
			
			var newDino:Button = new Button("Find a new dinosaur", 20);
			
			newDino.x = 320 - newDino.width*0.5;
			
			newDino.addEventListener(MouseEvent.CLICK, function ():void {
				FP.world = new Level(data);
			});
			
			ui.addChild(newDino);
			
			if (list.length) {
				newDino.y = 160;
				
				ui.addChild(new MyTextField(320, 210, "Or use an existing dinosaur:", "center", 20));
				
				var hereY:Number = 180 + 60 + list.length * 30;
				
				for each (dino in list) {
					
					var useDino:Button = addDinoButton(dino, data);
					useDino.y = hereY;
					
					hereY -= 30;
			
					ui.addChild(useDino);
				}
			} else {
				newDino.y = 240 - newDino.height*0.5;
			}
		}
		
		private function addDinoButton (dino:Object, firstData:Object):Button {
			var useDino:Button = new Button(dino.name, 20);
			
			useDino.x = 320 - useDino.width*0.5;
	
			useDino.addEventListener(MouseEvent.CLICK, function ():void {
				FP.world = new Fight(firstData, dino);
			});
			
			return useDino;
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

