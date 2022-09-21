package;

// https://github.com/Dot-Stuff/flxanimate
#if web
import flixel.FlxSprite;
#else
import flxanimate.FlxAnimate.Settings;
import flxanimate.FlxAnimate;
#end

class TutorialPopupBG extends #if web FlxSprite #else FlxAnimate #end
{
	public function new(x:Float, y:Float)
	{
		#if web
		super(x, y);
		loadGraphic(Paths.image('Info Popup Atlas/static'));
		offset.x = 80;
		offset.y = 115;
		#else
		var bruh:Settings = {
			Antialiasing: ClientSettings.getBoolByString('antialiasing', true),
			FrameRate: 24
		};
		super(x, y, Paths.asset('images/Info Popup Atlas'), bruh);
		anim.addBySymbol('in', 'parts/info popup', 24, false);
		anim.play('in', true, false, 0);
		#end
	}
}
