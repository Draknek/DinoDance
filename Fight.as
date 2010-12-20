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
	
	public class Fight extends b2Level
	{
		public static const DOWNLOADING:int = 10;
		public static const FIGHTING:int = 20;
		public static const GLOATING:int = 30;
		
		public var paused:Boolean = false;
		public var state:int = DOWNLOADING;
		
		public var ui:Sprite = new Sprite;
		
		public var moveA:Entity;
		public var moveB:Entity;
		
		public var dinoA:Object;
		public var dinoB:Object;
		
		public var time:int;
		
		public var bIsNew:Boolean;
		
		public var contactListener:ContactListener;
		
		public function Fight (a:Object, b:Object, bIsNew:Boolean = false)
		{
			this.bIsNew = bIsNew;
			
			addGraphic(new Stamp(Level.bgGfx), 0);
			
			moveA = add(new Catcher(-320 / SCALE, false));
			moveB = add(new Catcher(960 / SCALE, false));
			
			contactListener = new ContactListener();
			physics.SetContactListener(contactListener);
			
			dinoA = a;
			dinoB = b;
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.F1)) { debug = !debug; }
			
			//if (Input.pressed(Key.P)) { paused = !paused; }
			
			if (paused) { return; }
			
			time++;
			
			super.update();
			
			if (state == DOWNLOADING) {
				if (dinoA.data && dinoB.data) {
					dinoA.bones = Level.buildDino(this, dinoA.data, moveA.x);
					dinoB.bones = Level.buildDino(this, dinoB.data, moveB.x);
				
					state = FIGHTING;
				
					FP.tween(moveA, {targetX:100 / SCALE}, 150);
					FP.tween(moveB, {targetX:540 / SCALE}, 150);
				
					ui.addChild(new MyTextField(150, 10, dinoA.name, "center", 20));
					ui.addChild(new MyTextField(150, 30, "discovered by", "center", 10));
					ui.addChild(new MyTextField(150, 40, dinoA.creator, "center", 20));
				
					ui.addChild(new MyTextField(490, 10, dinoB.name, "center", 20));
					ui.addChild(new MyTextField(490, 30, "discovered by", "center", 10));
					ui.addChild(new MyTextField(490, 40, dinoB.creator, "center", 20));
				
					ui.addChild(new MyTextField(320, 15, "VS", "center", 50));
				
					time = 0;
				}
				
				return;
			}
			
			if (state == FIGHTING) {
				if (time > 60*10) {
					contactListener.doStuff = false;
					
					var killA:Boolean = Math.random() < 0.5;
					
					remove(killA ? moveA : moveB);
					
					FP.tween(killA ? moveB : moveA, {targetX: 320/SCALE}, 2.5);
					
					state = GLOATING;
					
					while (ui.numChildren) ui.removeChildAt(0);
					
					ui.addChild(new MyTextField(320, 10, (killA ? dinoB : dinoA).name, "center", 40));
					ui.addChild(new MyTextField(320, 60, FP.choose(["wins!", "is the #1 dancer", "rocked the dancefloor away"]), "center", 30));
					
					if (killA) {
						ui.addChild(new MyTextField(320, 100, FP.choose(["Nice job!", "Well done!"]), "center", 20));
					} else {
						ui.addChild(new MyTextField(320, 100, FP.choose(["Too bad", "Better luck next time"]), "center", 20));
					}
					
					ui.addChild(new MyTextField(320, 150, (bIsNew ? "Here" : "Remember, here") + "'s the link to your dinosaur:", "center", 20));
					ui.addChild(Level.makeURLText(dinoB.serverID, 175));
				}
			}
		}
		
		private function downloadData (name:Object, data:Object):void {
			var request:URLRequest = new URLRequest(Main.url + "get.php?id=" + name);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, doComplete);
			loader.load(request);
			
			function doComplete ():void
			{
				var pieces:Array = loader.data.split("\n");
				
				data.name = pieces[0];
				data.creator = pieces[1];
				data.data = Base64.decode(pieces[2]);
			}
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

