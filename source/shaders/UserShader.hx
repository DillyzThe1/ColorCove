package shaders;

#if desktop
import flixel.system.FlxAssets.FlxShader;

using StringTools;

@:keep
class UserShader extends FlxShader
{
	// default
	public var frag_default_source:String = '
			#pragma header

			void main() {
				'
		+ #if FLX_DRAW_QUADS 'gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);' #else '#pragma body' #end
		+ '
			}
		';

	#if FLX_DRAW_QUADS
	public var vert_default_source:String = '
		#pragma header
	
		attribute float alpha;
		attribute vec4 colorMultiplier;
		attribute vec4 colorOffset;
		uniform bool hasColorTransform;
		
		void main(void)
		{
			#pragma body
			
			openfl_Alphav = openfl_Alpha * alpha;
			
			if (hasColorTransform)
			{
				openfl_ColorOffsetv = colorOffset / 255.0;
				openfl_ColorMultiplierv = colorMultiplier;
			}
		}
	';
	#else
	public var vert_default_source:String = '
			#pragma header

			void main() {
				#pragma body
			}
		';
	#end

	// copied from GraphicsShader.hx and FlxGraphicsShader.hx
	static var vert_header_default = "attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;";

	static var vert_body_default = "openfl_Alphav = openfl_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;

		if (openfl_HasColorTransform) {

			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;

		}

		gl_Position = openfl_Matrix * openfl_Position;";

	static var frag_header_default = "varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;"

	#if FLX_DRAW_QUADS
	+ " uniform bool hasTransform;
	uniform bool hasColorTransform;
	vec4 flixel_texture2D(sampler2D bitmap, vec2 coord)
	{
		vec4
		color = texture2D(bitmap, coord);
		if (!hasTransform)
		{
			return color;
		}
		if (color.a == 0.0)
		{
			return vec4(0.0, 0.0, 0.0, 0.0);
		}
		if (!hasColorTransform)
		{
			return color * openfl_Alphav;
		}
		color = vec4(color.rgb / color.a, color.a);
		mat4
		colorMultiplier = mat4(0);
		colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
		colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
		colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
		colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
		color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
		if (color.a > 0.0)
		{
			return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
		}
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	"
	#end;
	static var frag_body_default = "vec4 color = texture2D (bitmap, openfl_TextureCoordv);

		if (color.a == 0.0) {

			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

		} else if (openfl_HasColorTransform) {

			color = vec4 (color.rgb / color.a, color.a);

			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;

			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

			if (color.a > 0.0) {

				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);

			} else {

				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

			}

		} else {

			gl_FragColor = color * openfl_Alphav;

		}";

	// @:glFragmentSource(userFragmentSource)
	public function new(?userFragmentSource:String = '', ?userVertexSource:String = '')
	{
		// trace(userFragmentSource);

		if (userFragmentSource.contains('#pragma header') && userFragmentSource.contains('void main()'))
			glFragmentSource = userFragmentSource.replace('#pragma header', frag_header_default).replace('#pragma body', frag_body_default);
		// this.userFragmentSource = userFragmentSource;
		else
		{
			glFragmentSource = frag_default_source.replace('#pragma header', frag_header_default).replace('#pragma body', frag_body_default);
			trace('bad fragment shader lmfao ur missing the header or main void');
		}

		// trace(userVertexSource);

		if (userVertexSource.contains('#pragma header') && userVertexSource.contains('void main()'))
			glVertexSource = userVertexSource.replace('#pragma header', vert_header_default).replace('#pragma body', vert_body_default);
		// this.userFragmentSource = userFragmentSource;
		else
		{
			glVertexSource = vert_default_source.replace('#pragma header', vert_header_default).replace('#pragma body', vert_body_default);
			trace('bad vertex shader lmfao ur missing the header or main void');
		}

		trace(glFragmentSource);
		trace(glVertexSource);

		// https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/flixel/addons/display/FlxRuntimeShader.hx#L225
		@:privateAccess {
			__glSourceDirty = true;
			__isGenerated = false;
		}

		super(); // idol
	}
}
#end
