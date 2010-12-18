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
		public var debugSprite: Sprite;
		
		public static const SCALE:Number = 16;
		
		public static var debug:Boolean = false;
		
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
			
			// set debug draw
			debugSprite = new Sprite();
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(SCALE);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(0.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			physics.SetDebugDraw(debugDraw);
		}
		
		public function createStaticBody (): void
		{
			
		}
		
		public override function update (): void
		{
			physics.Step(1.0 / FP.assignedFrameRate, m_velocityIterations, m_positionIterations);

			super.update();
			
			if (debug) {
				physics.DrawDebugData();
			} else {
				debugSprite.graphics.clear();
			}
		}
		
		public override function begin (): void
		{
			FP.engine.addChild(sprite);
			if (debugSprite) FP.engine.addChild(debugSprite);
		}
		
		public override function end (): void
		{
			removeAll();
			
			FP.engine.removeChild(sprite);
			if (debugSprite) FP.engine.removeChild(debugSprite);
		}
	}
}

