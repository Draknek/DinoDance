package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.display.*;
	import flash.events.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Floor extends b2Entity
	{
		public function Floor ()
		{
			var s:Sprite = new Sprite;
			
			super(0, 0, {x1:0, y1:480/16, x2:640/16, y2:480/16}, s, {
				type: b2Body.b2_staticBody,
				friction: 0.0,
				restitution: 0.2
			});
		}
	}
}

