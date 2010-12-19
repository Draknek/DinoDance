package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.net.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Level extends b2Level
	{
		public var bonesLeft:int;
		public var boneDelay:int;
		public var time:int;
		
		public var name:String;
		
		public static const BUILDING:int = 10;
		public static const NAMING:int = 20;
		public static const CREDITING:int = 30;
		public static const DISPLAYING:int = 40;
		
		public var paused:Boolean = false;
		public var state:int = BUILDING;
		
		[Embed(source="images/bg.jpg")]
		public static const bgGfx: Class;
		
		public var ui:Sprite = new Sprite;
		public var text:MyTextField;
		
		public static const so:SharedObject = SharedObject.getLocal("dinobones", "/");
		
		public function Level ()
		{
			addGraphic(new Stamp(bgGfx), 0);
			
			bonesLeft = 20 + Math.random()*20;
			
			boneDelay = 0;//150;
			
			text = new MyTextField(320, 20, "", "center", 30);
			
			ui.addChild(text);
			
			add(new Catcher());
			
			add(new Floor());
			
			// Walls
			add(new b2Entity(0, 0, [
				{p: [0, -480/SCALE, 0, 480/SCALE]},
				{p: [640/SCALE, -480/SCALE, 640/SCALE, 480/SCALE]},
				{p: [0, -480/SCALE, 640/SCALE, -480/SCALE]}
			], new Sprite, {
				type: b2Body.b2_staticBody,
				friction: 0.0,
				restitution: 0.2
			}));
			
			physics.SetContactListener(new ContactListener());
		}
		
		public override function update (): void
		{
			if (state == BUILDING) {
				if (Input.pressed(Key.R)) { FP.world = new Level; }
			
				if (Input.pressed(Key.P)) { paused = !paused; }
			
				if (Input.pressed(Key.D)) { debug = !debug; }
			}
			
			if (paused) { return; }
			
			time++;
			
			super.update();
			
			if (bonesLeft > 0) {
				boneDelay--;
				if (boneDelay <= 0) {
					add(new Bone());
					bonesLeft--;
					
					boneDelay = 10;//Math.sqrt(Math.random()) * 75 + 20 + (1 - Math.sqrt(Math.random())) * 30;
				}
			}
			
			if (state == BUILDING && bonesLeft <= 0) {
				var fallingCount:int = 0;
				
				var bones:Array = [];
				
				getClass(Bone, bones);
				
				for each (var b:Bone in bones) {
					if (! b.sticky) {
						fallingCount++;
					}
				}
				
				if (fallingCount == 0) {
					
					Input.keyString = "";
					
					state = NAMING;
					
					remove(classFirst(Floor));
				}
			}
			
			if (state == NAMING) {
				if (Input.pressed(Key.ENTER)) {
					state = CREDITING;
					
					name = Input.keyString;
					
					Input.keyString = so.data.playerName || "";
					
					return;
				} else {
					text.text = "Wow! You've discovered\na new type of dinosaur!\n\n You should name it!\n\n";
					text.text += magicText();
				}
			}
			
			if (state == CREDITING) {
				if (Input.pressed(Key.ENTER)) {
					state = DISPLAYING;
					
					so.data.playerName = Input.keyString;
					
					so.flush();
					
					return;
				} else {
					text.text = "The " + name + "\nwas discovered by:\n";
					
					text.text += magicText();
				}
			}
			
			if (state == DISPLAYING) {
				text.text = "The " + name + "\nwas discovered by\n" + so.data.playerName;
			}
		}
		
		public function magicText (): String
		{
			Input.keyString = Input.keyString.substr(0, 30);
			
			var text:String = Input.keyString;
			
			var cursor:Boolean = (time % 60 < 30);
			
			if (cursor) {
				text = " " + text;
			}
			
			if (cursor) {
				text += '_';
			}
			
			return text;
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

