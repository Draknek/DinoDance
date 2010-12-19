package
{
	import flash.display.Bitmap;
	
	public class BoneGraphics
	{

[Embed(source="images/bones/a.png")] public static const bone_a_Gfx: Class;
[Embed(source="images/bones/b.png")] public static const bone_b_Gfx: Class;
[Embed(source="images/bones/c.png")] public static const bone_c_Gfx: Class;
[Embed(source="images/bones/d.png")] public static const bone_d_Gfx: Class;
[Embed(source="images/bones/bonus/tooth1.png")] public static const bone_bonus_tooth1_Gfx: Class;
[Embed(source="images/bones/bonus/tooth2.png")] public static const bone_bonus_tooth2_Gfx: Class;
public static var bones:Array = [bone_d_Gfx, bone_c_Gfx, bone_b_Gfx, bone_a_Gfx,  null];
public static var bonus:Array = [bone_bonus_tooth2_Gfx, bone_bonus_tooth1_Gfx,  null];
public static function getBone ():Bitmap {
	var i:int = Math.random() * (bones.length - 1);
	return new (bones[i]);
}

public static function getBonus ():Bitmap {
	var i:int = Math.random() * (bonus.length - 1);
	return new (bonus[i]);
}

}

}
