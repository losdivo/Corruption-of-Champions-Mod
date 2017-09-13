import classes.*;
import flash.text.TextFormat;

// at least one import or other usage of *class* so it won't be marked unused.
import classes.internals.Profiling;
import classes.internals.profiling.Begin;
import classes.internals.profiling.End;

public static const MAX_BUTTON_INDEX:int = 14;

public function maxHP():Number {
	return player.maxHP();
}

public function silly():Boolean {
	return flags[kFLAGS.SILLY_MODE_ENABLE_FLAG] == 1;
}

/**
 * Alters player's HP.
 * @param	changeNum The amount to damage (negative) or heal (positive).
 * @param	display Show the damage or heal taken.
 * @return  effective delta
 */
public function HPChange(changeNum:Number, display:Boolean):Number
{
	var before:Number = player.HP;
	if (changeNum == 0) return 0;
	if (changeNum > 0) {
		if (player.findPerk(PerkLib.HistoryHealer) >= 0) changeNum *= 1.2; //Increase by 20%!
		if (player.armor.name == "skimpy nurse's outfit") changeNum *= 1.1; //Increase by 10%!
		if (player.HP + int(changeNum) > maxHP()) {
			if (player.HP >= maxHP()) {
			if (display) HPChangeNotify(changeNum);
				return player.HP - before;
			}
			if (display) HPChangeNotify(changeNum);
			player.HP = maxHP();
		}
		else
		{
			if (display) HPChangeNotify(changeNum);
			player.HP += int(changeNum);
			mainView.statsView.showStatUp( 'hp' );
			// hpUp.visible = true;
		}
	}
	//Negative HP
	else
	{
		if (player.HP + changeNum <= 0) {
			if (display) HPChangeNotify(changeNum);
			player.HP = 0;
			mainView.statsView.showStatDown( 'hp' );
		}
		else {
			if (display) HPChangeNotify(changeNum);
			player.HP += changeNum;
			mainView.statsView.showStatDown( 'hp' );
		}
	}
	player.dynStats("lust", 0, "scale", false); //Workaround to showing the arrow.
	statScreenRefresh();
	return player.HP - before;
}

public function HPChangeNotify(changeNum:Number):void {
	if (changeNum == 0) {
		if (player.HP >= maxHP())
			outputText("You're as healthy as you can be.\n");
	}
	else if (changeNum > 0) {
		if (player.HP >= maxHP())
			outputText("Your HP maxes out at " + maxHP() + ".\n");
		else
			outputText("You gain <b><font color=\"#008000\">" + int(changeNum) + "</font></b> HP.\n");
	}
	else {
		if (player.HP <= 0)
			outputText("You take <b><font color=\"#800000\">" + int(changeNum*-1) + "</font></b> damage, dropping your HP to 0.\n");
		else
			outputText("You take <b><font color=\"#800000\">" + int(changeNum*-1) + "</font></b> damage.\n");
	}
}
		
public function clone(source:Object):* {
	var copier:ByteArray = new ByteArray();
	copier.writeObject(source);
	copier.position = 0;
	return(copier.readObject());
}

/**
 * Clear the text on screen.
 */
public function clearOutput():void {
	forceUpdate();
	output.clear();
	mainView.clearOutputText();
	if (_gameState != 3) mainView.hideMenuButton( MainView.MENU_DATA );
	mainView.hideMenuButton( MainView.MENU_APPEARANCE );
	mainView.hideMenuButton( MainView.MENU_LEVEL );
	mainView.hideMenuButton( MainView.MENU_PERKS );
	mainView.hideMenuButton( MainView.MENU_STATS );
}

/**
 * Basically the same as outputText() but without the parser tags. Great for displaying square brackets on text.
 * @param	output The text to show. It can be formatted such as bold, italics, and underline tags.
 * @param	purgeText Clear the old text.
 */
public function rawOutputText(output:String, purgeText:Boolean = false):void
{
	
	//OUTPUT!
	if (purgeText) {
		//if (!debug) mainText.htmlText = output;
		//trace("Purging and writing Text", output);
		clearOutput();
		this.output.raw(output);
		//mainView.setOutputText( output );
		// mainText.htmlText = output;
	}
	else
	{
		//trace("Adding Text");
		this.output.raw(output);
		//mainView.appendOutputText( output );
		// mainText.htmlText += output;
	}
	// trace(getCurrentStackTrace())
	// scrollBar.update();

}

/**
 * Output the text on main text interface.
 * @param	output The text to show. It can be formatted such as bold, italics, and underline tags.
 * @param	purgeText Clear the old text.
 */
public function outputText(output:String):void
{
	// we have to purge the output text BEFORE calling parseText, because if there are scene commands in 
	// the parsed text, parseText() will write directly to the output


	// This is cleaup in case someone hits the Data or new-game button when the event-test window is shown. 
	// It's needed since those buttons are available even when in the event-tester
	mainView.hideTestInputPanel();

	this.output.text(output);
		//if (!debug) mainText.htmlText = currentText;
	/*if (debug)
	{
		mainView.setOutputText( currentText );
	}*/

}

public function displayHeader(string:String):void {
	outputText("<font size=\"36\" face=\"Georgia\"><u>" + string + "</u></font>\n");
}

public function buttonIsVisible(index:int):Boolean {
	if ( index < 0 || index > MAX_BUTTON_INDEX ) {
		return undefined;
	}
	else {
		return mainView.bottomButtons[index].visible;
	}
};

public function buttonText(buttonName:String):String {
	var matches:*,
		buttonIndex:int;

	if (buttonName is String) {
		if ( /^buttons\[[0-9]\]/.test( buttonName ) ) {
			matches = /^buttons\[([0-9])\]/.exec( buttonName );
			buttonIndex = parseInt( matches[ 1 ], 10 );
		}
		else if ( /^b[0-9]Text$/.test( buttonName ) ) {
			matches = /^b([0-9])Text$/.exec( buttonName );
			buttonIndex = parseInt( matches[ 1 ], 10 );

			buttonIndex = buttonIndex === 0 ? 9 : buttonIndex - 1;
		}
	}

	return (getButtonText(buttonIndex) || "NULL");
}

public function buttonTextIsOneOf(index:int, possibleLabels:Array):Boolean {
	var label:String,
	buttonText:String;

	buttonText = this.getButtonText(index);

	return (possibleLabels.indexOf(buttonText) != -1);
}

public function getButtonText(index:int):String {
	var matches:*;

	if (index < 0 || index > MAX_BUTTON_INDEX) {
		return '';
	}
	else {
		return mainView.bottomButtons[index].labelText;
	}
}

public function getButtonToolTipHeader(buttonText:String):String
{
	var toolTipHeader:String;
	
	if (buttonText.indexOf(" x") != -1)
	{
		buttonText = buttonText.split(" x")[0];
	}
	
	//Get items
	var itype:ItemType = ItemType.lookupItem(buttonText);
	var temp:String = "";
	if (itype != null) temp = itype.longName;
	itype = ItemType.lookupItemByShort(buttonText);
	if (itype != null) temp = itype.longName;
	if (temp != "") {
		temp = Utils.capitalizeFirstLetter(temp);
		toolTipHeader = temp;
	}
	
	//Set tooltip header to button.
	if (toolTipHeader == null) {
		toolTipHeader = buttonText;
	}
	
	return toolTipHeader;
}

// Returns a string or undefined.
public function getButtonToolTipText(buttonText:String):String
{
	var toolTipText :String;

	buttonText = buttonText || '';

	//Items
	//if (/^....... x\d+$/.test(buttonText)){
	//	buttonText = buttonText.substring(0,7);
	//}
	
	// Fuck your regex
	if (buttonText.indexOf(" x") != -1)
	{
		buttonText = buttonText.split(" x")[0];
	}
	
	var itype:ItemType = ItemType.lookupItem(buttonText);
	if (itype != null) toolTipText = itype.description;
	itype = ItemType.lookupItemByShort(buttonText);
	if (itype != null) toolTipText = itype.description;

	//------------
	// COMBAT 
	//------------
	if (buttonText.indexOf("Defend") != -1) { //Not used at the moment.
		toolTipText = "Selecting defend will reduce the damage you take by 66 percent, but will not affect any lust incurred by your enemy's actions.";
	}
	//Urta's specials - MOVED
	//P. Special attacks - MOVED
	//M. Special attacks - MOVED

	//------------
	// MASTURBATION 
	//------------
	//Masturbation Toys
	if (buttonText == "Masturbate") {
		toolTipText = "Selecting this option will make you attempt to manually masturbate in order to relieve your lust buildup.";
	}
	if (buttonText == "Meditate") {
		toolTipText = "Selecting this option will make you attempt to meditate in order to reduce lust and corruption.";
	}
	if (buttonText.indexOf("AN Stim-Belt") != -1) {
		toolTipText = "This is an all-natural self-stimulation belt.  The methods used to create such a pleasure device are unknown.  It seems to be organic in nature.";
	}
	if (buttonText.indexOf("Stim-Belt") != -1) {
		toolTipText = "This is a self-stimulation belt.  Commonly referred to as stim-belts, these are clockwork devices designed to pleasure the female anatomy.";
	}
	if (buttonText.indexOf("AN Onahole") != -1) {
		toolTipText = "An all-natural onahole, this device looks more like a bulbous creature than a sex-toy.  Nevertheless, the slick orifice it presents looks very inviting.";
	}
	if (buttonText.indexOf("D Onahole") != -1) {
		toolTipText = "This is a deluxe onahole, made of exceptional materials and with the finest craftsmanship in order to bring its user to the height of pleasure.";
	}
	if (buttonText.indexOf("Onahole") != -1) {
		toolTipText = "This is what is called an 'onahole'.  This device is a simple textured sleeve designed to fit around the male anatomy in a pleasurable way.";
	}
	if (buttonText.indexOf("Dual Belt") != -1) {
		toolTipText = "This is a strange masturbation device, meant to work every available avenue of stimulation.";
	}
	if (buttonText.indexOf("C. Pole") != -1) {
		toolTipText = "This 'centaur pole' as it's called appears to be a sex-toy designed for females of the equine persuasion.  Oddly, it's been sculpted to look like a giant imp, with an even bigger horse-cock.";
	}
	if (buttonText.indexOf("Fake Mare") != -1) {
		toolTipText = "This fake mare is made of metal and wood, but the anatomically correct vagina looks as soft and wet as any female centaur's.";
	}
	//Books - MOVED
	//------------
	// TITLE SCREEN 
	//------------
	if (buttonText.indexOf("ASPLODE") != -1) {
		toolTipText = "MAKE SHIT ASPLODE";
	}
	return toolTipText;
}


// Hah, finally a place where a dictionary is actually required!
import flash.utils.Dictionary;
private var funcLookups:Dictionary = null;


private function buildFuncLookupDict(object:*=null,prefix:String=""):void
{
	import flash.utils.*;
	trace("Building function <-> function name mapping table for "+((object==null)?"CoC.":prefix));
	// get all methods contained
	if (object == null) object = this;
	var typeDesc:XML = describeType(object);
	//trace("TypeDesc - ", typeDesc)

	for each (var node:XML in typeDesc..method) 
	{
		// return the method name if the thisObject of f (t) 
		// has a property by that name 
		// that is not null (null = doesn't exist) and 
		// is strictly equal to the function we search the name of
		//trace("this[node.@name] = ", this[node.@name], " node.@name = ", node.@name)
		if (object[node.@name] != null)
			this.funcLookups[object[node.@name]] = prefix+node.@name;
	}
	for each (node in typeDesc..variable)
	{
		if (node.@type.toString().indexOf("classes.Scenes.") == 0 ||
				node.metadata.@name.contains("Scene")){
			if (object[node.@name]!=null){
				buildFuncLookupDict(object[node.@name],node.@name+".");
			}
		}
	}
}

public function getFunctionName(f:Function):String
{
	// trace("Getting function name")
	// get the object that contains the function (this of f)
	//var t:Object = flash.sampler.getSavedThis(f); 
	if (this.funcLookups == null)
	{
		trace("Rebuilding lookup object");
		this.funcLookups = new Dictionary();
		this.buildFuncLookupDict();
	}


	if (f in this.funcLookups)
		return(this.funcLookups[f]);
	
	// if we arrive here, we haven't found anything... 
	// maybe the function is declared in the private namespace?
	return null;
}


private function logFunctionInfo(func:Function, arg:* = null, arg2:* = null, arg3:* = null):void
{
	var logStr:String = "";
	if (arg is Function)
	{
		logStr += "Calling = " + getFunctionName(func) + " Param = " +  getFunctionName(arg);
	}
	else
	{
		logStr += "Calling = " + getFunctionName(func) + " Param = " +  arg;
	}
	CoC_Settings.appendButtonEvent(logStr);
	trace(logStr)
}


// returns a function that takes no arguments, and executes function `func` with argument `arg`
public function createCallBackFunction(func:Function, arg:*, arg2:* = null, arg3:* = null):Function
{
	if (func == null) {
		CoC_Settings.error("createCallBackFunction(null," + arg + ")");
	}
	if ( arg == -9000 || arg == null )
	{
/*		if (func == eventParser){
			CoC_Settings.error("createCallBackFunction(eventParser,"+arg+")");
		} */
		return function ():*
		{ 
			if (CoC_Settings.haltOnErrors) 
				logFunctionInfo(func, arg);
			return func(); 
		};
	}
	else
	{
		if (arg2 == -9000 || arg2 == null)
		{
			return function ():*
			{ 
				if (CoC_Settings.haltOnErrors) 
					logFunctionInfo(func, arg);
				return func( arg ); 
			};
		}
		else 
		{
			if (arg3 == -9000 || arg3 == null)
			{
				return function ():*
				{ 
					if (CoC_Settings.haltOnErrors) 
						logFunctionInfo(func, arg, arg2);
					return func(arg, arg2); 
				};
			}
			else 
			{
				return function ():*
				{ 
					if (CoC_Settings.haltOnErrors) 
						logFunctionInfo(func, arg, arg2, arg3);
					return func(arg, arg2, arg3); 
				};
			}
		}
	}
}

/**
 * Adds a button.
 * @param	pos Determines the position. Starts at 0. (First row is 0-4, second row is 5-9, third row is 10-14.)
 * @param	text Determines the text that will appear on button.
 * @param	func1 Determines what function to trigger.
 * @param	arg1 Pass argument #1 to func1 parameter.
 * @param	arg2 Pass argument #1 to func1 parameter.
 * @param	arg3 Pass argument #1 to func1 parameter.
 * @param	toolTipText The text that will appear on tooltip when the mouse goes over the button.
 * @param	toolTipHeader The text that will appear on the tooltip header. If not specified, it defaults to button text.
 */
public function addButton(pos:int, text:String = "", func1:Function = null, arg1:* = -9000, arg2:* = -9000, arg3:* = -9000, toolTipText:String = "", toolTipHeader:String = ""):void {
	if (func1==null) return;
	var callback:Function;

	//Let the mainView decide if index is valid
	if (pos > MAX_BUTTON_INDEX) {
		trace("INVALID BUTTON");
		return;
	}
	//Removes sex-related button in SFW mode.
	if (flags[kFLAGS.SFW_MODE] > 0) {
		if (text.indexOf("Sex") != -1 || text.indexOf("Threesome") != -1 ||  text.indexOf("Foursome") != -1 || text == "Watersports" || text == "Make Love" || text == "Use Penis" || text == "Use Vagina" || text.indexOf("Fuck") != -1 || text.indexOf("Ride") != -1 || (text.indexOf("Mount") != -1 && text.indexOf("Mountain") == -1) || text.indexOf("Vagina") != -1) {
			trace("Button removed due to SFW mode.");
			return;
		}
	}
	callback = createCallBackFunction(func1, arg1, arg2, arg3);

	if (toolTipText == "") toolTipText = getButtonToolTipText(text);
	if (toolTipHeader == "") toolTipHeader = getButtonToolTipHeader(text);
	mainView.bottomButtons[pos].alpha = 1; // failsafe to avoid possible problems with dirty hack
	mainView.showBottomButton(pos, text, function():void {
		output.record("<br>["+text+"]<br>");
		callback();
	}, toolTipText, toolTipHeader);
	//mainView.setOutputText( currentText );
	output.flush();
}

public function addButtonDisabled(pos:int, text:String = "", toolTipText:String = "", toolTipHeader:String = ""):void {
	//Removes sex-related button in SFW mode.
	if (flags[kFLAGS.SFW_MODE] > 0) {
		if (text.indexOf("Sex") != -1 || text.indexOf("Threesome") != -1 ||  text.indexOf("Foursome") != -1 || text == "Watersports" || text == "Make Love" || text == "Use Penis" || text == "Use Vagina" || text.indexOf("Fuck") != -1 || text.indexOf("Ride") != -1 || (text.indexOf("Mount") != -1 && text.indexOf("Mountain") == -1) || text.indexOf("Vagina") != -1) {
			//trace("Button removed due to SFW mode.");
			return;
		}
	}

	if (toolTipText == "") toolTipText = getButtonToolTipText(text);
	if (toolTipHeader == "") toolTipHeader = getButtonToolTipHeader(text);
	mainView.showBottomButtonDisabled(pos, text, toolTipText, toolTipHeader);
	output.flush();
}

public function setButtonTooltip(index:int, toolTipHeader:String = "", toolTipText:String = ""):void {
	mainView.showBottomButton(index, mainView.bottomButtons[index].labelText, mainView.bottomButtons[index].callback, toolTipText, toolTipHeader);
}

public function hasButton(arg:*):Boolean {
	if ( arg is String )
		return mainView.hasButton( arg as String );
	else
		return false;
}

/**
 * Removes a button.
 * @param	arg The position to remove a button. (First row is 0-4, second row is 5-9, third row is 10-14.)
 */
public function removeButton(arg:*):void {
	var buttonToRemove:int = 0;
	if (arg is String) {
		buttonToRemove = mainView.indexOfButtonWithLabel( arg as String );
	}
	if (arg is Number) {
		if (arg < 0 || arg > MAX_BUTTON_INDEX) return;
		buttonToRemove = Math.round(arg);
	}
	mainView.hideBottomButton( buttonToRemove );
}

/**
 * Hides all bottom buttons.
 */
public function menu():void { //The newer, simpler menu - blanks all buttons so addButton can be used
	for (var i:int = 0; i <= MAX_BUTTON_INDEX; i++) {
		mainView.hideBottomButton(i);
		mainView.bottomButtons[i].alpha = 1; // Dirty hack.
	}
	output.flush();
}

/**
 * Clears all button and adds a 'Yes' and a 'No' button.
 * @param	eventYes The event parser or function to call if 'Yes' button is pressed.
 * @param	eventNo The event parser or function to call if 'No' button is pressed.
 */
public function doYesNo(eventYes:Function, eventNo:Function):void { //New typesafe version
	menu();
	addButton(0, "Yes", eventYes);
	addButton(1, "No", eventNo);
}

/**
 * Clears all button and adds a 'Next' button.
 * @param	event The event function to call if the button is pressed.
 */
public function doNext(event:Function):void { //Now typesafe
	//Prevent new events in combat from automatically overwriting a game over. 
	if (mainView.getButtonText(0).indexOf("Game Over") != -1) {
		trace("Do next setup cancelled by game over");
		return;
	}
	menu();
	addButton(0, "Next", event);
}

public function invertGo():void{ 
	mainView.invert();
}

/**
 * Used to update the display of statistics
 */
public function statScreenRefresh():void {
	mainView.statsView.show(); // show() method refreshes.
	mainViewManager.refreshStats();
}
/**
 * Show the stats pane. (Name, stats and attributes)
 */
public function showStats():void {
	mainView.statsView.show();
	mainViewManager.refreshStats();
	mainViewManager.tweenInStats();
}
/**
 * Hide the stats pane. (Name, stats and attributes)
 */
public function hideStats():void {
	if (!mainViewManager.buttonsTweened) mainView.statsView.hide();
	mainViewManager.tweenOutStats();
}

/**
 * Hide the top buttons.
 */
public function hideMenus():void {
	mainView.hideAllMenuButtons();
}

/**
 * Hides the up/down arrow on stats pane.
 */
public function hideUpDown():void {
	mainView.statsView.hideUpDown();
	//Clear storage values so up/down arrows can be properly displayed
	oldStats.oldStr = 0;
	oldStats.oldTou = 0;
	oldStats.oldSpe = 0;
	oldStats.oldInte = 0;
	oldStats.oldLib = 0;
	oldStats.oldSens = 0;
	oldStats.oldCor = 0;  
	oldStats.oldHP = 0;
	oldStats.oldLust = 0;
	oldStats.oldFatigue = 0;
	oldStats.oldHunger = 0;
}

public function openURL(url:String):void
{
    navigateToURL(new URLRequest(url), "_blank");
}

/**
 * Awards the achievement. Will display a blue text if achievement hasn't been earned.
 * @param	title The name of the achievement.
 * @param	achievement The achievement to be awarded.
 * @param	display Determines if achievement earned should be displayed.
 * @param	nl Inserts a new line before the achievement text.
 * @param	nl2 Inserts a new line after the achievement text.
 */
public function awardAchievement(title:String, achievement:*, display:Boolean = true, nl:Boolean = false, nl2:Boolean = true):void {
	if (achievements[achievement] != null) {
		if (achievements[achievement] <= 0) {
			achievements[achievement] = 1;
			if (nl && display) outputText("\n");
			if (display) outputText("<b><font color=\"#000080\">Achievement unlocked: " + title + "</font></b>");
			if (nl2 && display) outputText("\n");
			kGAMECLASS.saves.savePermObject(false); //Only save if the achievement hasn't been previously awarded.
		}
	}
	else outputText("\n<b>ERROR: Invalid achievement!</b>");
}


public function testDynStatsEvent():void {
	clearOutput();
	outputText("Old: "+player.str+" "+player.tou+" "+player.spe+" "+player.inte+" "+player.lib+" "+player.sens+" "+player.lust+"\n");
	player.dynStats("tou", 1, "spe+", 2, "int-", 3, "lib*", 2, "sen=", 25,"lust/",2);
	outputText("Mod: 0 1 +2 -3 *2 =25 /2\n");
	outputText("New: "+player.str+" "+player.tou+" "+player.spe+" "+player.inte+" "+player.lib+" "+player.sens+" "+player.lust+"\n");
	doNext(playerMenu);
}

/**
 * Modify stats.
 *
 * Arguments should come in pairs nameOp:String, value:Number/Boolean <br/>
 * where nameOp is ( stat_name + [operator] ) and value is operator argument<br/>
 * valid operators are "=" (set), "+", "-", "*", "/", add is default.<br/>
 * valid stat_names are "str", "tou", "spe", "int", "lib", "sen", "lus", "cor" or their full names;
 * also "scaled"/"sca" (default true: apply resistances, perks; false - force values)
 *
 * @return Object of (newStat-oldStat) with keys str, tou, spe, int, lib, sen, lus, cor
 * */
public function dynStats(... args):Object {
	return player.dynStats.apply(player,args);
}

	
public function showUpDown():void { //Moved from StatsView.
	function _oldStatNameFor(statName:String):String {
		return 'old' + statName.charAt(0).toUpperCase() + statName.substr(1);
	}

	var statName:String,
		oldStatName:String,
		allStats:Array;

//	mainView.statsView.upDownsContainer.visible = true;

	allStats = ["str", "tou", "spe", "inte", "lib", "sens", "cor", "HP", "lust", "fatigue", "hunger"];

	for each(statName in allStats) {
		oldStatName = _oldStatNameFor(statName);

		if (player[statName] > oldStats[oldStatName]) {
			mainView.statsView.showStatUp(statName);
		}
		if (player[statName] < oldStats[oldStatName]) {
			mainView.statsView.showStatDown(statName);
		}
	}
}

/**
 * Returns true if you're on SFW mode.
 */
public function doSFWloss():Boolean {
	clearOutput();
	if (flags[kFLAGS.SFW_MODE] > 0) {
		if (player.HP <= 0) outputText("You collapse from your injuries.");
		else outputText("You collapse from your overwhelming desires.");
		if (combat.inCombat) combat.cleanupAfterCombat();
		else doNext(camp.returnToCampUseOneHour)
		return true;
	}
	else return false;
}

public function isPeaceful():Boolean {
	return flags[kFLAGS.EASY_MODE_ENABLE_FLAG] <= -2;
}

public function doNothing():void {
	//This literally does nothing.
}