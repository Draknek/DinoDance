#!/bin/sh

echo "package
{
	import flash.display.Bitmap;
	
	public class BoneGraphics
	{
";

cd bones

for i in *.png
do j=$(echo $i | sed s/.png//)
echo "[Embed(source=\"images/bones/$i\")] public static const bone_${j}_Gfx: Class;"
bones="bone_${j}_Gfx, $bones"
done

cd bonus

for i in *.png
do j=$(echo $i | sed s/.png//)
echo "[Embed(source=\"images/bones/bonus/$i\")] public static const bone_bonus_${j}_Gfx: Class;"
bonus="bone_bonus_${j}_Gfx, $bonus"
done

echo "public static var bones:Array = [$bones null];";

echo "public static var bonus:Array = [$bonus null];";

echo "public static function getBone ():Bitmap {
	var i:int = Math.random() * (bones.length - 1);
	return new (bones[i]);
}

public static function getBonus ():Bitmap {
	var i:int = Math.random() * (bonus.length - 1);
	return new (bonus[i]);
}

}

}";
