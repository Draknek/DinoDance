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
	
	public class Catcher extends b2Entity
	{
		public function Catcher ()
		{
			var s:Sprite = new Sprite;
			
			var w:Number = 240/16;
			var h:Number = 1;
			
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(-120/16, -0.5, w, h);
			s.graphics.endFill();
			
			super(320/16, 480/16, {w:w, h:h}, s, {friction: 5, restitution: 0});
			
			body.SetType(b2Body.b2_kinematicBody);
			body.SetLinearDamping(0);
		}
		
		public override function update ():void
		{
			super.update();
			
			var v:b2Vec2 = new b2Vec2(Input.mouseX / b2Level.SCALE - x, 0);
			
			var l:Number = v.Length();
			
			v.Multiply(FP.assignedFrameRate * 0.2);
			
			body.SetLinearVelocity(v);
		}
	}
}

