package shaders;

import lime.app.Application;
#if (!web && MOUSE_SHADER_TESTING)
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

@:keep
class MouseTrackerShaderManager
{
	public var shader(default, null):MouseTrackerShader;

	public function new(cam:FlxCamera)
	{
		shader = new MouseTrackerShader();
		updateShaderInfo(cam);
	}

	public function updateShaderInfo(cam:FlxCamera)
	{
		this.shader.uPosition.value = [0, 0];
		this.shader.uResolution.value = CCUtil.intsToFloats(CCUtil.getRenderedResolution());
		this.shader.mousePosition.value = [
			flixel.FlxG.mouse.getPositionInCameraView(cam).x,
			flixel.FlxG.mouse.getPositionInCameraView(cam).y
		];
	}
}

// ok so basically fix screen pos stuff and make the shader draw a sphere around it

@:keep
class MouseTrackerShader extends FlxShader
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

        vec2 getScreenPixelCoordinates()
        {
            return uPosition + getPixelCoordinates();
        }

        float getPixelDistFromMouse()
        {
            vec2 mCoords = mousePosition;
            vec2 sCoords = getScreenPixelCoordinates();
            return sqrt((mCoords.x - sCoords.x) * (mCoords.x - sCoords.x) + (mCoords.y - sCoords.y) * (mCoords.y - sCoords.y));
        }

        float getDistFromMouse()
        {
            vec2 mCoords = vec2((mousePosition.x / uResolution.x) / (16/9), mousePosition.y / uResolution.y);
            vec2 sCoords = vec2((getScreenPixelCoordinates().x / uResolution.x) / (16/9), getScreenPixelCoordinates().y / uResolution.y);
            return sqrt((mCoords.x - sCoords.x) * (mCoords.x - sCoords.x) + (mCoords.y - sCoords.y) * (mCoords.y - sCoords.y));
        }

        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            vec4 outputPixel = vec4(color.x, color.y, color.z, 1.0);
            if (getDistFromMouse() < 0.2) {
                outputPixel.r -= 0.15;
                outputPixel.g -= 0.15;
                outputPixel.b += 0.25;
                //outputPixel.a = 0.5;
                if (color.a < 0.05)
                    color.a = 0.5 - getDistFromMouse();
            }
            gl_FragColor = outputPixel * color.a;
        }
    ')
	public function new()
	{
		super();
	}
}
#end
