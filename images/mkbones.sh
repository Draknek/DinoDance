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
list="bone_${j}_Gfx, $list"
done

echo "public static var bones:Array = [$list null];";

echo "public static function getBone ():Bitmap {
	var i:int = Math.random() * (bones.length - 1);
	return new (bones[i]);
}

}

}";
