<p align="center">
  <img align="center" src="art/sign logo.png">
</p>
<p align="center">
  A simplistic indie game by <a href="https://www.github.com/DillyzThe1">DillyzThe1</a>.
</p>
<p align="center">
  Originally made for a mini-jam hosted by <a href="https://matthew-schlauderaff.itch.io/">Matthew Schlauderaff</a>.
</p>



# ColorCove

[![](https://img.shields.io/github/downloads/DillyzThe1/ColorCove/total.svg)](../../releases) [![](https://img.shields.io/github/v/release/DillyzThe1/ColorCove)](../../releases/latest) [![](https://img.shields.io/github/repo-size/DillyzThe1/ColorCove)](../../archive/refs/heads/main.zip)<br/>
A colorful game across the side of a street.<br/>
Your goal is to get the boring monochrome outliers to stop trying to make it boring!<br/>
<i>Note: If you make a mod, make sure to edit this README's links & change this notice to be a disclaimer.</i>

## Credits
<i><u><b>Main Team:</b></u></i><br>
[DillyzThe1](https://www.github.com/DillyzThe1) - Programmer<br>

<i><u><b>Contributors:</b></u></i><br>
TheFlameZEternal - Feedback & Other Ideas<br>
[Impostor5875](https://www.github.com/impostor5875) - Feedback<br>

<i><u><b>Speical Thanks:</b></u></i><br>
[Matthew Schlauderaff](https://matthew-schlauderaff.itch.io/) - Mini Game Jam Host<br>
[Player03](https://github.com/player-03) - Helped with the game icon not working past v0.6.2<br>

## How To Play

For all desktop builds, go [here](https://github.com/DillyzThe1/ColorCove/releases) & download the zip.<br/>
For (semi-mobile-compatible) web builds, go to [this link](https://dillyzthe1.github.io/ColorCoveWebBuild/) instead.

<i>To test out latest commits and beta builds, go to [the actions page](https://github.com/DillyzThe1/ColorCove/actions) and download the latest workflow.</i><br>
<i>Yes, it actaully includes all 3 platforms.</i>

You can click/tap any UI element you need, but you also have some standard controls:<br/>
* Escape (Exiting a menu/popup)<br/>
* Enter (Pausing)<br/>

And some unique ones for debug builds:<br/>
* 9 (Offset State, accessed from Menu State)<br/>
* 1 (Last animation in Offset State)<br/>
* 2 (Next animation in Offset State)<br/>
* Space (Play animation in Offset State)<br/>
* Arrow Keys (Change animation offset in Offset State)<br/>

## How To Compile
<i>Note: IF you publish a public modification to this game, you <b>MUST</b> open source it on github & add a link to the source code.</i><br/>
<i>Also Note: Pull requests of a full-on mod/engine will likely <u><b>not</b> be added</u>. Open an issue under the enhancement tag.</i><br/>
<br/>
<br/>
Download Haxe [4.2.4 64-bit](https://haxe.org/download/file/4.2.4/haxe-4.2.4-win64.exe/) or [4.2.4 32-bit](https://haxe.org/download/file/4.2.4/haxe-4.2.4-win.exe/).
<br/>
Download the [source code of this repository](https://www.github.com/DillyzThe1/ColorCove/archive/refs/heads/main.zip) or the [source code of the latest release](https://www.github.com/DillyzThe1/ColorCove/releases/latest).
<br/>
Extract the zip file and open the folder.<br/>
Run setup.bat and let it automatically install.<br/>
<i>* NOTE: Do NOT let it open the example repositories it installs.</i><br/>
Once that finishes, run build.bat and decided if you want to compile a debug or release build.<br/>
The game should then compile, letting you re-run build.bat at any time to mod the game.<br/>
<br/>
<i>Note: Visual Studio Code is recommended for programming new features. Please install the appropiate plugins for haxeflixel in VSC.</i><br/>
