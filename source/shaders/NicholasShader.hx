package shaders;

#if (!DISABLE_NICHOLAS_SHADER && SHADERS_ENABLED)
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxShader;

@:keep
class NicholasHintEffect
{
	public var parentChar(default, null):Character;
	public var shader(default, null):NicholasShader;

	public function new(fatherFigure:Character)
	{
		this.parentChar = fatherFigure;
		shader = new NicholasShader();
	}

	public function updateStuff(mouseCam:FlxCamera, camFollow:FlxObject)
	{
		this.shader.uPosition.value = [parentChar.x, parentChar.y];
		this.shader.uResolution.value = [parentChar.width, parentChar.height];
		this.shader.mousePosition.value = [
			flixel.FlxG.mouse.getPositionInCameraView(mouseCam).x + camFollow.x,
			flixel.FlxG.mouse.getPositionInCameraView(mouseCam).y + camFollow.y
		];
	}
}

@:keep
class NicholasShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        uniform vec2 uPosition;
        uniform vec2 uResolution;
        uniform vec2 mousePosition;

        vec2 getPixelCoordinates()
        {
            return vec2(openfl_TextureCoordv.x * uResolution.x, openfl_TextureCoordv.y * uResolution.y);
        }

        vec2 getScreenCoordinates()
        {
            return uPosition + getPixelCoordinates();
        }

        float getDistFromMouse()
        {
            vec2 mCoords = mousePosition;
            vec2 sCoords = getScreenCoordinates();
            return sqrt((mCoords.x - sCoords.x) * (mCoords.x - sCoords.x) + (mCoords.y - sCoords.y) * (mCoords.y - sCoords.y));
        }

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            vec4 outputPixel = vec4(color.x, color.y, color.z, 1.0);
            if (getDistFromMouse() < 400)
                outputPixel.a = 0.5;
            gl_FragColor = outputPixel * color.a;
        }
	')
	public function new()
	{
		super();
	}
}
#end
