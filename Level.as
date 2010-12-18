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
		
		[Embed(source="images/bg.png")]
		public static const bgGfx: Class;
		
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
			super.update();
			
			if (bonesLeft > 0) {
				if (Math.random() < 0.01) {
					add(new Bone());
					bonesLeft--;
				}
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

