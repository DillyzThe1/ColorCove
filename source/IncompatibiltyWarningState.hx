#if !desktop
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if mobile
import flixel.input.touch.FlxTouch;
#end

class IncompatibiltyWarningState extends FlxState
{
	var warningText:FlxText;

	override public function create()
	{
		var textScale = 2;
		warningText = new FlxText(20, 20 + (20 * textScale) * 2, 0, 'w', Std.int(16 * textScale), true);
		warningText.setFormat(Paths.font('FredokaOne-Regular'), Std.int(16 * textScale), FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		warningText.antialiasing = ClientSettings.getBoolByString('antialiasing', true);

		add(warningText);

		warningText.text = 'Warning!\nThis game is meant for a desktop platform!\n\n${FlxG.onMobile?'Mobile ' #if html5 + 'web' #end + ' builds have a few known bugs,\nbut please report them on github!':'Web builds may have unknown bugs as of now,\nso please report them on github!'}\n\nhttps://www.github.com/DillyzThe1/ColorCove/\n';
		warningText.screenCenter();
	}

	override public function update(e:Float)
	{
		super.update(e);
		#if !mobile
		if (FlxG.mouse.justPressed)
			FlxG.switchState(new MenuState());
		#else
		if (FlxG.touches.getFirst() != null)
		{
			var theVoicesTouchWav:Array<FlxTouch> = FlxG.touches.list;
			for (i in 0...theVoicesTouchWav.length)
				if (theVoicesTouchWav[i].justPressed)
					FlxG.switchState(new MenuState());
		}
		#end
	}
}
#end
