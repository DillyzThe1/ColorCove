# 0.6.2 (A Visually Appealing Bugfix - Build 526)
- Adds better/cleaner camera movement to the game
- Camera zoom & rotation toned down
- Fixed & properly implemented the popup texture atlas (As I now fully understand FlxAnimate)
- Fixed runtime vertex shaders trying to run .frag files instead of .vert
- Fixed a huge bug with the mobile web build that would screw up the BG.
- Added runtime shader support
- Attempted to fix blank BG bug with blurs on mobile HTML5 builds.
- Fixed various typos on the outdated warning.

# 0.6.1 (More Desktop Builds - Build 503)
- Adds a github-compiled linux build to the downloads
- Adds a github-compiled mac build to the downloads
- Windows builds are still compiled on my computer

# 0.6.0 (Visually Enhanced Pre-Release - Build 502)
- The options menu & it's functionality have both been fully revamped!<br> 
	- (Modding documentation coming soon!)
- Custom GLSL shaders (Aka shaders written in OpenGL Shader Language) are now used.
- The addition of CCUtil allows organized camera filters using BitmapFilters, FlxShaders, or ShaderFilters.
- Unused functions are stripped from any build on 0.6.0 or higher.
- Traces (aka debugging/printing) is now completely disabled on release builds.<br> 
	- This allows for great optimizations, especially on oversights where the console is spammed. 
	- (Please report those [here](https://github.com/DillyzThe1/ColorCove/issues), or fix them yourself [here](https://github.com/DillyzThe1/ColorCove/pulls).)
- The enemy (canonically named Phil) now has a toggle-able custom shader that turns him red as he crosses half of the screen.<br>
	- On top of this, the shader will have his alpha values variate a bit.
	- <i>Currently desktop only due to shader compiler errors.</i>
- Sub-States now blur when active.<br>
	- (Also, it actually tweens the blur!)
- 2 new options categories.
	- A shaders category, meant for OpenGL Shaders that are most likely written by me.
	- A gameplay category, meant for minor gameplay-affecting tweaks.
- <s>6</s> <b>5</b> new options have been added.
	- Pause Menu Blur (True/False)
	- Phil Warning Shader (True/False)
		- <i>Desktop only for now.</i>
	- <s>Nicholas Hint Shader (True/False)</s> 
		- <b>Cancelled due to complications.</b>
	- Show Tutorial (True/False)
	- Auto Pause (True/False)
- <s>The passive characters (canonically named Nicholas) now have their alpha lowered when closer to the mouse using a GLSL shader.</s>
	- <b>Canceled due to complications.</b>
- Two new compiler flags that had to do with shader testing & scrapped features.
	- Please refer to [Project.xml lines 96-98](https://github.com/DillyzThe1/ColorCove/blob/main/Project.xml#L96) for the new compiler flags.
- You can now report bugs from the outdated sub state.
	- This links you to submit an issue on Github, which is different from PauseSubState.
- A toggle-able tutorial now pops up when entering PlayState. (Also, it's different between HTML5 and desktop builds.)
- The outdated menu actually closes rather than reloading the main menu.
- Updated Adobe Animate project file. (Additions: Icons for options & the popup for PlayState.hx)
- Replaced build ID tracker for consistency & forks.

# 0.5.0 (Game-Jam Pre-Release - Build 361)
- First release of the game
- Includes gameplay, options, pausing, sound, music, art, etc.