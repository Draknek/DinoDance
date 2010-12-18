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
			if (!params) params = {};
			
			// Vars used to create bodies
			var bodyDef:b2BodyDef;
			
			bodyDef = new b2BodyDef();
			bodyDef.position.x = x;
			bodyDef.position.y = y;
			bodyDef.userData = this;
			bodyDef.type = params.hasOwnProperty("type") ? params.type : b2Body.b2_dynamicBody;
			bodyDef.inertiaScale = 3.0;
			//bodyDef.linearDamping = 0.25;
			//bodyDef.angularDamping = 1.0;
			
			if (params.hasOwnProperty("angle")) {
				bodyDef.angle = params.angle;
			}
			
			body = b2Level.physics.CreateBody(bodyDef);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
			fixtureDef.density = params && params.hasOwnProperty("density") ? params.density : 1.0;
			fixtureDef.friction = params.hasOwnProperty("friction") ? params.friction : 1.0;
			fixtureDef.restitution = params.hasOwnProperty("restitution") ? params.restitution : 0.0;
			
			createShape(body, fixtureDef, shape);
			
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
			if (sprite.parent) {
				sprite.parent.removeChild(sprite);
			}
			
			body.GetWorld().DestroyBody(body);
		}
		
		public function get vx ():Number { return body.GetLinearVelocity().x; }
		public function get vy ():Number { return body.GetLinearVelocity().y; }
		
		public static function createShape (body:b2Body, fixtureDef:b2FixtureDef, shape:Object): b2Fixture
		{
			if (shape is Array) {
				for each (var s:Object in shape) {
					createShape(body, fixtureDef, s);
				}
				
				return null;
			} else if (shape is b2Shape) {
				fixtureDef.shape = shape as b2Shape;
			} else if (shape is Number) {
				
			} else if (shape.hasOwnProperty("w") && shape.hasOwnProperty("h")) {
				var w:Number = shape.w * 0.5;
				var h:Number = shape.h * 0.5;
				var boxShape:b2PolygonShape = b2PolygonShape.AsBox(w, h);
				fixtureDef.shape = boxShape;
			} else if (shape.hasOwnProperty("x1") && shape.hasOwnProperty("y1")
				&& shape.hasOwnProperty("x2") && shape.hasOwnProperty("y2"))
			{
				var lineShape:b2PolygonShape = b2PolygonShape.AsEdge(new b2Vec2(shape.x1, shape.y1), new b2Vec2(shape.x2, shape.y2));
				fixtureDef.shape = lineShape;
			} else if (shape.hasOwnProperty("p"))
			{
				var p:Array = shape.p as Array;
				
				lineShape = b2PolygonShape.AsEdge(new b2Vec2(p[0], p[1]), new b2Vec2(p[2], p[3]));
				fixtureDef.shape = lineShape;
			}
			
			return body.CreateFixture(fixtureDef);
		}
	}
}

