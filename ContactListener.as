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
	import Box2D.Dynamics.Joints.*;
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
			}
			
			if (bone && catcher) {
				stick(bone, catcher, p);
			}
			
			var bone2:Bone = (a is Bone && b is Bone) ? b as Bone : null;
			
			if (bone && bone2 && (bone.sticky || bone2.sticky)) {
				stick(bone, bone2, p);
			}
		}
		
		public static function stick (a:b2Entity, b:b2Entity, p:b2Vec2):b2Joint
		{
			var jointDef:b2WeldJointDef = new b2WeldJointDef;
			
			jointDef.Initialize(a.body, b.body, p);
			
			if (a is Bone) Bone(a).sticky = true;
			if (b is Bone) Bone(b).sticky = true;
			
			return b2Level.physics.CreateJoint(jointDef);
		}
	}
}

