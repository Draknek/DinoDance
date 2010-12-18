package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import flash.display.*;
	
	public class ContactListener extends b2ContactListener
	{
		private static function test (a:b2Entity, b:b2Entity, c:Class):b2Entity {
			if (a is c) return a;
			if (b is c) return b;
			return null;
		}
		
		public override function PostSolve (contact:b2Contact, impulse:b2ContactImpulse):void
		{
			var a:b2Entity = contact.GetFixtureA().GetBody().GetUserData() as b2Entity;
			var b:b2Entity = contact.GetFixtureB().GetBody().GetUserData() as b2Entity;
			
			var manifold:b2WorldManifold = new b2WorldManifold();
			contact.GetWorldManifold(manifold);
			
			var p:b2Vec2 = manifold.m_points[0];
			var n:b2Vec2 = manifold.m_normal;
			
			var catcher:Catcher = test(a, b, Catcher) as Catcher;
			var floor:Floor = test(a, b, Floor) as Floor;
			var bone:Bone = test(a, b, Bone) as Bone;
			
			if (bone && floor) {
				if (bone.world) bone.world.remove(bone);
			}/*
			
			if (ball && block) {
				if (block.body.GetType() != b2Body.b2_dynamicBody) {
					Level.score.value += (Level.combo.value + 1) * 10;
					
					block.wakeUp();
					
					var f:b2Vec2 = n.Copy();
					var size:Number = 10 * block.body.GetMass();
					f.Multiply((block == a) ? size : -size);
					block.body.ApplyImpulse(f, p);
					
					p.x = block.x;
					p.y = block.y - block.h;
					n.Multiply(-1);
					//Level.addParticles(p, 0xFFFFFF, new b2Vec2(0, -1), new b2Vec2(0, -100));
				}
			}*/
		}
	}
}

