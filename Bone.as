package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.display.*;
	import flash.events.*;
	
	public class Bone extends b2Entity
	{
		public var sticky:Boolean = false;
		public var bonus:Boolean = false;
		
		public var id:int;
		
		[Embed(source="images/bone.png")]
		public static const boneGfx: Class;
		
		public function Bone ()
		{
			var s:Sprite = new Sprite;
			var shape:Object;
			
			if (Math.random() < 0.2) bonus = true;
			
			if (bonus) {
				var bitmap:Bitmap = BoneGraphics.getBonus();
			
				var w:Number = Math.random() * 2 + 1;
				var h:Number = w * (1.0 + Math.random() * 0.4 - 0.2);
			
				bitmap.x = -w*0.5;
				bitmap.y = -h + 0.25;
			
				bitmap.scaleX = w / bitmap.width;
				bitmap.scaleY = h / bitmap.height;
				
				if (Math.random() < 0.5) { bitmap.scaleX *= -1; bitmap.x += w; }
			
				s.addChild(bitmap);
				
				shape = 0.25;
			} else {
				bitmap = BoneGraphics.getBone();
			
				w = Math.random() * 4 + 3;
				h = Math.random() * 0.5 + 0.5;
			
				var w2:Number = w + h;
				var h2:Number = h + h;
			
				bitmap.x = -w2*0.5;
				bitmap.y = -h2*0.5;
			
				bitmap.scaleX = w2 / bitmap.width;
				bitmap.scaleY = h2 / bitmap.height;
			
				s.addChild(bitmap);
				
				shape = {w:w, h:h};
			}
			
			super(Math.random()*(240/16) + 320/16, -240/16, shape, s, {
				angle: Math.random()*Math.PI,
				angularVelocity: Math.random()*8 - 4
			});
		}
	}
}

