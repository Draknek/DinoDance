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
		public function Level ()
		{
			add(new Player());
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
			
			if (Math.random() < 0.01) {
				add(new Bone());
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}

