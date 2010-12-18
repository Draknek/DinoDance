package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	import flash.display.*;
	import flash.events.*;
	
	public class Player extends b2Entity
	{
		public function Player ()
		{
			var s:Sprite = new Sprite;
			
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(-2, -2, 4, 4);
			s.graphics.endFill();
			
			s.addEventListener(Event.ADDED_TO_STAGE, function ():void {trace("hello world");});
			
			super(320/16, 240/16, {w:4, h:4}, s);
		}
	}
}

