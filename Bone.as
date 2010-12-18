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
		
		[Embed(source="images/bone.png")]
		public static const boneGfx: Class;
		
		public function Bone ()
		{
			var s:Sprite = new Sprite;
			
			var bitmap:Bitmap = BoneGraphics.getBone();
			
			var w:Number = Math.random() * 4 + 3;
			var h:Number = Math.random() * 0.5 + 0.5;
			
			var w2:Number = w + h;
			var h2:Number = h + h;
			
			bitmap.x = -w2*0.5;
			bitmap.y = -h2*0.5;
			
			bitmap.scaleX = w2 / bitmap.width;
			bitmap.scaleY = h2 / bitmap.height;
			
			s.addChild(bitmap);
			
			super(Math.random()*(240/16) + 320/16, -240/16, {w:w, h:h}, s, {angle: Math.random()*Math.PI, angularVelocity: Math.random()*8 - 4});
		}
	}
}

