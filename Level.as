package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Level extends b2Level
	{
		public var bonesLeft:int;
		
		public var paused:Boolean = false;
		public var gameOver:Boolean = false;
		
		[Embed(source="images/bg.jpg")]
		public static const bgGfx: Class;
		
		public var ui:Sprite = new Sprite;
		
		public function Level ()
		{
			addGraphic(new Stamp(bgGfx), 0);
			
			bonesLeft = 20 + Math.random()*20;
			
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
			if (Input.pressed(Key.R)) { FP.world = new Level; }
			
			if (Input.pressed(Key.P)) { paused = !paused; }
			
			if (Input.pressed(Key.D)) { debug = !debug; }
			
			if (paused) { return; }
			
			super.update();
			
			if (bonesLeft > 0) {
				if (Math.random() < 0.01) {
					add(new Bone());
					bonesLeft--;
				}
			}
			
			if (!gameOver && bonesLeft <= 0) {
				var fallingCount:int = 0;
				
				var bones:Array = [];
				
				getClass(Bone, bones);
				
				for each (var b:Bone in bones) {
					if (! b.sticky) {
						fallingCount++;
					}
				}
				
				if (fallingCount == 0) {
					ui.addChild(new MyTextField(320, 180, "Wow! You've discovered\na new type of dinosaur!\n\n Do you want to name it?", "center", 30));
					
					gameOver = true;
				}
			}
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

