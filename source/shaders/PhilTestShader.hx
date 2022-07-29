package shaders;

#if !web
import flixel.system.FlxAssets.FlxShader;

class PhilTestShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float elapsedTime;
        uniform float philShaderRNG;

        float boundFloat(float val, float minimum, float maximum) {
            if (val < minimum)
                return minimum;
            else if (val > maximum)
                return maximum;
            return val;
        }
        
        void main() {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            float colorAddition = (sin(elapsedTime)/7.5) + (sin(philShaderRNG)/7.5);
            gl_FragColor = vec4(boundFloat(color.x + colorAddition,0.15,0.85) * color.a, color.y * color.a, color.z * color.a, color.a);
        }
    ')
	public function new()
	{
		super();
	}
}
#end
