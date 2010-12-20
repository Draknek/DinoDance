package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class Bone extends b2Entity
	{
		public var sticky:Boolean = false;
		public var bonus:Boolean = false;
		
		public var id:int;
		
		[Embed(source="images/bone.png")]
		public static const boneGfx: Class;
		
		public var w:Number;
		public var h:Number;
		
		public function Bone (data:ByteArray = null, offset:Number = 0)
		{
			var angle:Number = 0;
			var angularVelocity:Number = 0;
			
			var s:Sprite = new Sprite;
			var shape:Object;
			
			if (data) {
				x = data.readFloat() + offset;
				y = data.readFloat();
				angle = data.readFloat();
				w = data.readFloat();
				h = data.readFloat();
			} else {
				x = Math.random()*(240/16) + 320/16;
				y = -240/16;
				angle = Math.random()*Math.PI;
				angularVelocity = Math.random()*8 - 4;
				
				if (bonus) {
					w = Math.random() * 2 + 1;
					h = w * (1.0 + Math.random() * 0.4 - 0.2);
				} else {
					w = Math.random() * 4 + 3;
					h = Math.random() * 0.5 + 0.5;
				}
			}
			
			if (bonus) {
				var bitmap:Bitmap = BoneGraphics.getBonus();
	
				bitmap.x = -w*0.5;
				bitmap.y = -h + 0.25;
	
				bitmap.scaleX = w / bitmap.width;
				bitmap.scaleY = h / bitmap.height;
		
				if (Math.random() < 0.5) { bitmap.scaleX *= -1; bitmap.x += w; }
	
				s.addChild(bitmap);
		
				shape = 0.25;
			} else {
				bitmap = BoneGraphics.getBone();
		
				var w2:Number = w + h;
				var h2:Number = h + h;
		
				bitmap.x = -w2*0.5;
				bitmap.y = -h2*0.5;
		
				bitmap.scaleX = w2 / bitmap.width;
				bitmap.scaleY = h2 / bitmap.height;
		
				s.addChild(bitmap);
			
				shape = {w:w, h:h};
			}
			
			super(x, y, shape, s, {
				angle: angle,
				angularVelocity: angularVelocity
			});
		}
		
		public override function update ():void
		{
			super.update();
			
			if (y > 960 / 16) {
				world.remove(this);
			}
		}
	}
}

