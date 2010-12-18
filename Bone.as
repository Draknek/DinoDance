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
		public function Bone ()
		{
			var s:Sprite = new Sprite;
			
			var w:Number = Math.random() * 5 + 2;
			var h:Number = Math.random() * 0.5 + 0.5;
			
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(-w*0.5, -h*0.5, w, h);
			s.graphics.endFill();
			
			super(Math.random()*(240/16) + 320/16, -240/16, {w:w, h:h}, s, {angle: Math.random()*Math.PI});
		}
	}
}

