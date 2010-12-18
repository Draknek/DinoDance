package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import flash.display.*;
	
	public class b2Entity extends Entity
	{
		public var body: b2Body;
		private var sprite: DisplayObject;
		
		public var removeable:Boolean = true;
		
		public function b2Entity (x:Number, y:Number, shape:Object, s:DisplayObject, params:Object = null)
		{
			// Vars used to create bodies
			var bodyDef:b2BodyDef;
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
			bodyDef = new b2BodyDef();
			bodyDef.position.x = x;
			bodyDef.position.y = y;
			bodyDef.userData = this;
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.inertiaScale = 3.0;
			//bodyDef.linearDamping = 0.25;
			//bodyDef.angularDamping = 1.0;
			
			if (shape is b2Shape) {
				fixtureDef.shape = shape as b2Shape;
			} else if (shape is Number) {
				
			} else {
				var w:Number = shape.w * 0.5;
				var h:Number = shape.h * 0.5;
				var boxShape:b2PolygonShape = b2PolygonShape.AsBox(w, h);
				fixtureDef.shape = boxShape;
			}
			
			fixtureDef.density = 1.0;
			//fixtureDef.friction = friction;
			//fixtureDef.restitution = restitution;
			body = b2Level.physics.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			sprite = s;
			
			this.x = sprite.x = x;
			this.y = sprite.y = y;
		}
		
		public override function update (): void
		{
			var p: b2Vec2 = body.GetPosition();
			
			x = sprite.x = p.x;
			y = sprite.y = p.y;
			sprite.rotation = body.GetAngle() * -FP.DEG;
		}
		
		public override function added (): void
		{
			/*if (! b2Level.DEBUG)*/ b2Level(world).sprite.addChild(sprite);
		}
		
		public override function removed (): void
		{
			/*if (! b2Level.DEBUG)*/ b2Level(world).sprite.removeChild(sprite);
			body.GetWorld().DestroyBody(body);
		}
		
		public function get vx ():Number { return body.GetLinearVelocity().x; }
		public function get vy ():Number { return body.GetLinearVelocity().y; }
	}
}

