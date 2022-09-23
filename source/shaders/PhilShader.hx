package shaders;

#if SHADERS_ENABLED
import flixel.system.FlxAssets.FlxShader;

@:keep
class PhilShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float elapsedTime;
        uniform float philProgress;

        float boundFloat(float val, float minimum, float maximum) {
            if (val < minimum)
                return minimum;
            else if (val > maximum)
                return maximum;
            return val;
        }
        
        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            vec4 outputPixel = vec4(color.x, color.y, color.z, 1.0);

            if (philProgress > 50)
            {
                float cutDownProgress = philProgress - 50;
                if (cutDownProgress > 37.5)
                    cutDownProgress = 37.5;

                outputPixel.x = boundFloat(color.x + boundFloat(cutDownProgress/150,0.0,1.0),0.0,1.0);
            }

            outputPixel.a = boundFloat(color.a + ((sin(elapsedTime*5) - 1)/30),0.0,1.0);

            gl_FragColor = vec4(outputPixel.x * color.a, outputPixel.y * color.a, outputPixel.z * color.a, outputPixel.a * color.a);
        }
    ')
	public function new()
	{
		super(); // idol
	}
}
#end
