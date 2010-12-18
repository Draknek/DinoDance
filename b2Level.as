package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.tweens.misc.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.events.*;
	
	public class b2Level extends World
	{
		public static var physics: b2World;
		public var physics: b2World;
		
		public var sprite: Sprite;
		
		public static const SCALE:Number = 16;
		
		public static const DEBUG:Boolean = false;
		
		public var m_velocityIterations:int = 10;
		public var m_positionIterations:int = 10;
		
		public function b2Level (startScreenMode:Boolean = true)
		{
			sprite = new Sprite;
			sprite.scaleX = SCALE;
			sprite.scaleY = SCALE;
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 20);
			
			// Allow bodies to sleep
			var doSleep:Boolean = false;
			
			// Construct a world object
			b2Level.physics = physics = new b2World(gravity, doSleep);
			
			//physics.SetContactListener(new ContactListener());
			
			// set debug draw
			if (DEBUG)
			{
				var debugSprite:Sprite = new Sprite();
				sprite.addChild(debugSprite);
				var debugDraw:b2DebugDraw = new b2DebugDraw();
				debugDraw.SetSprite(debugSprite);
				//debugDraw.SetDrawScale(SCALE);
				debugDraw.SetFillAlpha(0.3);
				debugDraw.SetLineThickness(1.0);
				debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
				physics.SetDebugDraw(debugDraw);
				physics.DrawDebugData();
			}
			
			// Vars used to create bodies
			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.friction = 0.0;
			fixtureDef.restitution = 0.2;
			
			bodyDef = new b2BodyDef();
			bodyDef.position.x = 0;
			bodyDef.position.y = 0;
			bodyDef.type = b2Body.b2_staticBody;
			var body:b2Body = physics.CreateBody(bodyDef);
			
			boxShape = b2PolygonShape.AsEdge(new b2Vec2(0, 0), new b2Vec2(0, 480/SCALE));
			fixtureDef.shape = boxShape;
			body.CreateFixture(fixtureDef);
			
			boxShape = b2PolygonShape.AsEdge(new b2Vec2(0, 480/SCALE), new b2Vec2(640/SCALE, 480/SCALE));
			fixtureDef.shape = boxShape;
			body.CreateFixture(fixtureDef);
			
			boxShape = b2PolygonShape.AsEdge(new b2Vec2(640/SCALE, 480/SCALE), new b2Vec2(640/SCALE, 0));
			fixtureDef.shape = boxShape;
			body.CreateFixture(fixtureDef);
			
			boxShape = b2PolygonShape.AsEdge(new b2Vec2(640/SCALE, 0), new b2Vec2(0, 0));
			fixtureDef.shape = boxShape;
			body.CreateFixture(fixtureDef);
			
		}
		
		public override function update (): void
		{
			/*if (Input.pressed(Key.SPACE)) { paused = !paused; }
			
			if (paused || gameOver) { return; }*/
			
			physics.Step(1.0 / FP.assignedFrameRate, m_velocityIterations, m_positionIterations);

			super.update();
			
			physics.DrawDebugData();
		}
		
		public override function begin (): void
		{
			FP.engine.addChild(sprite);
		}
		
		public override function end (): void
		{
			removeAll();
			
			FP.engine.removeChild(sprite);
		}
	}
}
