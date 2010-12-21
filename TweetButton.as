package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	
	public class TweetButton extends SimpleButton
	{
		[Embed(source = 'images/tweet.png')]
		public static var tweetGfx: Class;
		
		public var data:*;
		
		public function TweetButton (name:String, serverID:String)
		{
			data = "I discovered the dinosaur "+name+"! It wants to challenge you to a dance-off: " + Main.url + "?dino=" + serverID;
			
			var image:BitmapData = new tweetGfx().bitmapData;
			
			var w:int = image.width;
			var h:int = image.height / 3;
			
			var p:Point = new Point(0, 0);
			
			var rect:Rectangle = new Rectangle(0, 0, w, h);
			
			var subImages:Array = [];
			
			for (var i:int = 0; i < 3; i++) {
				var subImage:BitmapData = new BitmapData(w, h);
				
				rect.y = h*i;
				
				subImage.copyPixels(image, rect, p);
				
				subImages[i] = new Bitmap(subImage);
			}
			
			super(subImages[0], subImages[1], subImages[2], subImages[0]);
			
			addEventListener(MouseEvent.CLICK, clickListener);
		}
		
		private function clickListener (e:Event):void
		{
			var text:String;
			
			if (data is Function) {
				text = data();
			} else {
				text = data;
			}
			
			var tweetURL:String = "http://twitter.com/home?status=" + escape(text);
			
			var request:URLRequest = new URLRequest(tweetURL);
			navigateToURL(request, "_blank");
		}
	}
}

		
