package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class Level extends b2Level
	{
		public var bonesLeft:int;
		public var boneDelay:int;
		public var time:int;
		
		public var name:String;
		public var creator:String;
		public var serverID:String;
		public var data:Object = {};
		
		public static const BUILDING:int = 10;
		public static const NAMING:int = 20;
		public static const CREDITING:int = 30;
		public static const DISPLAYING:int = 40;
		
		public var paused:Boolean = false;
		public var state:int = BUILDING;
		
		[Embed(source="images/bg.jpg")]
		public static const bgGfx: Class;
		
		public var ui:Sprite = new Sprite;
		public var text:MyTextField;
		public var text2:MyTextField;
		public var urlText:MyTextField;
		
		public static const so:SharedObject = SharedObject.getLocal("dinobones", "/");
		
		public var opponent:Object;
		
		public function Level (vs:Object = null)
		{
			addGraphic(new Stamp(bgGfx), 0);
			
			text = new MyTextField(320, 20, "", "center", 30);
			text2 = new MyTextField(320, 130, "", "center", 20);
			
			ui.addChild(text);
			ui.addChild(text2);
			
			var catcher:Entity = add(new Catcher(Input.mouseX / SCALE));
			
			//add(new Floor());
			
			// Walls
			/*add(new b2Entity(0, 0, [
				{p: [0, -480/SCALE, 0, 480/SCALE]},
				{p: [640/SCALE, -480/SCALE, 640/SCALE, 480/SCALE]},
				{p: [0, -480/SCALE, 640/SCALE, -480/SCALE]}
			], new Sprite, {
				type: b2Body.b2_staticBody,
				friction: 0.0,
				restitution: 0.2
			}));*/
			
			physics.SetContactListener(new ContactListener());
			
			bonesLeft = 20 + Math.random()*20;
		
			boneDelay = 0;//150;
			
			opponent = vs;
		}
		
		public override function update (): void
		{
			if (Input.pressed(Key.F1)) { debug = !debug; }
			
			if (state == BUILDING) {
				//if (Input.pressed(Key.P)) { paused = !paused; }
			}
			
			if (paused) { return; }
			
			time++;
			
			super.update();
			
			if (bonesLeft > 0) {
				boneDelay--;
				if (boneDelay <= 0) {
					add(new Bone());
					bonesLeft--;
					
					boneDelay = 10;//Math.sqrt(Math.random()) * 75 + 20 + (1 - Math.sqrt(Math.random())) * 30;
				}
			}
			
			if (state == BUILDING && bonesLeft <= 0) {
				var fallingCount:int = 0;
				
				var bones:Array = [];
				
				getClass(Bone, bones);
				
				for each (var b:Bone in bones) {
					if (! b.sticky) {
						fallingCount++;
					}
				}
				
				if (fallingCount == 0) {
					
					Input.keyString = "";
					
					state = NAMING;
					
					//remove(classFirst(Floor));
				}
			}
			
			if (state == NAMING) {
				if (Input.pressed(Key.ENTER) && Input.keyString) {
					state = CREDITING;
					
					name = Input.keyString;
					
					Input.keyString = so.data.playerName || "";
					
					return;
				} else {
					text.text = "Wow! You've discovered\na new type of dinosaur!\n\n You should name it!\n\n";
					text.text += magicText();
				}
			}
			
			if (state == CREDITING) {
				if (Input.pressed(Key.ENTER) && Input.keyString) {
					state = DISPLAYING;
					
					creator = Input.keyString;
					
					so.data.playerName = Input.keyString;
					
					so.flush();
					
					saveDinoData();
					
					return;
				} else {
					text.text = name + "\nwas discovered by\n";
					
					text.text += magicText();
					
					text2.text = "Enter your name for posterity"
				}
			}
			
			if (state == DISPLAYING) {
				text.text = name + "\nwas discovered by\n" + creator;
				
				if (serverID && ! urlText) {
					urlText = makeURLText(serverID, 155, ! opponent) as MyTextField;
					
					if (opponent) {
						ui.addChild(new MyTextField(320, 220, "But first let's have that dance-off!", "center", 20));
						
						var button:Button = new Button("Let's go", 30);
						button.x = 320 - button.width * 0.5;
						button.y = 250;
						
						button.addEventListener(MouseEvent.CLICK, function ():void {
							FP.world = new Fight(opponent, data, true);
						});
						
						ui.addChild(button);
						
						ui.addChild(new MyTextField(320, 180, "Send this link to your friends", "center", 20));
					} else {
						ui.addChild(new MyTextField(320, 180, "Send this link to your friends\nto challenge them to a dance-off", "center", 20));
						
						var tweet:DisplayObject = new TweetButton(name, serverID);
						tweet.x = 320 - tweet.width*0.5;
						tweet.y = 235;
						ui.addChild(tweet);
					}
					
					ui.addChild(urlText);
					
				}
				
				if (urlText) {
					text2.text = "Your dinosaur's webpage:";
				} else {
					text2.text = "Please wait for your dinosaur's challenge ID..."
				}
			}
		}
		
		public static function makeURLText (serverID:String, y:Number, link:Boolean = true):DisplayObject
		{
			var url:String = Main.url + "?dino=" + serverID;
			var ss:StyleSheet = new StyleSheet();
			ss.parseCSS("a:hover { text-decoration: underline; } a { text-decoration: none; }");
			var urlText:MyTextField = new MyTextField(320, y, url, "center", 10);
			
			urlText.mouseEnabled = true;
			
			if (link) {
				urlText.htmlText = '<a href="' + url + '">' + url + '</a>';
				urlText.styleSheet = ss;
			} else {
				urlText.selectable = true;
			}
			
			return urlText;
		}
		
		public function magicText (): String
		{
			Input.keyString = Input.keyString.substr(0, 30);
			
			var text:String = Input.keyString;
			
			var cursor:Boolean = (time % 60 < 30);
			
			if (cursor) {
				text = " " + text;
			}
			
			if (cursor) {
				text += '_';
			}
			
			return text;
		}
		
		private function saveDinoData (): void
		{
			var i:int = 0;
			
			var bones:Array = [];
			
			getClass(Bone, bones);
			
			var offset:Number = classFirst(Catcher).x;
			
			var bytes:ByteArray = new ByteArray;
			
			bytes.writeInt(bones.length);
			
			for each (var b:Bone in bones) {
				b.id = i++;
				encodeBone(b, bytes, offset);
			}
			
			data.name = name;
			data.creator = creator;
			data.data = bytes;

			var list:Array = getDinoList();
			
			i = list.length;
			
			so.data.dinos[i] = data;
			so.flush();
			
			submitDino(data, i, this);
		}
		
		public static function submitDino (dino:Object, i:int, level:Level = null):void
		{
			var request:URLRequest = new URLRequest(Main.url + "submit.php");
			request.method = URLRequestMethod.POST;

			var vars:URLVariables = new URLVariables();
				vars.name = dino.name;
				vars.creator = dino.creator;
				vars.data = Base64.encode(dino.data);

			request.data = vars;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, doComplete);
			loader.load(request);
			
			function doComplete ():void
			{
				var id:String = loader.data;
				
				if (level) level.serverID = id;
				
				dino.serverID = id;
				Level.so.data.dinos[i].serverID = id;
				Level.so.flush();
			}
		}
		
		private function encodeBone (b:Bone, bytes:ByteArray, offset:Number = 0):void
		{
			var x:Number = b.x - offset;
			var y:Number = b.y;
			var angle:Number = b.body.GetAngle();
			var w:Number = b.w;
			var h:Number = b.h;
			
			bytes.writeFloat(x);
			bytes.writeFloat(y);
			bytes.writeFloat(angle);
			bytes.writeFloat(w);
			bytes.writeFloat(h);
		}
		
		public static function getDinoList ():Array
		{
			if (Level.so.data.dinos) return Level.so.data.dinos;
			
			Level.so.data.dinos = new Array;
			
			Level.so.flush();
			
			return Level.so.data.dinos;
		}
		
		public static function buildDino (world:World, bytes:ByteArray, offset:Number):Object
		{
			bytes.position = 0;
			
			var length:int = bytes.readInt();
			
			var bones:Array = [];
			
			for (var i:int = 0; i < length; i++) {
				bones.push(world.add(new Bone(bytes, offset)));
			}
			
			return bones;
		}
		
		public override function render (): void
		{
			super.render();
		}
		
		public override function begin (): void
		{
			super.begin();
			FP.engine.addChild(ui);
		}
		
		public override function end (): void
		{
			super.end();
			FP.engine.removeChild(ui);
		}
	}
}

