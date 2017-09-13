﻿//CoC Creature.as
package classes
{
	import classes.BodyParts.Neck;
	import classes.BodyParts.RearBody;
	import classes.BodyParts.Skin;
	import classes.BodyParts.UnderBody;
	import classes.BodyParts.Wings;
import classes.GlobalFlags.kGAMECLASS;
import classes.GlobalFlags.kGAMECLASS;
	import classes.GlobalFlags.kFLAGS;
	import classes.Items.JewelryLib;
import classes.internals.Profiling;
import classes.internals.Utils;
	import classes.Scenes.Places.TelAdre.UmasShop;
import classes.internals.profiling.Begin;
import classes.internals.profiling.End;

import flash.errors.IllegalOperationError;

	public class Creature extends Utils
	{

		include "../../includes/appearanceDefs.as";

		public function get game():CoC {
			return kGAMECLASS;
		}
		public function get flags():DefaultDict {
			return game.flags;
		}

		//Variables
		
		//Short refers to player name and monster name. BEST VARIABLE NAME EVA!
		//"a" refers to how the article "a" should appear in text. 
		private var _short:String = "You";
		private var _a:String = "a ";
		public function get short():String { return _short; }
		public function set short(value:String):void { _short = value; }
		public function get a():String { return _a; }
		public function set a(value:String):void { _a = value; }
		public function get capitalA():String {
			if (_a.length == 0) return "";
			return _a.charAt(0).toUpperCase() + _a.substr(1);
		}

		//Weapon
		private var _weaponName:String = "";
		private var _weaponVerb:String = "";
		private var _weaponAttack:Number = 0;
		private var _weaponPerk:String = "";
		private var _weaponValue:Number = 0;
		public function get weaponName():String { return _weaponName; }
		public function get weaponVerb():String { return _weaponVerb; }
		public function get weaponAttack():Number { return _weaponAttack; }
		public function get weaponPerk():String { return _weaponPerk; }
		public function get weaponValue():Number { return _weaponValue; }
		public function set weaponName(value:String):void { _weaponName = value; }
		public function set weaponVerb(value:String):void { _weaponVerb = value; }
		public function set weaponAttack(value:Number):void { _weaponAttack = value; }
		public function set weaponPerk(value:String):void { _weaponPerk = value; }
		public function set weaponValue(value:Number):void { _weaponValue = value; }
		//Clothing/Armor
		private var _armorName:String = "";
		private var _armorDef:Number = 0;
		private var _armorPerk:String = "";
		private var _armorValue:Number = 0;
		public function get armorName():String { return _armorName; }
		public function get armorDef():Number { return _armorDef; }
		public function get armorPerk():String { return _armorPerk; }
		public function get armorValue():Number { return _armorValue; }
		public function set armorValue(value:Number):void { _armorValue = value; }
		public function set armorName(value:String):void { _armorName = value; }
		public function set armorDef(value:Number):void { _armorDef = value; }
		public function set armorPerk(value:String):void { _armorPerk = value; }
		//Jewelry!
		private var _jewelryName:String = "";
		private var _jewelryEffectId:Number = 0;
		private var _jewelryEffectMagnitude:Number = 0;
		private var _jewelryPerk:String = "";
		private var _jewelryValue:Number = 0;
		public function get jewelryName():String { return _jewelryName; }
		public function get jewelryEffectId():Number { return _jewelryEffectId; }
		public function get jewelryEffectMagnitude():Number { return _jewelryEffectMagnitude; }
		public function get jewelryPerk():String { return _jewelryPerk; }
		public function get jewelryValue():Number { return _jewelryValue; }
		public function set jewelryValue(value:Number):void { _jewelryValue = value; }
		public function set jewelryName(value:String):void { _jewelryName = value; }
		public function set jewelryEffectId(value:Number):void { _jewelryEffectId = value; }
		public function set jewelryEffectMagnitude(value:Number):void { _jewelryEffectId = value; }
		public function set jewelryPerk(value:String):void { _jewelryPerk = value; }
		//Shield!
		private var _shieldName:String = "";
		private var _shieldBlock:Number = 0;
		private var _shieldPerk:String = "";
		private var _shieldValue:Number = 0;
		public function get shieldName():String { return _shieldName; }
		public function get shieldBlock():Number { return _shieldBlock; }
		public function get shieldPerk():String { return _shieldPerk; }
		public function get shieldValue():Number { return _shieldValue; }
		public function set shieldValue(value:Number):void { _shieldValue = value; }
		public function set shieldName(value:String):void { _shieldName = value; }
		public function set shieldBlock(value:Number):void { _shieldBlock = value; }
		public function set shieldPerk(value:String):void { _shieldPerk = value; }
		//Undergarments!
		private var _upperGarmentName:String = "";
		private var _upperGarmentPerk:String = "";
		private var _upperGarmentValue:Number = 0;
		public function get upperGarmentName():String { return _upperGarmentName; }
		public function get upperGarmentPerk():String { return _upperGarmentPerk; }
		public function get upperGarmentValue():Number { return _upperGarmentValue; }
		public function set upperGarmentName(value:String):void { _upperGarmentName = value; }
		public function set upperGarmentPerk(value:String):void { _upperGarmentPerk = value; }
		public function set upperGarmentValue(value:Number):void { _upperGarmentValue = value; }
		
		private var _lowerGarmentName:String = "";
		private var _lowerGarmentPerk:String = "";
		private var _lowerGarmentValue:Number = 0;
		public function get lowerGarmentName():String { return _lowerGarmentName; }
		public function get lowerGarmentPerk():String { return _lowerGarmentPerk; }
		public function get lowerGarmentValue():Number { return _lowerGarmentValue; }
		public function set lowerGarmentName(value:String):void { _lowerGarmentName = value; }
		public function set lowerGarmentPerk(value:String):void { _lowerGarmentPerk = value; }
		public function set lowerGarmentValue(value:Number):void { _lowerGarmentValue = value; }
		//Primary stats
		public var str:Number = 0;
		public var tou:Number = 0;
		public var spe:Number = 0;
		public var inte:Number = 0;
		public var lib:Number = 0;
		public var sens:Number = 0;
		public var cor:Number = 0;
		public var fatigue:Number = 0;
		
		//Combat Stats
		public var HP:Number = 0;
		public var lust:Number = 0;		
		
		//Level Stats
		public var XP:Number = 0;
		public var level:Number = 0;
		public var gems:Number = 0;
		public var additionalXP:Number = 0;

		public function get str100():Number { return 100*str/getMaxStats('str'); }
		public function get tou100():Number { return 100*tou/getMaxStats('tou'); }
		public function get spe100():Number { return 100*spe/getMaxStats('spe'); }
		public function get inte100():Number { return 100*inte/getMaxStats('inte'); }
		public function get lib100():Number { return 100*lib/getMaxStats('lib'); }
		public function get sens100():Number { return 100*sens/getMaxStats('sens'); }
		public function get fatigue100():Number { return 100*fatigue/maxFatigue(); }
		public function get hp100():Number { return 100*HP/maxHP(); }
		public function get lust100():Number { return 100*lust/maxLust(); }

		/**
		 * @return keys: str, tou, spe, inte
		 */
		public function getAllMaxStats():Object {
			return {
				str:100,
				tou:100,
				spe:100,
				inte:100
			};
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
		 * @return Object of (newStat-oldStat) with keys str, tou, spe, inte, lib, sens, lust, cor
		 * */
		public function dynStats(... args):Object {
			Begin("Creature","dynStats");
			var argz:Object = parseDynStatsArgs(this, args);
			var prevStr:Number  = str;
			var prevTou:Number  = tou;
			var prevSpe:Number  = spe;
			var prevInte:Number  = inte;
			var prevLib:Number  = lib;
			var prevSens:Number  = sens;
			var prevLust:Number  = lust;
			var prevCor:Number  = cor;
			modStats(argz.str, argz.tou, argz.spe, argz.inte, argz.lib, argz.sens, argz.lust, argz.cor, argz.sca);
			End("Creature","dynStats");
			return {
				str:str-prevStr,
				tou:tou-prevTou,
				spe:spe-prevSpe,
				inte:inte-prevInte,
				lib:lib-prevLib,
				sens:sens-prevSens,
				lust:lust-prevLust,
				cor:cor-prevCor
			};
		}
		public function modStats(dstr:Number, dtou:Number, dspe:Number, dinte:Number, dlib:Number, dsens:Number, dlust:Number, dcor:Number, scale:Boolean = true):void {

			var maxes:Object = getAllMaxStats();
			str = Utils.boundFloat(1,str+dstr,maxes.str);
			tou = Utils.boundFloat(1,tou+dtou,maxes.tou);
			spe = Utils.boundFloat(1,spe+dspe,maxes.spe);
			inte = Utils.boundFloat(1,inte+dinte,maxes.inte);
			lib = Utils.boundFloat(minLib(),lib+dlib,100);
			sens = Utils.boundFloat(minSens(),sens+dsens,100);
			lust = Utils.boundFloat(minLust(),lust+dlust,maxLust());
			cor = Utils.boundFloat(0,cor+dcor,100);
			if (dtou>0) HP = Utils.boundFloat(-Infinity,HP+dtou*2,maxHP());
		}
		/**
		 * Modify Strength by `delta`. If scale = true, apply perk & effect modifiers. Return actual increase applied.
		 */
		public function modStr(delta:Number,scale:Boolean=true):Number {
			if (scale) return dynStats('str',delta).str;
			var s0:Number = str;
			str = Utils.boundFloat(1,str+delta,getMaxStats('str'));
			return str-s0;
		}
		/**
		 * Modify Toughness by `delta`. If scale = true, apply perk & effect modifiers. Return actual increase applied.
		 */
		public function modTou(delta:Number,scale:Boolean=true):Number {
			if (scale) return dynStats('tou',delta).tou;
			var s0:Number = tou;
			tou = Utils.boundFloat(1,tou+delta,getMaxStats('tou'));
			return tou-s0;
		}
		/**
		 * Modify Speed by `delta`. If scale = true, apply perk & effect modifiers. Return actual increase applied.
		 */
		public function modSpe(delta:Number,scale:Boolean=true):Number {
			if (scale) return dynStats('spe',delta).spe;
			var s0:Number = spe;
			spe = Utils.boundFloat(1,spe+delta,getMaxStats('spe'));
			return spe-s0;
		}
		/**
		 * Modify Intelligence by `delta`. If scale = true, apply perk & effect modifiers. Return actual increase applied.
		 */
		public function modInt(delta:Number,scale:Boolean=true):Number {
			if (scale) return dynStats('inte',delta).inte;
			var s0:Number = inte;
			inte = Utils.boundFloat(1,inte+delta,getMaxStats('int'));
			return inte-s0;
		}

		//Appearance Variables
		/**
		 * Get the gender of the creature, based on its genitalia or lack thereof. Not to be confused with gender identity by femininity.
		 * @return the current gender (0 = gender-less, 1 = male, 2 = female, 3 = hermaphrodite)
		 */
		public function get gender():int
		{
			if (hasCock() && hasVagina()) {
				return GENDER_HERM;
			}
			if (hasCock()) {
				return GENDER_MALE;
			}
			if (hasVagina()) {
				return GENDER_FEMALE;
			}
			return GENDER_NONE;
		}
		private var _tallness:Number = 0;
		public function get tallness():Number { return _tallness; }
		public function set tallness(value:Number):void { _tallness = value; }

		/*Hairtype
		0- normal
		1- feather
		2- ghost
		3- goo!
		4- anemononeoenoeneo!*/
		public var hairType:Number = HAIR_NORMAL;
		public var hairColor:String = "no";
		public var hairLength:Number = 0;
		
		public function get furColor():String { return skin.furColor; }
		public function set furColor(value:String):void { skin.furColor = value; }
		/*Beardstyle
		0- normal
		1- goatee
		2- clean-cut
		3- mountain-man*/
		public var beardStyle:Number = BEARD_NORMAL;
		public var beardLength:Number = 0;
				
		/*Skintype
		0 - skin
		1 - furry
		2 - scaley
		3 - goopey*/
		public var skin:Skin = new Skin();
		public function get skinType():Number { return skin.type; }
		public function set skinType(value:Number):void { skin.type = value; }
		public function get skinTone():String { return skin.tone; }
		public function set skinTone(value:String):void { skin.tone = value; }
		public function get skinDesc():String { return skin.desc; }
		public function set skinDesc(value:String):void { skin.desc = value; }
		public function get skinAdj():String { return skin.adj; }
		public function set skinAdj(value:String):void { skin.adj = value; }
		
/*		Facetype:
		0 - human
		1 - horse
		2 - dogface
		3 - cowface
		4 - sharkface-teeth
		5 - Human w/Naga fangz
		6 - kittah face
		7 - lizard face (durned argonians!)
		8 - bunnah faceahhh bunbun
		9 - kangaface
		10 - spidah-face (humanish)
		11 - foxface!
		12 - dragon face
		13 - Halfcoon
		14 - fullcoon
		15 - halfmouse
		16 - fullmouse*/
		public var faceType:Number = FACE_HUMAN;

		// <mod name="Predator arms" author="Stadler76">
		public var clawTone:String = "";
		public var clawType:Number = CLAW_TYPE_NORMAL;
		// </mod>
		public var rearBody:RearBody = new RearBody();
		public var neck:Neck = new Neck();
		public var underBody:UnderBody = new UnderBody();

		/*EarType
		-1 - none!
		0 - human
		1 - horse
		2 - dog
		3 - cow
		4 - elf
		5 - catzilla
		6 - Snakezilla
		7 - Bunbunz
		8 - Roo Ears
		9 - fox ears
		10 - dragon
		11 - coon
		12 - mouse*/
		public var earType:Number = EARS_HUMAN;
		public var earValue:Number = 0;
		
		/*Horntype
		1 - demonic
		2 - minotaur (cowlike)
		3 - Draconic/Lizard
		4 - Double draconic
		5 - Antlers
		6 - Goat*/
		public var hornType:Number = HORNS_NONE;
		public var horns:Number = 0;

		/*Wingtype
		0 - none
		1 - bee
		2 - large bee
		3 - faerie?
		4 - avian
		5 - dragoooon?
		6 - demon/bat
		7 - large demon/bat
		8 - shark wing lolololol
		9 - harpy
		10 - small dagron
		11 - trogdor wings
		12 - sandtrap wings*/
		public var wings:Wings = new Wings();
		public function get wingType():Number { return wings.type; }
		public function set wingType(value:Number):void { wings.type = value; }
		public function get wingColor():String { return wings.color; }
		public function set wingColor(value:String):void { wings.color = value; }
		public var wingDesc:String = "non-existant";

		/* lowerBody:
		0 - normal
		1 - hooves
		2 - paws
		3 - snakelike body
		4 - centaur!
		5 - demonic heels
		6 - demon foot-claws
		7 - bee legs
		8 - goo mound
		9 - catfeet
		10 - lizardfeet
		11 - MLP.
		12 - DAH BUNNY!
		13 - Harpah Legz
		14 - Roo feet!
		15 - Spider Legz
		16 - Drider Legs
		17 - foxpaws
		18 - dragonfeet
		19 - raccoonfeet*/
		public var lowerBody:Number = LOWER_BODY_TYPE_HUMAN;
		public var legCount:Number = 2;

		/*tailType:
		0 - none
		1 - horse
		2 - dog
		3 - demon
		4 - cow!
		5 - spider!
		6 - bee!
		7 - shark tail!
		8 - catTAIIIIIL
		9 - lizard tail
		10 - bunbuntail
		11 - harpybutt
		12 - rootail
		13 - foxtail
		14 - dagron tail
		15 - raccoon tail
		16 - mousetail*/
		public var tailType:Number = TAIL_TYPE_NONE;
		
		//Tail venom is a 0-100 slider used for tail attacks. Recharges per hour.
		public var tailVenom:Number = 0;
		//Tail recharge determines how fast venom/webs comes back per hour.
		public var tailRecharge:Number = 5;
		
		/*hipRating
		0 - boyish
		2 - slender
		4 - average
		6 - noticable/ample
		10 - curvy//flaring
		15 - child-bearing/fertile
		20 - inhumanly wide*/
		public var hipRating:Number = HIP_RATING_BOYISH;
		
		/*buttRating
		0 - buttless
		2 - tight
		4 - average
		6 - noticable
		8 - large
		10 - jiggly
		13 - expansive
		16 - huge
		20 - inconceivably large/big/huge etc*/
		public var buttRating:Number = BUTT_RATING_BUTTLESS;
		
		//Piercings
		//TODO: Pull this out into it's own class and enum.
		public var nipplesPierced:Number = 0;
		public var nipplesPShort:String = "";
		public var nipplesPLong:String = "";
		public var lipPierced:Number = 0;
		public var lipPShort:String = "";
		public var lipPLong:String = "";
		public var tonguePierced:Number = 0;
		public var tonguePShort:String = "";
		public var tonguePLong:String = "";
		public var eyebrowPierced:Number = 0;
		public var eyebrowPShort:String = "";
		public var eyebrowPLong:String = "";
		public var earsPierced:Number = 0;
		public var earsPShort:String = "";
		public var earsPLong:String = "";
		public var nosePierced:Number = 0;
		public var nosePShort:String = "";
		public var nosePLong:String = "";

		//Head ornaments. Definitely need to convert away from hard coded types.
		public var antennae:Number = ANTENNAE_NONE;

		//Eyetype
		public var eyeType:Number = EYES_HUMAN;
		public var eyeCount:Number = 2;

		//TongueType
		public var tongueType:Number = TONGUE_HUMAN;

		//ArmType
		public var armType:Number = ARM_TYPE_HUMAN;

		//GillType
		public var gillType:int = GILLS_NONE;
		public function hasGills():Boolean { return gillType != GILLS_NONE; }

		//Sexual Stuff		
		//MALE STUFF
		//public var cocks:Array;
		//TODO: Tuck away into Male genital class?
		public var cocks:/*Cock*/Array;
		//balls
		public var balls:Number = 0;
		public var cumMultiplier:Number = 1;
		public var ballSize:Number = 0;
		
		private var _hoursSinceCum:Number = 0;
		public function get hoursSinceCum():Number { return _hoursSinceCum; }
		public function set hoursSinceCum(v:Number):void {
			/*if (v == 0)
			{
				trace("noop");
			}*/
			_hoursSinceCum = v; 
		}
		
		//FEMALE STUFF
		//TODO: Box into Female genital class?
		public var vaginas:Vector.<VaginaClass>;
		//Fertility is a % out of 100. 
		public var fertility:Number = 10;
		public var nippleLength:Number = .25;
		public var breastRows:/*BreastRowClass*/Array;
		public var ass:AssClass = new AssClass();
		
		/**
		 * Check if the Creature has a vagina. If not, throw an informative Error.
		 * This should be more informative than the usual RangeError (Out of bounds).
		 * @throws IllegalOperationError if no vagina is present
		 */
		private function checkVaginaPresent():void {
			if (!hasVagina()) {
				throw new IllegalOperationError("Creature does not have vagina.")
			}
		}
		
		/**
		 * Get the clit length for the selected vagina (defaults to the first vagina).
		 * @param	vaginaIndex the vagina to query for the clit length
		 * @return the clit length of the vagina
		 * @throws IllegalOperationError if the Creature does not have a vagina
		 * @throws IllegalOperationError if the Creature does not have a vagina
		 * @throws RangeError if the selected vagina cannot be found
		 */
		public function getClitLength(vaginaIndex : int = 0) : Number {
			checkVaginaPresent();
			
			return vaginas[vaginaIndex].clitLength;
		}
		
		/**
		 * Set the clit length for the selected vagina (defaults to the first vagina).
		 * @param clitLength the clit length to set for the vagina
		 * @param vaginaIndex the vagina on witch to set the clit length
		 * @return the clit length of the vagina
		 * @throws IllegalOperationError if the Creature does not have a vagina
		 * @throws RangeError if the selected vagina cannot be found
		 */
		public function setClitLength(clitLength:Number, vaginaIndex : int = 0) : Number {
			checkVaginaPresent();
			
			vaginas[vaginaIndex].clitLength = clitLength;
			return getClitLength(vaginaIndex);
		}
		
		/**
		 * Change the clit length by the given amount. If the resulting length drops below 0, it will be set to 0 instead.
		 * @param	delta the amount to change, can be positive or negative
		 * @param	vaginaIndex the vagina whose clit will be changed
		 * @return the updated clit length
		 * @throws IllegalOperationError if the Creature does not have a vagina
		 * @throws RangeError if the selected vagina cannot be found
		 */
		public function changeClitLength(delta:Number, vaginaIndex:int = 0):Number {
			checkVaginaPresent();
			var newClitLength:Number = vaginas[vaginaIndex].clitLength += delta;
			return newClitLength < 0 ? 0 : newClitLength;
		}
		
		private var _femininity:Number = 50;
		public function get femininity():Number {
			var fem:Number = _femininity;
			const effect:StatusEffectClass = statusEffectByType(StatusEffects.UmasMassage);
			if (effect != null && effect.value1 == UmasShop.MASSAGE_MODELLING_BONUS) {
				fem += effect.value2;
			}
			if (fem > 100)
				fem = 100;
			return fem;
		}
		public function set femininity(value:Number):void
		{
			if (value > 100)
				value = 100;
			else if (value < 0)
				value = 0;
			_femininity = value;
		}
		
		public function validate():String
		{
			var error:String = "";
			// 2. Value boundaries etc
			// 2.1. non-negative Number fields
			error += Utils.validateNonNegativeNumberFields(this,"Monster.validate",[
				"balls", "ballSize", "cumMultiplier", "hoursSinceCum",
				"tallness", "hipRating", "buttRating", "lowerBody", "armType",
				"skinType", "hairLength", "hairType",
				"faceType", "earType", "tongueType", "eyeType",
				"str", "tou", "spe", "inte", "lib", "sens", "cor",
				// Allow weaponAttack to be negative as a penalty to strength-calculated damage
				// Same with armorDef, bonusHP, additionalXP
				"weaponValue", "armorValue",
				"lust", "fatigue",
				"level", "gems",
				"tailVenom", "tailRecharge", "horns",
				"HP", "XP"
			]);
			// 2.2. non-empty String fields
			error += Utils.validateNonEmptyStringFields(this,"Monster.validate",[
				"short",
				"skinDesc",
				"weaponName", "weaponVerb", "armorName"
			]);
			// 3. validate members
			for each (var cock:Cock in cocks) {
				error += cock.validate();
			}
			for each (var vagina:VaginaClass in vaginas) {
				error += vagina.validate();
			}
			for each (var row:BreastRowClass in breastRows) {
				error += row.validate();
			}
			error += ass.validate();
			// 4. Inconsistent fields
			// 4.1. balls
			if (balls>0 && ballSize<=0){
				error += "Balls are present but ballSize = "+ballSize+". ";
			}
			if (ballSize>0 && balls<=0){
				error += "No balls but ballSize = "+ballSize+". ";
			}
			// 4.2. hair
			if (hairLength <= 0) {
				if (hairType != HAIR_NORMAL) error += "No hair but hairType = " + hairType + ". ";
			}
			// 4.3. tail
			if (tailType == TAIL_TYPE_NONE) {
				if (tailVenom != 0) error += "No tail but tailVenom = "+tailVenom+". ";
			}
			// 4.4. horns
			if (hornType == HORNS_NONE){
				if (horns>0) error += "horns > 0 but hornType = HORNS_NONE. ";
			} else {
				if (horns==0) error += "Has horns but their number 'horns' = 0. ";
			}
			return error;
		}
		
		//Monsters have few perks, which I think should be a status effect for clarity's sake.
		//TODO: Move perks into monster status effects.
		private var _perks:Array;
		public function perk(i:int):PerkClass{
			return _perks[i];
		}
		public function get perks():Array {
			return _perks;
		}
		public function get numPerks():int {
			return _perks.length;
		}
		//Current status effects. This has got very muddy between perks and status effects. Will have to look into it.
		//Someone call the grammar police!
		//TODO: Move monster status effects into perks. Needs investigation though.
		public var statusEffects:Array;

		//Constructor
		public function Creature()
		{
			//cocks = new Array();
			//The world isn't ready for typed Arrays just yet.
			cocks = [];
			vaginas = new Vector.<VaginaClass>();
			breastRows = [];
			_perks = [];
			statusEffects = [];
			//keyItems = new Array();
		}

		//Functions			
		public function orgasmReal():void
		{
			dynStats("lus=", 0, "res", false);
			hoursSinceCum = 0;
			flags[kFLAGS.TIMES_ORGASMED]++;
			
			if (countCockSocks("gilded") > 0) {
				var randomCock:int = rand( cocks.length );
				var bonusGems:int = rand( cocks[randomCock].cockThickness ) + countCockSocks("gilded"); // int so AS rounds to whole numbers
				game.outputText("\n\nFeeling some minor discomfort in your " + cockDescript(randomCock) + " you slip it out of your [armor] and examine it. <b>With a little exploratory rubbing and massaging, you manage to squeeze out " + bonusGems + " gems from its cum slit.</b>\n\n" );
				gems += bonusGems;
			}
		}
		public function orgasm(type:String = 'Default', real:Boolean = true):void
		{
			// None-tails original doc includes ability to recover fatigue with after-combat sex. Though it could be OP...
			//if (game.inCombat && game.monster != null && (hasPerk(PerkLib.EnlightenedNinetails) || hasPerk(PerkLib.CorruptedNinetails))) {
				//fatigue -= game.monster.level * 2;
				//if (fatigue < 0) fatigue = 0;
			//}
			switch (type) {
				// Start with that, whats easy
				case 'Vaginal': if (kGAMECLASS.bimboProgress.ableToProgress() || flags[kFLAGS.TIMES_ORGASM_VAGINAL] < 10) flags[kFLAGS.TIMES_ORGASM_VAGINAL]++; break;
				case 'Anal':    if (kGAMECLASS.bimboProgress.ableToProgress() || flags[kFLAGS.TIMES_ORGASM_ANAL]    < 10) flags[kFLAGS.TIMES_ORGASM_ANAL]++;    break;
				case 'Dick':    if (kGAMECLASS.bimboProgress.ableToProgress() || flags[kFLAGS.TIMES_ORGASM_DICK]    < 10) flags[kFLAGS.TIMES_ORGASM_DICK]++;    break;
				case 'Lips':    if (kGAMECLASS.bimboProgress.ableToProgress() || flags[kFLAGS.TIMES_ORGASM_LIPS]    < 10) flags[kFLAGS.TIMES_ORGASM_LIPS]++;    break;
				case 'Tits':    if (kGAMECLASS.bimboProgress.ableToProgress() || flags[kFLAGS.TIMES_ORGASM_TITS]    < 10) flags[kFLAGS.TIMES_ORGASM_TITS]++;    break;
				case 'Nipples': if (kGAMECLASS.bimboProgress.ableToProgress() || flags[kFLAGS.TIMES_ORGASM_NIPPLES] < 10) flags[kFLAGS.TIMES_ORGASM_NIPPLES]++; break;
				case 'Ovi':     break;

				// Now to the more complex types
				case 'VaginalAnal':
					orgasm((hasVagina() ? 'Vaginal' : 'Anal'), real);
					return; // Prevent calling orgasmReal() twice

				case 'DickAnal':
					orgasm((rand(2) == 0 ? 'Dick' : 'Anal'), real);
					return;

				case 'Default':
				case 'Generic':
				default:
					if (!hasVagina() && !hasCock()) {
						orgasm('Anal'); // Failsafe for genderless PCs
						return;
					}

					if (hasVagina() && hasCock()) {
						orgasm((rand(2) == 0 ? 'Vaginal' : 'Dick'), real);
						return;
					}

					orgasm((hasVagina() ? 'Vaginal' : 'Dick'), real);
					return;
			}

			if (real) orgasmReal();
		}

		public function newGamePlusMod():int
		{
			//Constrains value between 0 and 4.
			return Math.max(0, Math.min(4, flags[kFLAGS.NEW_GAME_PLUS_LEVEL]));
		}

		public function ascensionFactor(multiplier:Number = 25):Number
		{
			return newGamePlusMod() * multiplier;
		}

		public function ngPlus(value:Number, multiplier:Number = 25):Number
		{
			return value + ascensionFactor(multiplier);
		}

		//Create a perk
		public function createPerk(ptype:PerkType, value1:Number, value2:Number, value3:Number, value4:Number):void
		{
			var newKeyItem:PerkClass = new PerkClass(ptype);
			//used to denote that the array has already had its new spot pushed on.
			var arrayed:Boolean = false;
			//used to store where the array goes
			var keySlot:Number = 0;
			var counter:Number = 0;
			//Start the array if its the first bit
			if (perks.length == 0)
			{
				//trace("New Perk Started Array! " + keyName);
				perks.push(newKeyItem);
				arrayed = true;
				keySlot = 0;
			}
			//If it belongs at the end, push it on
			if (perk(perks.length - 1).perkName < ptype.name && !arrayed)
			{
				//trace("New Perk Belongs at the end!! " + keyName);
				perks.push(newKeyItem);
				arrayed = true;
				keySlot = perks.length - 1;
			}
			//If it belongs in the beginning, splice it in
			if (perk(0).perkName > ptype.name && !arrayed)
			{
				//trace("New Perk Belongs at the beginning! " + keyName);
				perks.splice(0, 0, newKeyItem);
				arrayed = true;
				keySlot = 0;
			}
			//Find the spot it needs to go in and splice it in.
			if (!arrayed)
			{
				//trace("New Perk using alphabetizer! " + keyName);
				counter = perks.length;
				while (counter > 0 && !arrayed)
				{
					counter--;
					//If the current slot is later than new key
					if (perk(counter).perkName > ptype.name)
					{
						//If the earlier slot is earlier than new key && a real spot
						if (counter - 1 >= 0)
						{
							//If the earlier slot is earlier slot in!
							if (perk(counter - 1).perkName <= ptype.name)
							{
								arrayed = true;
								perks.splice(counter, 0, newKeyItem);
								keySlot = counter;
							}
						}
						//If the item after 0 slot is later put here!
						else
						{
							//If the next slot is later we are go
							if (perk(counter).perkName <= ptype.name) {
								arrayed = true;
								perks.splice(counter, 0, newKeyItem);
								keySlot = counter;
							}
						}
					}
				}
			}
			//Fallback
			if (!arrayed)
			{
				//trace("New Perk Belongs at the end!! " + keyName);
				perks.push(newKeyItem);
				keySlot = perks.length - 1;
			}
			
			perk(keySlot).value1 = value1;
			perk(keySlot).value2 = value2;
			perk(keySlot).value3 = value3;
			perk(keySlot).value4 = value4;
			//trace("NEW PERK FOR PLAYER in slot " + keySlot + ": " + perk(keySlot).perkName);
		}

		/**
		 * Remove perk. Return true if there was such perk
		 */
		public function removePerk(ptype:PerkType):Boolean
		{
			var counter:Number = perks.length;
			//Various Errors preventing action
			if (perks.length <= 0)
			{
				return false;
			}
			if (perkv4(ptype) > 0)
			{
				// trace('ERROR! Attempted to remove permanent "' + ptype.name + '" perk.');
				return false;
			}
			while (counter > 0)
			{
				counter--;
				if (perk(counter).ptype == ptype)
				{
					perks.splice(counter, 1);
					//trace("Attempted to remove \"" + perkName + "\" perk.");
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Find an array element number for a perk. Useful when you want to work with a PerkClass instance.
		 */
		public function findPerk(ptype:PerkType):Number
		{
			if (perks.length <= 0)
				return -2;
			for (var counter:int = 0; counter<perks.length; counter++)
			{
				if (perk(counter).ptype == ptype)
					return counter;
			}
			return -1;
		}
		
		/**
		 * Check if this creature has specified perk.
		 */
		public function hasPerk(ptype:PerkType):Boolean
		{
			if (perks.length <= 0)
				return false;
			for (var counter:int = 0; counter<perks.length; counter++)
			{
				if (perk(counter).ptype == ptype)
					return true;
			}
			return false;
		}
		
		//Duplicate perk
		//Deprecated?
		public function perkDuplicated(ptype:PerkType):Boolean
		{
			var timesFound:int = 0;
			if (perks.length <= 0)
				return false;
			for (var counter:int = 0; counter<perks.length; counter++)
			{
				if (perk(counter).ptype == ptype)
					timesFound++;
			}
			return (timesFound > 1);
		}
		
		//remove all perks
		public function removePerks():void
		{
			_perks = [];
		}
		
		public function addPerkValue(ptype:PerkType, valueIdx:Number = 1, bonus:Number = 0): void
		{
			var counter:int = findPerk(ptype);
			if (counter < 0) {
				trace("ERROR? Looking for perk '" + ptype + "' to change value " + valueIdx + ", and player does not have the perk.");
				return;
			}
			if (valueIdx < 1 || valueIdx > 4) {
				CoC_Settings.error("addPerkValue(" + ptype.id + ", " + valueIdx + ", " + bonus + ").");
				return;
			}
			if (valueIdx == 1)
				perk(counter).value1 += bonus;
			if (valueIdx == 2)
				perk(counter).value2 += bonus;
			if (valueIdx == 3)
				perk(counter).value3 += bonus;
			if (valueIdx == 4)
				perk(counter).value4 += bonus;
		}
		
		public function setPerkValue(ptype:PerkType, valueIdx:Number = 1, newNum:Number = 0): void
		{
			var counter:Number = findPerk(ptype);
			//Various Errors preventing action
			if (counter < 0) {
				trace("ERROR? Looking for perk '" + ptype + "' to change value " + valueIdx + ", and player does not have the perk.");
				return;
			}
			if (valueIdx < 1 || valueIdx > 4)
			{
				CoC_Settings.error("setPerkValue(" + ptype.id + ", " + valueIdx + ", " + newNum + ").");
				return;
			}
			if (valueIdx == 1)
				perk(counter).value1 = newNum;
			if (valueIdx == 2)
				perk(counter).value2 = newNum;
			if (valueIdx == 3)
				perk(counter).value3 = newNum;
			if (valueIdx == 4)
				perk(counter).value4 = newNum;
		}
		
		public function perkv1(ptype:PerkType):Number
		{
			var counter:Number = findPerk(ptype);
			if (counter < 0)
			{
				// trace("ERROR? Looking for perk '" + ptype + "', but player does not have it.");
				return 0;
			}
			return perk(counter).value1;
		}
		
	public function perkv2(ptype:PerkType):Number
	{
		var counter:Number = findPerk(ptype);
		if (counter < 0)
		{
			// trace("ERROR? Looking for perk '" + ptype + "', but player does not have it.");
			return 0;
		}
		return perk(counter).value2;
	}
		
	public function perkv3(ptype:PerkType):Number
	{
		var counter:Number = findPerk(ptype);
		if (counter < 0)
		{
			trace("ERROR? Looking for perk '" + ptype + "', but player does not have it.");
			return 0;
		}
		return perk(counter).value3;
	}
		
	public function perkv4(ptype:PerkType):Number
	{
		var counter:Number = findPerk(ptype);
		if (counter < 0)
		{
			// trace("ERROR? Looking for perk '" + ptype + "', but player does not have it.");
			return 0;
		}
		return perk(counter).value4;
	}
		
		//{region StatusEffects
		public function createOrFindStatusEffect(stype:StatusEffectType):StatusEffectClass
		{
			var sec:StatusEffectClass = statusEffectByType(stype);
			if (!sec) sec = createStatusEffect(stype,0,0,0,0);
			return sec;
		}
		//Create a status
		public function createStatusEffect(stype:StatusEffectType, value1:Number, value2:Number, value3:Number, value4:Number, fireEvent:Boolean = true):StatusEffectClass
		{
			var newStatusEffect:StatusEffectClass = stype.create(value1,value2,value3,value4);
			statusEffects.push(newStatusEffect);
			newStatusEffect.addedToHostList(this,fireEvent);
			return newStatusEffect;
		}
		public function addStatusEffect(sec:StatusEffectClass/*,fireEvent:Boolean = true*/):void {
			if (sec.host != this) {
				sec.remove();
				sec.attach(this/*,fireEvent*/);
			} else {
				statusEffects.push(sec);
				sec.addedToHostList(this,true);
			}
		}
		//Remove a status
		public function removeStatusEffect(stype:StatusEffectType/*, fireEvent:Boolean = true*/):StatusEffectClass
		{
			var counter:Number = indexOfStatusEffect(stype);
			if (counter < 0) return null;
			var sec:StatusEffectClass = statusEffects[counter];
			statusEffects.splice(counter, 1);
			sec.removedFromHostList(true);
			return sec;
		}
		public function removeStatusEffectInstance(sec:StatusEffectClass/*, fireEvent:Boolean = true*/):void {
			var i:int = statusEffects.indexOf(sec);
			if (i < 0) return;
			statusEffects.splice(i, 1);
			sec.removedFromHostList(true);
		}
		
		public function indexOfStatusEffect(stype:StatusEffectType):int {
			for (var counter:int = 0; counter < statusEffects.length; counter++) {
				if ((statusEffects[counter] as StatusEffectClass).stype == stype)
					return counter;
			}
			return -1;
		}

		public function statusEffectByType(stype:StatusEffectType):StatusEffectClass {
			var idx:int = indexOfStatusEffect(stype);
			return idx<0 ? null : statusEffects[idx];
		}
		public function hasStatusEffect(stype:StatusEffectType):Boolean {
			return indexOfStatusEffect(stype) >= 0;
		}
		//}endregion
		
		public function changeStatusValue(stype:StatusEffectType, statusValueNum:Number = 1, newNum:Number = 0):void {
			var effect:StatusEffectClass = statusEffectByType(stype);
			//Various Errors preventing action
			if (effect == null)return;
			if (statusValueNum < 1 || statusValueNum > 4) {
				CoC_Settings.error("ChangeStatusValue called with invalid status value number.");
				return;
			}
			if (statusValueNum == 1)
				effect.value1 = newNum;
			if (statusValueNum == 2)
				effect.value2 = newNum;
			if (statusValueNum == 3)
				effect.value3 = newNum;
			if (statusValueNum == 4)
				effect.value4 = newNum;
		}
		
		public function addStatusValue(stype:StatusEffectType, statusValueNum:Number = 1, bonus:Number = 0):void
		{
			//Various Errors preventing action
			var effect:StatusEffectClass = statusEffectByType(stype);
			if (effect == null) return;
			if (statusValueNum < 1 || statusValueNum > 4)
			{
				CoC_Settings.error("ChangeStatusValue called with invalid status value number.");
				return;
			}
			if (statusValueNum == 1)
				effect.value1 += bonus;
			if (statusValueNum == 2)
				effect.value2 += bonus;
			if (statusValueNum == 3)
				effect.value3 += bonus;
			if (statusValueNum == 4)
				effect.value4 += bonus;
		}
		
		public function statusEffect(idx:int):StatusEffectClass
		{
			return statusEffects [idx];
		}
		
		public function statusEffectv1(stype:StatusEffectType,defaultValue:Number=0):Number
		{
			var effect:StatusEffectClass = statusEffectByType(stype);
			return (effect==null)?defaultValue:effect.value1;
		}
		
		public function statusEffectv2(stype:StatusEffectType,defaultValue:Number=0):Number
		{
			var effect:StatusEffectClass = statusEffectByType(stype);
			return (effect==null)?defaultValue:effect.value2;
		}

		public function statusEffectv3(stype:StatusEffectType,defaultValue:Number=0):Number
		{
			var effect:StatusEffectClass = statusEffectByType(stype);
			return (effect==null)?defaultValue:effect.value3;
		}

		public function statusEffectv4(stype:StatusEffectType,defaultValue:Number=0):Number
		{
			var effect:StatusEffectClass = statusEffectByType(stype);
			return (effect==null)?defaultValue:effect.value4;
		}

		public function removeStatuses(fireEvent:Boolean):void
		{
			var a:/*StatusEffectClass*/Array=statusEffects.splice(0,statusEffects.length);
			for (var n:int=a.length,i:int=0;i<n;i++) {
				a[i].removedFromHostList(fireEvent);
			}
		}
		
		public function biggestTitSize():Number
		{
			if (breastRows.length == 0)
				return -1;
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (breastRows[index].breastRating < breastRows[counter].breastRating)
					index = counter;
			}
			return breastRows[index].breastRating;
		}
		
		public function cockArea(i_cockIndex:Number):Number
		{
			if (i_cockIndex >= cocks.length || i_cockIndex < 0)
				return 0;
			return (cocks[i_cockIndex].cockThickness * cocks[i_cockIndex].cockLength);
		}
		
		public function biggestCockLength():Number
		{
			if (cocks.length == 0)
				return 0;
			return cocks[biggestCockIndex()].cockLength;
		}
		
		public function biggestCockArea():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) < cockArea(counter))
					index = counter;
			}
			return cockArea(index);
		}
		
		//Find the second biggest dick and it's area.
		public function biggestCockArea2():Number
		{
			if (cocks.length <= 1)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			var index2:Number = -1;
			//Find the biggest
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) < cockArea(counter))
					index = counter;
			}
			//Reset counter and find the next biggest
			counter = cocks.length;
			while (counter > 0)
			{
				counter--;
				//Is this spot claimed by the biggest?
				if (counter != index)
				{
					//Not set yet?
					if (index2 == -1)
						index2 = counter;
					//Is the stored value less than the current one?
					if (cockArea(index2) < cockArea(counter))
					{
						index2 = counter;
					}
				}
			}
			//If it couldn't find a second biggest...
			if (index == index2)
				return 0;
			return cockArea(index2);
		}
		
		public function longestCock():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockLength < cocks[counter].cockLength)
					index = counter;
			}
			return index;
		}
		
		public function longestCockLength():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockLength < cocks[counter].cockLength)
					index = counter;
			}
			return cocks[index].cockLength;
		}
		
		public function longestHorseCockLength():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if ((cocks[index].cockType != CockTypesEnum.HORSE && cocks[counter].cockType == CockTypesEnum.HORSE) || (cocks[index].cockLength < cocks[counter].cockLength && cocks[counter].cockType == CockTypesEnum.HORSE))
					index = counter;
			}
			return cocks[index].cockLength;
		}
		
		public function twoDickRadarSpecial(width:int):Boolean
		{
			//No two dicks?  FUCK OFF
			if (cockTotal() < 2)
				return false;
			
			//Set up vars
			//Get thinnest, work done already
			var thinnest:int = thinnestCockIndex();
			var thinnest2:int = 0;
			//For ze loop
			var temp:int = 0;
			//Make sure they arent the same at initialization
			if (thinnest2 == thinnest)
				thinnest2 = 1;
			//Loop through to find 2nd thinnest
			while (temp < cocks.length)
			{
				if (cocks[thinnest2].cockThickness > cocks[temp].cockThickness && temp != thinnest)
					thinnest2 = temp;
				temp++;
			}
			//If the two thicknesses added together are less than the arg, true, else false
			return cocks[thinnest].cockThickness + cocks[thinnest2].cockThickness < width;
		}
		
		public function totalCockThickness():Number
		{
			var thick:Number = 0;
			var counter:Number = cocks.length;
			while (counter > 0)
			{
				counter--;
				thick += cocks[counter].cockThickness;
			}
			return thick;
		}
		
		public function thickestCock():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockThickness < cocks[counter].cockThickness)
					index = counter;
			}
			return index;
		}
		
		public function thickestCockThickness():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockThickness < cocks[counter].cockThickness)
					index = counter;
			}
			return cocks[index].cockThickness;
		}
		
		public function thinnestCockIndex():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockThickness > cocks[counter].cockThickness)
					index = counter;
			}
			return index;
		}
		
		public function smallestCockIndex():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) > cockArea(counter))
				{
					index = counter;
				}
			}
			return index;
		}
		
		public function smallestCockLength():Number
		{
			if (cocks.length == 0)
				return 0;
			return cocks[smallestCockIndex()].cockLength;
		}
		
		public function shortestCockIndex():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockLength > cocks[counter].cockLength)
					index = counter;
			}
			return index;
		}
		
		public function shortestCockLength():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cocks[index].cockLength > cocks[counter].cockLength)
					index = counter;
			}
			return cocks[index].cockLength;
		}
		
		//Find the biggest cock that fits inside a given value
		public function cockThatFits(i_fits:Number = 0, type:String = "area"):Number
		{
			if (cocks.length <= 0)
				return -1;
			var cockIdxPtr:int = cocks.length;
			//Current largest fitter
			var cockIndex:int = -1;
			while (cockIdxPtr > 0)
			{
				cockIdxPtr--;
				if (type == "area")
				{
					if (cockArea(cockIdxPtr) <= i_fits)
					{
						//If one already fits
						if (cockIndex >= 0)
						{
							//See if the newcomer beats the saved small guy
							if (cockArea(cockIdxPtr) > cockArea(cockIndex))
								cockIndex = cockIdxPtr;
						}
						//Store the index of fitting dick
						else
							cockIndex = cockIdxPtr;
					}
				}
				else if (type == "length")
				{
					if (cocks[cockIdxPtr].cockLength <= i_fits)
					{
						//If one already fits
						if (cockIndex >= 0)
						{
							//See if the newcomer beats the saved small guy
							if (cocks[cockIdxPtr].cockLength > cocks[cockIndex].cockLength)
								cockIndex = cockIdxPtr;
						}
						//Store the index of fitting dick
						else
							cockIndex = cockIdxPtr;
					}
				}
			}
			return cockIndex;
		}
		
		//Find the 2nd biggest cock that fits inside a given value
		public function cockThatFits2(fits:Number = 0):Number
		{
			if (cockTotal() == 1)
				return -1;
			var counter:Number = cocks.length;
			//Current largest fitter
			var index:Number = -1;
			var index2:Number = -1;
			while (counter > 0)
			{
				counter--;
				//Does this one fit?
				if (cockArea(counter) <= fits)
				{
					//If one already fits
					if (index >= 0)
					{
						//See if the newcomer beats the saved small guy
						if (cockArea(counter) > cockArea(index))
						{
							//Save old wang
							if (index != -1)
								index2 = index;
							index = counter;
						}
						//If this one fits and is smaller than the other great
						else
						{
							if ((cockArea(index2) < cockArea(counter)) && counter != index)
							{
								index2 = counter;
							}
						}
						if (index >= 0 && index == index2)
							trace("FUCK ERROR COCKTHATFITS2 SHIT IS BROKED!");
					}
					//Store the index of fitting dick
					else
						index = counter;
				}
			}
			return index2;
		}
		
		public function smallestCockArea():Number
		{
			if (cockTotal() == 0)
				return -1;
			return cockArea(smallestCockIndex());
		}
		
		public function smallestCock():Number
		{
			return cockArea(smallestCockIndex());
		}
		
		public function biggestCockIndex():Number
		{
			if (cocks.length == 0)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) < cockArea(counter))
					index = counter;
			}
			return index;
		}
		
		//Find the second biggest dick's index.
		public function biggestCockIndex2():Number
		{
			if (cocks.length <= 1)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			var index2:Number = 0;
			//Find the biggest
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) < cockArea(counter))
					index = counter;
			}
			//Reset counter and find the next biggest
			counter = cocks.length;
			while (counter > 0)
			{
				counter--;
				//Make sure index2 doesn't get stuck
				//at the same value as index1 if the
				//initial location is biggest.
				if (index == index2 && counter != index)
					index2 = counter;
				//Is the stored value less than the current one?
				if (cockArea(index2) < cockArea(counter))
				{
					//Make sure we don't set index2 to be the same
					//as the biggest dick.
					if (counter != index)
						index2 = counter;
				}
			}
			//If it couldn't find a second biggest...
			if (index == index2)
				return 0;
			return index2;
		}
		
		public function smallestCockIndex2():Number
		{
			if (cocks.length <= 1)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			var index2:Number = 0;
			//Find the smallest
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) > cockArea(counter))
					index = counter;
			}
			//Reset counter and find the next biggest
			counter = cocks.length;
			while (counter > 0)
			{
				counter--;
				//Make sure index2 doesn't get stuck
				//at the same value as index1 if the
				//initial location is biggest.
				if (index == index2 && counter != index)
					index2 = counter;
				//Is the stored value less than the current one?
				if (cockArea(index2) > cockArea(counter))
				{
					//Make sure we don't set index2 to be the same
					//as the biggest dick.
					if (counter != index)
						index2 = counter;
				}
			}
			//If it couldn't find a second biggest...
			if (index == index2)
				return 0;
			return index2;
		}
		
		//Find the third biggest dick index.
		public function biggestCockIndex3():Number
		{
			if (cocks.length <= 2)
				return 0;
			var counter:Number = cocks.length;
			var index:Number = 0;
			var index2:Number = -1;
			var index3:Number = -1;
			//Find the biggest
			while (counter > 0)
			{
				counter--;
				if (cockArea(index) < cockArea(counter))
					index = counter;
			}
			//Reset counter and find the next biggest
			counter = cocks.length;
			while (counter > 0)
			{
				counter--;
				//If this index isn't used already
				if (counter != index)
				{
					//Has index been set to anything yet?
					if (index2 == -1)
						index2 = counter;
					//Is the stored value less than the current one?
					else if (cockArea(index2) < cockArea(counter))
					{
						index2 = counter;
					}
				}
			}
			//If it couldn't find a second biggest...
			if (index == index2 || index2 == -1)
				index2 = 0;
			//Reset counter and find the next biggest
			counter = cocks.length;
			while (counter > 0)
			{
				counter--;
				//If this index isn't used already
				if (counter != index && counter != index2)
				{
					//Has index been set to anything yet?
					if (index3 == -1)
						index3 = counter;
					//Is the stored value less than the current one?
					else if (cockArea(index3) < cockArea(counter))
					{
						index3 = counter;
					}
				}
			}
			//If it fails for some reason.
			if (index3 == -1)
				index3 = 0;
			return index3;
		}

		
		public function cockDescript(cockIndex:int = 0):String
		{
			return Appearance.cockDescript(this, cockIndex);
		}
		
		public function cockAdjective(index:Number = -1):String {
			if (index < 0) index = biggestCockIndex();
			var isPierced:Boolean = (cocks.length == 1) && (cocks[index].isPierced); //Only describe as pierced or sock covered if the creature has just one cock
			var hasSock:Boolean = (cocks.length == 1) && (cocks[index].sock != "");
			var isGooey:Boolean = (skinType == SKIN_TYPE_GOO);
			return Appearance.cockAdjective(cocks[index].cockType, cocks[index].cockLength, cocks[index].cockThickness, lust, cumQ(), isPierced, hasSock, isGooey);
		}
		
		public function wetness():Number
		{
			if (vaginas.length == 0)
				return 0;
			else
				return vaginas[0].vaginalWetness;
		}
		
		public function vaginaType(newType:int = -1):int
		{
			if (!hasVagina())
				return -1;
			if (newType != -1)
			{
				vaginas[0].type = newType;
			}
			return vaginas[0].type;
		}
		
		public function looseness(vag:Boolean = true):Number
		{
			if (vag)
			{
				if (vaginas.length == 0)
					return 0;
				else
					return vaginas[0].vaginalLooseness;
			}
			else
			{
				return ass.analLooseness;
			}
		}
		
		/**
		 * Get the vaginal capacity bonus based on body type, perks and the bonus capacity status.
		 * 
		 * @return the vaginal capacity bonus for this creature
		 */
		private function vaginalCapacityBonus():Number {
			var bonus:Number = 0;
			
			if (!hasVagina()) {
				return 0;
			}

			if (isTaur()){
				bonus += 50;
			}else if (lowerBody == LOWER_BODY_TYPE_NAGA){
				bonus += 20;
			}

			if (hasPerk(PerkLib.WetPussy))
				bonus += 20;
			if (hasPerk(PerkLib.HistorySlut))
				bonus += 20;
			if (hasPerk(PerkLib.OneTrackMind))
				bonus += 10;
			if (hasPerk(PerkLib.Cornucopia))
				bonus += 30;
			if (hasPerk(PerkLib.FerasBoonWideOpen))
				bonus += 25;
			if (hasPerk(PerkLib.FerasBoonMilkingTwat))
				bonus += 40;
				
			bonus += statusEffectv1(StatusEffects.BonusVCapacity);	
				
			return bonus;
		}
		
		public function vaginalCapacity():Number
		{
			if (!hasVagina()) {
				return 0;
			}
				
			var bonus:Number = vaginalCapacityBonus();
			return vaginas[0].capacity(bonus);
		}
		
		public function analCapacity():Number
		{
			var bonus:Number = 0;
			//Centaurs = +30 capacity
			if (isTaur())
				bonus = 30;
			if (hasPerk(PerkLib.HistorySlut))
				bonus += 20;
			if (hasPerk(PerkLib.Cornucopia))
				bonus += 30;
			if (hasPerk(PerkLib.OneTrackMind))
				bonus += 10;
			if (ass.analWetness > 0)
				bonus += 15;
			return ((bonus + statusEffectv1(StatusEffects.BonusACapacity) + 6 * ass.analLooseness * ass.analLooseness) * (1 + ass.analWetness / 10));
		}
		
		public function hasFuckableNipples():Boolean
		{
			var counter:Number = breastRows.length;
			while (counter > 0)
			{
				counter--;
				if (breastRows[counter].fuckable)
					return true;
			}
			return false;
		}
		
		public function hasBreasts():Boolean
		{
			if (breastRows.length > 0)
			{
				if (biggestTitSize() >= 1)
					return true;
			}
			return false;
		}
		
		public function hasNipples():Boolean
		{
			var counter:Number = breastRows.length;
			while (counter > 0)
			{
				counter--;
				if (breastRows[counter].nipplesPerBreast > 0)
					return true;
			}
			return false;
		}
		
		public function lactationSpeed():Number
		{
			//Lactation * breastSize x 10 (milkPerBreast) determines scene
			return biggestLactation() * biggestTitSize() * 10;
		}
		
		//Hacky code till I can figure out how to move appearance code out.
		//TODO: Get rid of this 
		public virtual function dogScore():Number {
			throw new Error("Not implemented. BAD");
		}
		
		//Hacky code till I can figure out how to move appearance code out.
		//TODO: Get rid of this
		public virtual function foxScore():Number {
			throw new Error("Not implemented. BAD");
		}
		
		public function biggestLactation():Number
		{
			if (breastRows.length == 0)
				return 0;
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				if (breastRows[index].lactationMultiplier < breastRows[counter].lactationMultiplier)
					index = counter;
			}
			return breastRows[index].lactationMultiplier;
		}
		public function milked():void
		{
			if (hasStatusEffect(StatusEffects.LactationReduction))
				changeStatusValue(StatusEffects.LactationReduction, 1, 0);
			if (hasStatusEffect(StatusEffects.LactationReduc0))
				removeStatusEffect(StatusEffects.LactationReduc0);
			if (hasStatusEffect(StatusEffects.LactationReduc1))
				removeStatusEffect(StatusEffects.LactationReduc1);
			if (hasStatusEffect(StatusEffects.LactationReduc2))
				removeStatusEffect(StatusEffects.LactationReduc2);
			if (hasStatusEffect(StatusEffects.LactationReduc3))
				removeStatusEffect(StatusEffects.LactationReduc3);
			if (hasPerk(PerkLib.Feeder))
			{
				//You've now been milked, reset the timer for that
				addStatusValue(StatusEffects.Feeder,1,1);
				changeStatusValue(StatusEffects.Feeder, 2, 0);
			}
		}
		public function boostLactation(todo:Number):Number
		{
			if (breastRows.length == 0)
				return 0;
			var counter:Number = breastRows.length;
			var index:Number = 0;
			var changes:Number = 0;
			var temp2:Number = 0;
			//Prevent lactation decrease if lactating.
			if (todo >= 0)
			{
				if (hasStatusEffect(StatusEffects.LactationReduction))
					changeStatusValue(StatusEffects.LactationReduction, 1, 0);
				if (hasStatusEffect(StatusEffects.LactationReduc0))
					removeStatusEffect(StatusEffects.LactationReduc0);
				if (hasStatusEffect(StatusEffects.LactationReduc1))
					removeStatusEffect(StatusEffects.LactationReduc1);
				if (hasStatusEffect(StatusEffects.LactationReduc2))
					removeStatusEffect(StatusEffects.LactationReduc2);
				if (hasStatusEffect(StatusEffects.LactationReduc3))
					removeStatusEffect(StatusEffects.LactationReduc3);
			}
			if (todo > 0)
			{
				while (todo > 0)
				{
					counter = breastRows.length;
					todo -= .1;
					while (counter > 0)
					{
						counter--;
						if (breastRows[index].lactationMultiplier > breastRows[counter].lactationMultiplier)
							index = counter;
					}
					temp2 = .1;
					if (breastRows[index].lactationMultiplier > 1.5)
						temp2 /= 2;
					if (breastRows[index].lactationMultiplier > 2.5)
						temp2 /= 2;
					if (breastRows[index].lactationMultiplier > 3)
						temp2 /= 2;
					changes += temp2;
					breastRows[index].lactationMultiplier += temp2;
				}
			}
			else
			{
				while (todo < 0)
				{
					counter = breastRows.length;
					index = 0;
					if (todo > -.1)
					{
						while (counter > 0)
						{
							counter--;
							if (breastRows[index].lactationMultiplier < breastRows[counter].lactationMultiplier)
								index = counter;
						}
						//trace(biggestLactation());
						breastRows[index].lactationMultiplier += todo;
						if (breastRows[index].lactationMultiplier < 0)
							breastRows[index].lactationMultiplier = 0;
						todo = 0;
					}
					else
					{
						todo += .1;
						while (counter > 0)
						{
							counter--;
							if (breastRows[index].lactationMultiplier < breastRows[counter].lactationMultiplier)
								index = counter;
						}
						temp2 = todo;
						changes += temp2;
						breastRows[index].lactationMultiplier += temp2;
						if (breastRows[index].lactationMultiplier < 0)
							breastRows[index].lactationMultiplier = 0;
					}
				}
			}
			return changes;
		}
		
		public function averageLactation():Number
		{
			if (breastRows.length == 0)
				return 0;
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0)
			{
				counter--;
				index += breastRows[counter].lactationMultiplier;
			}
			return Math.floor(index / breastRows.length);
		}
		
		//Calculate bonus virility rating!
		//anywhere from 5% to 100% of normal cum effectiveness thru herbs!
		public function virilityQ():Number
		{
			if (!hasCock())
				return 0;
			var percent:Number = 0.01;
			if (cumQ() >= 250)
				percent += 0.01;
			if (cumQ() >= 800)
				percent += 0.01;
			if (cumQ() >= 1600)
				percent += 0.02;
			if (hasPerk(PerkLib.BroBody))
				percent += 0.05;
			if (hasPerk(PerkLib.MaraesGiftStud))
				percent += 0.15;
			if (hasPerk(PerkLib.FerasBoonAlpha))
				percent += 0.10;
			if (perkv1(PerkLib.ElvenBounty) > 0)
				percent += 0.05;
			if (hasPerk(PerkLib.FertilityPlus))
				percent += 0.03;
			if (hasPerk(PerkLib.FertilityMinus) && lib100 < 25) //Reduces virility by 3%.
				percent -= 0.03;
			if (hasPerk(PerkLib.PiercedFertite))
				percent += 0.03;
			if (hasPerk(PerkLib.OneTrackMind))
				percent += 0.03;
			if (hasPerk(PerkLib.MagicalVirility))
				percent += 0.05 + (perkv1(PerkLib.MagicalVirility) * 0.01);
			//Messy Orgasms?
			if (hasPerk(PerkLib.MessyOrgasms))
				percent += 0.03;
			//Satyr Sexuality
			if (hasPerk(PerkLib.SatyrSexuality))
				percent += 0.10;
			//Fertite ring bonus!
			if (jewelryEffectId == JewelryLib.MODIFIER_FERTILITY)
				percent += (jewelryEffectMagnitude / 100);
			if (hasPerk(PerkLib.AscensionVirility))
				percent += perkv1(PerkLib.AscensionVirility) * 0.05;				
			if (percent > 1)
				percent = 1;
			if (percent < 0)
				percent = 0;

			return percent;
		}
		
		//Calculate cum return
		public function cumQ():Number
		{
			if (!hasCock())
				return 0;
			var quantity:Number = 0;
			//Base value is ballsize*ballQ*cumefficiency by a factor of 2.
			//Other things that affect it: 
			//lust - 50% = normal output.  0 = half output. 100 = +50% output.
			//trace("CUM ESTIMATE: " + int(1.25*2*cumMultiplier*2*(lust + 50)/10 * (hoursSinceCum+10)/24)/10 + "(no balls), " + int(ballSize*balls*cumMultiplier*2*(lust + 50)/10 * (hoursSinceCum+10)/24)/10 + "(withballs)");
			var lustCoefficient:Number = (lust + 50) / 10;
			//If realistic mode is enabled, limits cum to capacity.
			if (flags[kFLAGS.HUNGER_ENABLED] >= 1)
			{
				lustCoefficient = (lust + 50) / 5;
				if (hasPerk(PerkLib.PilgrimsBounty)) lustCoefficient = 30;
				var percent:Number = 0;
				percent = lustCoefficient + (hoursSinceCum + 10);
				if (percent > 100)
					percent = 100;
				if (quantity > cumCapacity()) 
					quantity = cumCapacity();
				return (percent / 100) * cumCapacity();
			}
			//Pilgrim's bounty maxes lust coefficient
			if (hasPerk(PerkLib.PilgrimsBounty))
				lustCoefficient = 150 / 10;
			if (balls == 0)
				quantity = int(1.25 * 2 * cumMultiplier * 2 * lustCoefficient * (hoursSinceCum + 10) / 24) / 10;
			else
				quantity = int(ballSize * balls * cumMultiplier * 2 * lustCoefficient * (hoursSinceCum + 10) / 24) / 10;
			if (hasPerk(PerkLib.BroBody))
				quantity *= 1.3;
			if (hasPerk(PerkLib.FertilityPlus))
				quantity *= 1.5;
			if (hasPerk(PerkLib.FertilityMinus) && lib100 < 25)
				quantity *= 0.7;
			if (hasPerk(PerkLib.MessyOrgasms))
				quantity *= 1.5;
			if (hasPerk(PerkLib.OneTrackMind))
				quantity *= 1.1;
			if (hasPerk(PerkLib.MaraesGiftStud))
				quantity += 350;
			if (hasPerk(PerkLib.FerasBoonAlpha))
				quantity += 200;
			if (hasPerk(PerkLib.MagicalVirility))
				quantity += 200 + (perkv1(PerkLib.MagicalVirility) * 100);
			if (hasPerk(PerkLib.FerasBoonSeeder))
				quantity += 1000;
			//if (hasPerk("Elven Bounty") >= 0) quantity += 250;;
			quantity += perkv1(PerkLib.ElvenBounty);
			if (hasPerk(PerkLib.BroBody))
				quantity += 200;
			if (hasPerk(PerkLib.SatyrSexuality))
				quantity += 50;
			quantity += statusEffectv1(StatusEffects.Rut);
			quantity *= (1 + (2 * perkv1(PerkLib.PiercedFertite)) / 100);
			if (jewelryEffectId == JewelryLib.MODIFIER_FERTILITY)
				quantity *= (1 + (jewelryEffectMagnitude / 100));
			//trace("Final Cum Volume: " + int(quantity) + "mLs.");
			//if (quantity < 0) trace("SOMETHING HORRIBLY WRONG WITH CUM CALCULATIONS");
			if (quantity < 2)
				quantity = 2;
			if (quantity > int.MAX_VALUE)
				quantity = int.MAX_VALUE;
			return quantity;
		}
		
		//Limits how much cum you can produce. Can be altered with perks, ball size, and multiplier. Only applies to realistic mode.
		public function cumCapacity():Number 
		{
			if (!hasCock()) return 0;
			var cumCap:Number = 0;
			//Alter capacity by balls.
			if (balls > 0) cumCap += Math.pow(((4 / 3) * Math.PI * (ballSize / 2)), 3) * balls// * cumMultiplier
			else cumCap +=  Math.pow(((4 / 3) * Math.PI * 1), 3) * 2// * cumMultiplier
			//Alter capacity by perks.
			if (hasPerk(PerkLib.BroBody)) cumCap *= 1.3;
			if (hasPerk(PerkLib.FertilityPlus)) cumCap *= 1.5;
			if (hasPerk(PerkLib.FertilityMinus) && lib100 < 25) cumCap *= 0.7;
			if (hasPerk(PerkLib.MessyOrgasms)) cumCap *= 1.5;
			if (hasPerk(PerkLib.OneTrackMind)) cumCap *= 1.1;
			if (hasPerk(PerkLib.MaraesGiftStud)) cumCap += 350;
			if (hasPerk(PerkLib.FerasBoonAlpha)) cumCap += 200;
			if (hasPerk(PerkLib.MagicalVirility)) cumCap += 200;
			if (hasPerk(PerkLib.FerasBoonSeeder)) cumCap += 1000;
			cumCap += perkv1(PerkLib.ElvenBounty);
			if (hasPerk(PerkLib.BroBody)) cumCap += 200;
			cumCap += statusEffectv1(StatusEffects.Rut);
			cumCap *= (1 + (2 * perkv1(PerkLib.PiercedFertite)) / 100);
			//Alter capacity by accessories.
			if (jewelryEffectId == JewelryLib.MODIFIER_FERTILITY) cumCap *= (1 + (jewelryEffectMagnitude / 100));
				
			cumCap *= cumMultiplier
			cumCap == Math.round(cumCap);
			if (cumCap > int.MAX_VALUE) 
				cumCap = int.MAX_VALUE;
			return cumCap;
		}
		
		public function countCocksOfType(type:CockTypesEnum):int {
			if (cocks.length == 0) return 0;
			var counter:int = 0;
			for (var x:int = 0; x < cocks.length; x++) {
				if (cocks[x].cockType == type) counter++;
			}
			return counter;
		}
		
		// Note: DogCocks/FoxCocks are functionally identical. They actually change back and forth depending on some
		// of the PC's attributes, and this is recaluculated every hour spent at camp.
		// As such, delineating between the two is kind of silly.
		public function dogCocks():int { //How many dogCocks
			if (cocks.length == 0) return 0;
			return countCocksOfType(CockTypesEnum.DOG) + countCocksOfType(CockTypesEnum.FOX);
		}
		
		public function wolfCocks():int {
			if (cocks.length == 0) return 0;
			return countCocksOfType(CockTypesEnum.WOLF);
		}
		
		public function findFirstCockType(ctype:CockTypesEnum):Number
		{
			var index:Number = 0;
			//if (cocks[index].cockType == ctype)
			//	return index;
			for (index = 0; index < cocks.length; index++) {
				if (cocks[index].cockType == ctype)
					return index;
			}
			//trace("Creature.findFirstCockType ERROR - searched for cocktype: " + ctype + " and could not find it.");
			return 0;
		}
		
		/*public function findFirstCockType(type:Number = 0):Number
		{
			var index:Number = 0;
			if (cocks[index].cockType == type)
				return index;
			while (index < cocks.length)
			{
				index++;
				if (cocks[index].cockType == type)
					return index;
			}
			//trace("Creature.findFirstCockType ERROR - searched for cocktype: " + type + " and could not find it.");
			return 0;
		}*/
		
		//Change first normal cock to horsecock!
		//Return number of affected cock, otherwise -1
		public function addHorseCock():Number
		{
			var counter:Number = cocks.length;
			while (counter > 0)
			{
				counter--;
				//Human - > horse
				if (cocks[counter].cockType == CockTypesEnum.HUMAN)
				{
					cocks[counter].cockType = CockTypesEnum.HORSE;
					return counter;
				}
				//Dog - > horse
				if (cocks[counter].cockType == CockTypesEnum.DOG)
				{
					cocks[counter].cockType = CockTypesEnum.HORSE;
					return counter;
				}
				//Wolf - > horse
				if (cocks[counter].cockType == CockTypesEnum.WOLF)
				{
					cocks[counter].cockType = CockTypesEnum.HORSE;
					return counter;
				}
				//Tentacle - > horse
				if (cocks[counter].cockType == CockTypesEnum.TENTACLE)
				{
					cocks[counter].cockType = CockTypesEnum.HORSE;
					return counter;
				}
				//Demon -> horse
				if (cocks[counter].cockType == CockTypesEnum.DEMON)
				{
					cocks[counter].cockType = CockTypesEnum.HORSE;
					return counter;
				}
				//Catch-all
				if (cocks[counter].cockType.Index > 4)
				{
					cocks[counter].cockType = CockTypesEnum.HORSE;
					return counter;
				}
			}
			return -1;
		}
		
		//TODO Seriously wtf. 1500+ calls to cockTotal, 340+ call to totalCocks. I'm scared to touch either.
		//How many cocks?
		public function cockTotal():Number
		{
			return (cocks.length);
		}
		
		//Alternate
		public function totalCocks():Number
		{
			return (cocks.length);
		}
		
		//BOolean alternate
		public function hasCock():Boolean
		{
			return cocks.length >= 1;

		}
		
		public function hasSockRoom():Boolean
		{
			var index:int = cocks.length;
			while (index > 0)
			{
				index--;
				if (cocks[index].sock == "")
					return true;
			}
			return false
		}
		
		public function hasSock(arg:String = ""):Boolean
		{
			var index:int = cocks.length;
			
			while (index > 0)
			{
				index--;
				if (cocks[index].sock != "")
				{
				if (arg == "" || cocks[index].sock == arg)
					return true;
				}
			}
			return false
		}
		public function countCockSocks(type:String):int
		{
			var count:int = 0;
			
			for (var i:Number = 0; i < cocks.length; i++) {
				if (cocks[i].sock == type) {
					count++
				}
			}
			//trace("countCockSocks found " + count + " " + type);
			return count;
		}
		
		public function canAutoFellate():Boolean
		{
			if (!hasCock())
				return false;
			return (cocks[0].cockLength >= 20);
		}

		public function copySkinToUnderBody(p:Object = null):void
		{
			underBody.skin.setProps(skin);
			if (p != null) underBody.skin.setProps(p);
		}

		public static const canFlyWings:Array = [
			WING_TYPE_BEE_LIKE_LARGE,
			WING_TYPE_BAT_LIKE_LARGE,
			WING_TYPE_FEATHERED_LARGE,
			WING_TYPE_DRACONIC_LARGE,
			WING_TYPE_GIANT_DRAGONFLY,
			WING_TYPE_IMP_LARGE,
			WING_TYPE_HARPY,
		];

		//PC can fly?
		public function canFly():Boolean
		{
			//web also makes false!
			if (hasStatusEffect(StatusEffects.Web))
				return false;
			return canFlyWings.indexOf(wingType) != -1;

		}

		public function canUseStare():Boolean
		{
			return [EYES_BASILISK, EYES_COCKATRICE].indexOf(eyeType) != -1;
		}

		public function isHoofed():Boolean
		{
			return [
				LOWER_BODY_TYPE_HOOFED,
				LOWER_BODY_TYPE_CLOVEN_HOOFED,
			].indexOf(lowerBody) != -1;
		}

		public function isCentaur():Boolean
		{
			return isTaur() && isHoofed();
		}

		public function isBimbo():Boolean
		{
			if (hasPerk(PerkLib.BimboBody)) return true;
			if (hasPerk(PerkLib.BimboBrains)) return true;
			if (hasPerk(PerkLib.FutaForm)) return true;
			if (hasPerk(PerkLib.FutaFaculties)) return true;

			return false;
		}

		//check for vagoo
		public function hasVagina():Boolean
		{
			return vaginas.length > 0;

		}
		
		public function hasVirginVagina():Boolean
		{
			if (vaginas.length > 0)
				return vaginas[0].virgin;
			return false;
		}

		//GENDER IDENTITIES
		public function genderText(male:String = "man", female:String = "woman", futa:String = "herm", eunuch:String = "eunuch"):String
		{
			if (vaginas.length > 0) {
				if (cocks.length > 0) return futa;
				return female;
			}
			else if (cocks.length > 0) {
				return male;
			}
			return eunuch;
		}

		public function manWoman(caps:Boolean = false):String
		{
			//Dicks?
			if (totalCocks() > 0)
			{
				if (hasVagina())
				{
					if (caps)
						return "Futa";
					else
						return "futa";
				}
				else
				{
					if (caps)
						return "Man";
					else
						return "man";
				}
			}
			else
			{
				if (hasVagina())
				{
					if (caps)
						return "Woman";
					else
						return "woman";
				}
				else
				{
					if (caps)
						return "Eunuch";
					else
						return "eunuch";
				}
			}
		}
		
		public function mfn(male:String, female:String, neuter:String):String
		{
			if (gender == 0)
				return neuter;
			else
				return mf(male, female);
		}
		
		//Rewritten!
		public function mf(male:String, female:String):String
		{
			if (hasCock() && hasVagina()) // herm
				return (biggestTitSize() >= 2 || biggestTitSize() == 1 && femininity >= 50 || femininity >= 75) ? female : male;

			if (hasCock()) // male
				return (biggestTitSize() >= 1 && femininity > 55 || femininity >= 75) ? female : male;

			if (hasVagina()) // pure female
				return (biggestTitSize() > 1 || femininity >= 45) ? female : male;

			// genderless
			return (biggestTitSize() >= 3 || femininity >= 75) ? female : male;
		}
		
		public function maleFemaleHerm(caps:Boolean = false):String
		{
			switch (gender) {
				case GENDER_NONE:   return caps ? mf("Genderless", "Fem-genderless") : mf("genderless", "fem-genderless");
				case GENDER_MALE:   return caps ? mf("Male", biggestTitSize() > BREAST_CUP_A ? "Shemale" : "Femboy")             : mf("male", biggestTitSize() > BREAST_CUP_A ? "shemale" : "femboy");
				case GENDER_FEMALE: return caps ? mf("Cuntboy", "Female")            : mf("cuntboy", "female");
				case GENDER_HERM:   return caps ? mf("Maleherm", "Hermaphrodite")    : mf("maleherm", "hermaphrodite");
				default: return "<b>Gender error!</b>";
			}
		}
		
		/**
		 * Checks if the creature is technically male: has cock but not vagina.
		 */
		public function isMale():Boolean
		{
			return gender == GENDER_MALE;
		}
		
		/**
		 * Checks if the creature is technically female: has vagina but not cock.
		 */
		public function isFemale():Boolean
		{
			return gender == GENDER_FEMALE;
		}
		
		/**
		 * Checks if the creature is technically herm: has both cock and vagina.
		 */
		public function isHerm():Boolean
		{
			return gender == GENDER_HERM;
		}
		
		/**
		 * Checks if the creature is technically genderless: has neither cock nor vagina.
		 */
		public function isGenderless():Boolean
		{
			return gender == GENDER_NONE;
		}

		/**
		 * Checks if the creature is technically male or herm: has at least a cock.
		 */
		public function isMaleOrHerm():Boolean
		{
			return (gender & GENDER_MALE) != 0;
		}

		/**
		 * Checks if the creature is technically female or herm: has at least a vagina.
		 */
		public function isFemaleOrHerm():Boolean
		{
			return (gender & GENDER_FEMALE) != 0;
		}
		
		//Create a cock. Default type is HUMAN
		public function createCock(clength:Number = 5.5, cthickness:Number = 1,ctype:CockTypesEnum=null):Boolean
		{
			if (ctype == null) ctype = CockTypesEnum.HUMAN;
			if (cocks.length >= 10)
				return false;
			var newCock:Cock = new Cock(clength, cthickness,ctype);
			//var newCock:cockClass = new cockClass();
			cocks.push(newCock);
			cocks[cocks.length-1].cockThickness = cthickness;
			cocks[cocks.length-1].cockLength = clength;
			return true;
		}
		
		//create vagoo
		public function createVagina(virgin:Boolean = true, vaginalWetness:Number = 1, vaginalLooseness:Number = 0):Boolean
		{
			if (vaginas.length >= 2)
				return false;
			var newVagina:VaginaClass = new VaginaClass(vaginalWetness,vaginalLooseness,virgin);
			vaginas.push(newVagina);
			return true;
		}
		
		//create a row of breasts
		public function createBreastRow(size:Number=0,nipplesPerBreast:Number=1):Boolean
		{
			if (breastRows.length >= 10)
				return false;
			var newBreastRow:BreastRowClass = new BreastRowClass();
			newBreastRow.breastRating = size;
			newBreastRow.nipplesPerBreast = nipplesPerBreast;
			breastRows.push(newBreastRow);
			return true;
		}
		
		//Remove cocks
		public function removeCock(arraySpot:int, totalRemoved:int):void
		{
			//Various Errors preventing action
			if (arraySpot < 0 || totalRemoved <= 0)
			{
				//trace("ERROR: removeCock called but arraySpot is negative or totalRemoved is 0.");
				return;
			}
			if (cocks.length == 0)
			{
				//trace("ERROR: removeCock called but cocks do not exist.");
			}
			else
			{
				if (arraySpot > cocks.length - 1)
				{
					//trace("ERROR: removeCock failed - array location is beyond the bounds of the array.");
				}
				else
				{
					try
					{
						var cock:Cock = cocks[arraySpot];
						if (cock.sock == "viridian")
						{
							removePerk(PerkLib.LustyRegeneration);
						}
						else if (cock.sock == "cockring")
						{
							var numRings:int = 0;
							for (var i:int = 0; i < cocks.length; i++)
							{
								if (cocks[i].sock == "cockring") numRings++;
							}
							
							if (numRings == 0) removePerk(PerkLib.PentUp);
							else setPerkValue(PerkLib.PentUp, 1, 5 + (numRings * 5));
						}
						cocks.splice(arraySpot, totalRemoved);
					}
					catch (e:Error)
					{
						trace("Argument error in Creature[" + this._short + "]: " + e.message);
					}
					//trace("Attempted to remove " + totalRemoved + " cocks.");
				}
			}
		}
		
		//REmove vaginas
		public function removeVagina(arraySpot:int = 0, totalRemoved:int = 1):void
		{
			//Various Errors preventing action
			if (arraySpot < -1 || totalRemoved <= 0)
			{
				//trace("ERROR: removeVagina called but arraySpot is negative or totalRemoved is 0.");
				return;
			}
			if (vaginas.length == 0)
			{
				//trace("ERROR: removeVagina called but cocks do not exist.");
			}
			else
			{
				if (arraySpot > vaginas.length - 1)
				{
					//trace("ERROR: removeVagina failed - array location is beyond the bounds of the array.");
				}
				else
				{
					vaginas.splice(arraySpot, totalRemoved);
					//trace("Attempted to remove " + totalRemoved + " vaginas.");
				}
			}
		}
		
		//Remove a breast row
		public function removeBreastRow(arraySpot:int, totalRemoved:int):void
		{
			//Various Errors preventing action
			if (arraySpot < -1 || totalRemoved <= 0)
			{
				//trace("ERROR: removeBreastRow called but arraySpot is negative or totalRemoved is 0.");
				return;
			}
			if (breastRows.length == 0)
			{
				//trace("ERROR: removeBreastRow called but cocks do not exist.");
			}
			else if (breastRows.length == 1 || breastRows.length - totalRemoved < 1)
			{
				//trace("ERROR: Removing the current breast row would break the Creature classes assumptions about breastRow contents.");
			}
			else
			{
				if (arraySpot > breastRows.length - 1)
				{
					//trace("ERROR: removeBreastRow failed - array location is beyond the bounds of the array.");
				}
				else
				{
					breastRows.splice(arraySpot, totalRemoved);
					//trace("Attempted to remove " + totalRemoved + " breastRows.");
				}
			}
		}
		
		// This is placeholder shit whilst I work out a good way of BURNING ENUM TO THE FUCKING GROUND
		// and replacing it with something that will slot in and work with minimal changes and not be
		// A FUCKING SHITSTAIN when it comes to intelligent de/serialization.
		public function fixFuckingCockTypesEnum():void
		{
			if (this.cocks.length > 0)
			{
				for (var i:int = 0; i < this.cocks.length; i++)
				{
					this.cocks[i].cockType = CockTypesEnum.ParseConstantByIndex(this.cocks[i].cockType.Index);
				}
			}
		}

		public function buttChangeNoDisplay(cArea:Number):Boolean {
			var stretched:Boolean = false;
			//cArea > capacity = autostreeeeetch half the time.
			if (cArea >= analCapacity() && rand(2) == 0) {
				ass.analLooseness++;
				stretched = true;
				//Reset butt stretchin recovery time
				if (hasStatusEffect(StatusEffects.ButtStretched)) changeStatusValue(StatusEffects.ButtStretched,1,0);
			}
			//If within top 10% of capacity, 25% stretch
			if (cArea < analCapacity() && cArea >= .9*analCapacity() && rand(4) == 0) {
				ass.analLooseness++;
				stretched = true;
			}
			//if within 75th to 90th percentile, 10% stretch
			if (cArea < .9 * analCapacity() && cArea >= .75 * analCapacity() && rand(10) == 0) {
				ass.analLooseness++;
				stretched = true;
			}
			//Anti-virgin
			if (ass.analLooseness == 0) {
				ass.analLooseness++;
				stretched = true;
			}
			if (ass.analLooseness > 5) ass.analLooseness = 5;
			//Delay un-stretching
			if (cArea >= .5 * analCapacity()) {
				//Butt Stretched used to determine how long since last enlargement
				if (!hasStatusEffect(StatusEffects.ButtStretched)) createStatusEffect(StatusEffects.ButtStretched,0,0,0,0);
				//Reset the timer on it to 0 when restretched.
				else changeStatusValue(StatusEffects.ButtStretched,1,0);
			}
			if (stretched) {
				trace("BUTT STRETCHED TO " + (ass.analLooseness) + ".");
			}
			return stretched;
		}

		public function cuntChangeNoDisplay(cArea : Number) : Boolean {
			if (vaginas.length == 0) return false;
			var stretched : Boolean = vaginas[0].stretch(cArea, vaginalCapacityBonus(), hasPerk(PerkLib.FerasBoonMilkingTwat));
			
			// Delay stretch recovery
			if (cArea >= .5 * vaginalCapacity()) {
				vaginas[0].resetRecoveryProgress();
			}
			
			return stretched;
		}
		
		public function get inHeat():Boolean {
			return hasStatusEffect(StatusEffects.Heat);
		}
		
		public function get inRut():Boolean {
			return hasStatusEffect(StatusEffects.Rut);
		}

		public function bonusFertility():Number
		{
			var counter:Number = 0;
			if (inHeat)
				counter += statusEffectv1(StatusEffects.Heat);
			if (hasPerk(PerkLib.FertilityPlus))
				counter += 15;
			if (hasPerk(PerkLib.FertilityMinus) && lib100 < 25)
				counter -= 15;
			if (hasPerk(PerkLib.MaraesGiftFertility))
				counter += 50;
			if (hasPerk(PerkLib.FerasBoonBreedingBitch))
				counter += 30;
			if (hasPerk(PerkLib.MagicalFertility))
				counter += 10 + (perkv1(PerkLib.MagicalFertility) * 5);
			counter += perkv2(PerkLib.ElvenBounty);
			counter += perkv1(PerkLib.PiercedFertite);
			if (jewelryEffectId == JewelryLib.MODIFIER_FERTILITY)
				counter += jewelryEffectMagnitude;
			counter += perkv1(PerkLib.AscensionFertility) * 5;
			return counter;
		}

		public function totalFertility():Number
		{
			return (bonusFertility() + fertility);
		}

		public function hasBeak():Boolean
		{
			return [FACE_BEAK, FACE_COCKATRICE].indexOf(faceType) != -1;
		}

		public function hasFeathers():Boolean
		{
			return skin.hasFeathers();
		}

		public function hasScales():Boolean
		{
			return [SKIN_TYPE_LIZARD_SCALES, SKIN_TYPE_DRAGON_SCALES, SKIN_TYPE_FISH_SCALES].indexOf(skinType) != -1;
		}

		public function hasReptileScales():Boolean
		{
			return [SKIN_TYPE_LIZARD_SCALES, SKIN_TYPE_DRAGON_SCALES].indexOf(skinType) != -1;
		}

		public function hasDragonScales():Boolean
		{
			return skinType == SKIN_TYPE_DRAGON_SCALES;
		}

		public function hasLizardScales():Boolean
		{
			return skinType == SKIN_TYPE_LIZARD_SCALES;
		}

		public function hasNonLizardScales():Boolean
		{
			return hasScales() && !hasLizardScales();
		}

		public function hasFur():Boolean
		{
			return skin.hasFur();
		}

		public function hasWool():Boolean
		{
			return skin.hasWool();
		}

		public function isFurry():Boolean
		{
			return skin.isFurry();
		}

		public function isFluffy():Boolean
		{
			return skin.isFluffy();
		}

		public function isFurryOrScaley():Boolean
		{
			return isFurry() || hasScales();
		}

		public function hasGooSkin():Boolean
		{
			return skinType == SKIN_TYPE_GOO;
		}

		public function hasPlainSkin():Boolean
		{
			return skinType == SKIN_TYPE_PLAIN;
		}

		public function get hairOrFurColors():String
		{
			if (!isFluffy())
				return hairColor;

			if (!underBody.skin.isFluffy() || ["no", furColor].indexOf(underBody.skin.furColor) != -1)
				return furColor;

			// Uses formatStringArray in case we add more skin layers
			// If more layers are added, we'd probably need some remove duplicates function
			return formatStringArray([
				furColor,
				underBody.skin.furColor,
			]);
		}

		public function isBiped():Boolean
		{
			return legCount == 2;
		}

		public function isNaga():Boolean
		{
			if (lowerBody == LOWER_BODY_TYPE_NAGA)
				return true;
			return false;
		}

		public function isTaur():Boolean
		{
			if (legCount > 2 && !isDrider()) // driders have genitals on their human part, inlike usual taurs... this is actually bad way to check, but too many places to fix just now
				return true;
			return false;
		}

		public function isDrider():Boolean
		{
			return (lowerBody == LOWER_BODY_TYPE_DRIDER_LOWER_BODY);
		}

		public function hasSpiderEyes():Boolean
		{
			if (eyeType == EYES_SPIDER && eyeCount == 4)
				return true;
			return false;
		}

		public function isGoo():Boolean
		{
			if (lowerBody == LOWER_BODY_TYPE_GOO)
				return true;
			return false;
		}

		public function legs():String
		{
			var select:Number = 0;
			//lowerBody:
			//4 legs - centaur!
			if (isDrider())
				return num2Text(legCount)+" spider legs";
			if (isTaur())
				return num2Text(legCount)+" legs";
			//0 - normal
			if (lowerBody == 0)
				return "legs";
			//1 - hooves
			if (lowerBody == 1)
				return "legs";
			//2 - paws
			if (lowerBody == 2)
				return "legs";
			//3 - snakelike body
			if (lowerBody == 3)
				return "snake-like coils";
			//8 - goo shit
			if (lowerBody == 8)
				return "mounds of goo";
			//PONY
			if (lowerBody == 11)
				return "cute pony-legs";
			//Bunnah!
			if (lowerBody == 12) {
				select = Math.floor(Math.random() * (5));
				if (select == 0)
					return "fuzzy, bunny legs";
				else if (select == 1)
					return "fur-covered legs";
				else if (select == 2)
					return "furry legs";
				else
					return "legs";
			}
			if (lowerBody == 13) {
				select = Math.floor(Math.random() * (5));
				if (select == 0)
					return "bird-like legs";
				else if (select == 1)
					return "feathered legs";
				else
					return "legs";
			}
			if (lowerBody == 17) {
				select = Math.floor(Math.random() * (4));
				if (select == 0)
					return "fox-like legs";
				else if (select == 1)
					return "legs";
				else if (select == 2)
					return "legs";
				else
					return "vulpine legs";
			}
			if (lowerBody == 19) {
				select = Math.floor(Math.random() * (4));
				if (select == 0)
					return "raccoon-like legs";
				else
					return "legs";
			}
			if (lowerBody == 21) {
				select = Math.floor(Math.random() * (4));
				if (select == 0)
					return "pig-like legs";
				else if (select == 1)
					return "legs";
				else if (select == 2)
					return "legs";
				else
					return "swine legs";
			}
			return "legs";
		}

		public function skinDescript(...args):String { return skin.description.apply(null, args); }

		public function skinFurScales():String { return skin.skinFurScales(); }

		// <mod name="Predator arms" author="Stadler76">
		public function claws():String
		{
			var toneText:String = clawTone == "" ? " " : (", " + clawTone + " ");

			switch (clawType) {
				case CLAW_TYPE_NORMAL: return "fingernails";
				case CLAW_TYPE_LIZARD: return "short curved" + toneText + "claws";
				case CLAW_TYPE_DRAGON: return "powerful, thick curved" + toneText + "claws";
				case CLAW_TYPE_IMP:    return "long" + toneText + "claws";
				// Since mander and cockatrice arms are hardcoded and the others are NYI, we're done here for now
			}
			return "fingernails";
		}
		// </mod>

		public function leg():String
		{
			var select:Number = 0;
			//lowerBody:
			//0 - normal
			if (lowerBody == 0)
				return "leg";
			//1 - hooves
			if (lowerBody == 1)
				return "leg";
			//2 - paws
			if (lowerBody == 2)
				return "leg";
			//3 - snakelike body
			if (lowerBody == 3)
				return "snake-tail";
			//4 - centaur!
			if (lowerBody == 4)
				return "equine leg";
			//8 - goo shit
			if (lowerBody == 8)
				return "mound of goo";
			//PONY
			if (lowerBody == 11)
				return "cartoonish pony-leg";
			//BUNNAH
			if (lowerBody == 12) {
				select = Math.random() * (5);
				if (select == 0)
					return "fuzzy, bunny leg";
				else if (select == 1)
					return "fur-covered leg";
				else if (select == 2)
					return "furry leg";
				else
					return "leg";
			}
			if (lowerBody == 13) {
				select = Math.floor(Math.random() * (5));
				if (select == 0)
					return "bird-like leg";
				else if (select == 1)
					return "feathered leg";
				else
					return "leg";
			}
			if (lowerBody == 17) {
				select = Math.floor(Math.random() * (4));
				if (select == 0)
					return "fox-like leg";
				else if (select == 1)
					return "leg";
				else if (select == 2)
					return "leg";
				else
					return "vulpine leg";
			}
			if (lowerBody == 19) {
				select = Math.floor(Math.random() * (4));
				if (select == 0)
					return "raccoon-like leg";
				else
					return "leg";
			}
			return "leg";
		}

		public function feet():String
		{
			var select:Number = 0;
			//lowerBody:
			//0 - normal
			if (lowerBody == 0)
				return "feet";
			//1 - hooves
			if (lowerBody == 1)
				return "hooves";
			//2 - paws
			if (lowerBody == 2)
				return "paws";
			//3 - snakelike body
			if (lowerBody == 3)
				return "coils";
			//4 - centaur!
			if (lowerBody == 4)
				return "hooves";
			//5 - demonic heels
			if (lowerBody == 5)
				return "demonic high-heels";
			//6 - demonic claws
			if (lowerBody == 6)
				return "demonic foot-claws";
			//8 - goo shit
			if (lowerBody == 8)
				return "slimey cillia";
			if (lowerBody == 11)
				return "flat pony-feet";
			//BUNNAH
			if (lowerBody == 12) {
				select = rand(5);
				if (select == 0)
					return "large bunny feet";
				else if (select == 1)
					return "rabbit feet";
				else if (select == 2)
					return "large feet";
				else
					return "feet";
			}
			if (lowerBody == 13) {
				select = Math.floor(Math.random() * (5));
				if (select == 0)
					return "taloned feet";
				else
					return "feet";
			}
			if (lowerBody == 14)
				return "foot-paws";
			if (lowerBody == 17) {
				select = rand(4);
				if (select == 0)
					return "paws";
				else if (select == 1)
					return "soft, padded paws";
				else if (select == 2)
					return "fox-like feet";
				else
					return "paws";
			}
			if (lowerBody == 19) {
				select = Math.floor(Math.random() * (3));
				if (select == 0)
					return "raccoon-like feet";
				else if (select == 1)
					return "long-toed paws";
				else if (select == 2)
					return "feet";
				else
					return "paws";
			}
			return "feet";
		}

		public function foot():String
		{
			var select:Number = 0;
			//lowerBody:
			//0 - normal
			if (lowerBody == 0)
				return "foot";
			//1 - hooves
			if (lowerBody == 1)
				return "hoof";
			//2 - paws
			if (lowerBody == 2)
				return "paw";
			//3 - snakelike body
			if (lowerBody == 3)
				return "coiled tail";
			//4 - centaur!
			if (lowerBody == 4)
				return "hoof";
			//8 - goo shit
			if (lowerBody == 8)
				return "slimey undercarriage";
			//PONY
			if (lowerBody == 11)
				return "flat pony-foot";
			//BUNNAH
			if (lowerBody == 12) {
				select = Math.random() * (5);
				if (select == 0)
					return "large bunny foot";
				else if (select == 1)
					return "rabbit foot";
				else if (select == 2)
					return "large foot";
				else
					return "foot";
			}
			if (lowerBody == 13) {
				select = Math.floor(Math.random() * (5));
				if (select == 0)
					return "taloned foot";
				else
					return "foot";
			}
			if (lowerBody == 17) {
				select = Math.floor(Math.random() * (4));
				if (select == 0)
					return "paw";
				else if (select == 1)
					return "soft, padded paw";
				else if (select == 2)
					return "fox-like foot";
				else
					return "paw";
			}
			if (lowerBody == 14)
				return "foot-paw";
			if (lowerBody == 19) {
				select = Math.floor(Math.random() * (3));
				if (select == 0)
					return "raccoon-like foot";
				else if (select == 1)
					return "long-toed paw";
				else if (select == 2)
					return "foot";
				else
					return "paw";
			}
			return "foot";
		}

		public function canOvipositSpider():Boolean
		{
			if (eggs() >= 10 && hasPerk(PerkLib.SpiderOvipositor) && isDrider() && tailType == TAIL_TYPE_SPIDER_ADBOMEN)
				return true;
			return false;
		}

		public function canOvipositBee():Boolean
		{
			if (eggs() >= 10 && hasPerk(PerkLib.BeeOvipositor) && tailType == TAIL_TYPE_BEE_ABDOMEN)
				return true;
			return false;
		}

		public function canOviposit():Boolean
		{
			if (canOvipositSpider() || canOvipositBee())
				return true;
			return false;
		}

		public function eggs():int
		{
			if (!hasPerk(PerkLib.SpiderOvipositor) && !hasPerk(PerkLib.BeeOvipositor))
				return -1;
			else if (hasPerk(PerkLib.SpiderOvipositor))
				return perkv1(PerkLib.SpiderOvipositor);
			else
				return perkv1(PerkLib.BeeOvipositor);
		}

		public function addEggs(arg:int = 0):int
		{
			if (!hasPerk(PerkLib.SpiderOvipositor) && !hasPerk(PerkLib.BeeOvipositor))
				return -1;
			else {
				if (hasPerk(PerkLib.SpiderOvipositor)) {
					addPerkValue(PerkLib.SpiderOvipositor, 1, arg);
					if (eggs() > 50)
						setPerkValue(PerkLib.SpiderOvipositor, 1, 50);
					return perkv1(PerkLib.SpiderOvipositor);
				}
				else {
					addPerkValue(PerkLib.BeeOvipositor, 1, arg);
					if (eggs() > 50)
						setPerkValue(PerkLib.BeeOvipositor, 1, 50);
					return perkv1(PerkLib.BeeOvipositor);
				}
			}
		}

		public function dumpEggs():void
		{
			if (!hasPerk(PerkLib.SpiderOvipositor) && !hasPerk(PerkLib.BeeOvipositor))
				return;
			setEggs(0);
			//Sets fertile eggs = regular eggs (which are 0)
			fertilizeEggs();
		}

		public function setEggs(arg:int = 0):int
		{
			if (!hasPerk(PerkLib.SpiderOvipositor) && !hasPerk(PerkLib.BeeOvipositor))
				return -1;
			else {
				if (hasPerk(PerkLib.SpiderOvipositor)) {
					setPerkValue(PerkLib.SpiderOvipositor, 1, arg);
					if (eggs() > 50)
						setPerkValue(PerkLib.SpiderOvipositor, 1, 50);
					return perkv1(PerkLib.SpiderOvipositor);
				}
				else {
					setPerkValue(PerkLib.BeeOvipositor, 1, arg);
					if (eggs() > 50)
						setPerkValue(PerkLib.BeeOvipositor, 1, 50);
					return perkv1(PerkLib.BeeOvipositor);
				}
			}
		}

		public function fertilizedEggs():int
		{
			if (!hasPerk(PerkLib.SpiderOvipositor) && !hasPerk(PerkLib.BeeOvipositor))
				return -1;
			else if (hasPerk(PerkLib.SpiderOvipositor))
				return perkv2(PerkLib.SpiderOvipositor);
			else
				return perkv2(PerkLib.BeeOvipositor);
		}

		public function fertilizeEggs():int
		{
			if (!hasPerk(PerkLib.SpiderOvipositor) && !hasPerk(PerkLib.BeeOvipositor))
				return -1;
			else if (hasPerk(PerkLib.SpiderOvipositor))
				setPerkValue(PerkLib.SpiderOvipositor, 2, eggs());
			else
				setPerkValue(PerkLib.BeeOvipositor, 2, eggs());
			return fertilizedEggs();
		}

		public function breastCup(rowNum:Number):String
		{
			return Appearance.breastCup(breastRows[rowNum].breastRating);
		}

		public function bRows():Number
		{
			return breastRows.length;
		}

		public function totalBreasts():Number
		{
			var counter:Number = breastRows.length;
			var total:Number = 0;
			while (counter > 0) {
				counter--;
				total += breastRows[counter].breasts;
			}
			return total;
		}

		public function totalNipples():Number
		{
			var counter:Number = breastRows.length;
			var total:Number = 0;
			while (counter > 0) {
				counter--;
				total += breastRows[counter].nipplesPerBreast * breastRows[counter].breasts;
			}
			return total;
		}

		public function smallestTitSize():Number
		{
			if (breastRows.length == 0)
				return -1;
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0) {
				counter--;
				if (breastRows[index].breastRating > breastRows[counter].breastRating)
					index = counter;
			}
			return breastRows[index].breastRating;
		}

		public function smallestTitRow():Number
		{
			if (breastRows.length == 0)
				return -1;
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0) {
				counter--;
				if (breastRows[index].breastRating > breastRows[counter].breastRating)
					index = counter;
			}
			return index;
		}

		public function biggestTitRow():Number
		{
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0) {
				counter--;
				if (breastRows[index].breastRating < breastRows[counter].breastRating)
					index = counter;
			}
			return index;
		}

		public function averageBreastSize():Number
		{
			var counter:Number = breastRows.length;
			var average:Number = 0;
			while (counter > 0) {
				counter--;
				average += breastRows[counter].breastRating;
			}
			if (breastRows.length == 0)
				return 0;
			return (average / breastRows.length);
		}

		public function averageCockThickness():Number
		{
			var counter:Number = cocks.length;
			var average:Number = 0;
			while (counter > 0) {
				counter--;
				average += cocks[counter].cockThickness;
			}
			if (cocks.length == 0)
				return 0;
			return (average / cocks.length);
		}

		public function averageNippleLength():Number
		{
			var counter:Number = breastRows.length;
			var average:Number = 0;
			while (counter > 0) {
				counter--;
				average += (breastRows[counter].breastRating / 10 + .2);
			}
			return (average / breastRows.length);
		}

		public function averageVaginalLooseness():Number
		{
			var counter:Number = vaginas.length;
			var average:Number = 0;
			//If the player has no vaginas
			if (vaginas.length == 0)
				return 2;
			while (counter > 0) {
				counter--;
				average += vaginas[counter].vaginalLooseness;
			}
			return (average / vaginas.length);
		}

		public function averageVaginalWetness():Number
		{
			//If the player has no vaginas
			if (vaginas.length == 0)
				return 2;
			var counter:Number = vaginas.length;
			var average:Number = 0;
			while (counter > 0) {
				counter--;
				average += vaginas[counter].vaginalWetness;
			}
			return (average / vaginas.length);
		}

		public function averageCockLength():Number
		{
			var counter:Number = cocks.length;
			var average:Number = 0;
			while (counter > 0) {
				counter--;
				average += cocks[counter].cockLength;
			}
			if (cocks.length == 0)
				return 0;
			return (average / cocks.length);
		}

		public function canTitFuck():Boolean
		{
			if (breastRows.length == 0) return false;
			
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0) {
				counter--;
				if (breastRows[index].breasts < breastRows[counter].breasts && breastRows[counter].breastRating > 3)
					index = counter;
			}
			if (breastRows[index].breasts >= 2 && breastRows[index].breastRating > 3)
				return true;
			return false;
		}

		public function mostBreastsPerRow():Number
		{
			if (breastRows.length == 0) return 2;
			
			var counter:Number = breastRows.length;
			var index:Number = 0;
			while (counter > 0) {
				counter--;
				if (breastRows[index].breasts < breastRows[counter].breasts)
					index = counter;
			}
			return breastRows[index].breasts;
		}

		public function averageNipplesPerBreast():Number
		{
			var counter:Number = breastRows.length;
			var breasts:Number = 0;
			var nipples:Number = 0;
			while (counter > 0) {
				counter--;
				breasts += breastRows[counter].breasts;
				nipples += breastRows[counter].nipplesPerBreast * breastRows[counter].breasts;
			}
			if (breasts == 0)
				return 0;
			return Math.floor(nipples / breasts);
		}

		public function allBreastsDescript():String
		{
			return Appearance.allBreastsDescript(this);
		}

		//Simplified these cock descriptors and brought them into the creature class
		public function sMultiCockDesc():String {
			return (cocks.length > 1 ? "one of your " : "your ") + cockMultiLDescriptionShort();
		}
		
		public function SMultiCockDesc():String {
			return (cocks.length > 1 ? "One of your " : "Your ") + cockMultiLDescriptionShort();
		}
		
		public function oMultiCockDesc():String {
			return (cocks.length > 1 ? "each of your " : "your ") + cockMultiLDescriptionShort();
		}
		
		public function OMultiCockDesc():String {
			return (cocks.length > 1 ? "Each of your " : "Your ") + cockMultiLDescriptionShort();
		}
		
		private function cockMultiLDescriptionShort():String {
			if (cocks.length < 1) {
				CoC_Settings.error("<b>ERROR: NO WANGS DETECTED for cockMultiLightDesc()</b>");
				return "<b>ERROR: NO WANGS DETECTED for cockMultiLightDesc()</b>";
			}
			if (cocks.length == 1) { //For a songle cock return the default description
				return Appearance.cockDescript(this, 0);
			}
			switch (cocks[0].cockType) { //With multiple cocks only use the descriptions for specific cock types if all cocks are of a single type
				case CockTypesEnum.ANEMONE:
				case CockTypesEnum.WOLF:
				case CockTypesEnum.CAT:
				case CockTypesEnum.DEMON:
				case CockTypesEnum.DISPLACER:
				case CockTypesEnum.DRAGON:
				case CockTypesEnum.HORSE:
				case CockTypesEnum.KANGAROO:
				case CockTypesEnum.LIZARD:
				case CockTypesEnum.PIG:
				case CockTypesEnum.TENTACLE:
					if (countCocksOfType(cocks[0].cockType) == cocks.length) return Appearance.cockNoun(cocks[0].cockType) + "s";
					break;
				case CockTypesEnum.DOG:
				case CockTypesEnum.FOX:
					if (dogCocks() == cocks.length) return Appearance.cockNoun(CockTypesEnum.DOG) + "s";
				default:
			}
			return Appearance.cockNoun(CockTypesEnum.HUMAN) + "s";
		}
		
		public function hasSheath():Boolean {
			if (cocks.length == 0) return false;
			for (var x:int = 0; x < cocks.length; x++) {
				switch (cocks[x].cockType) {
					case CockTypesEnum.CAT:
					case CockTypesEnum.DISPLACER:
					case CockTypesEnum.DOG:
					case CockTypesEnum.WOLF:
					case CockTypesEnum.FOX:
					case CockTypesEnum.HORSE:
					case CockTypesEnum.KANGAROO:
					case CockTypesEnum.AVIAN:
					case CockTypesEnum.ECHIDNA:
						return true; //If there's even one cock of any of these types then return true
					default:
				}
			}
			return false;
		}
		
		public function sheathDescript():String {
			if (hasSheath()) return "sheath";
			return "base";
		}
		
		public function cockClit(number:int = 0):String {
			if (hasCock() && number >= 0 && number < cockTotal())
				return cockDescript(number);
			else
				return clitDescript();
		}
		
		public function vaginaDescript(idx:int = 0):String
		{
			return Appearance.vaginaDescript(this, 0);
		}

		public function allVaginaDescript():String {
			if (vaginas.length == 1)
				return vaginaDescript(rand(vaginas.length - 1));
			else
				return vaginaDescript(rand(vaginas.length - 1)) + "s";
		}
		
		public function nippleDescript(rowIdx:int):String
		{
			return Appearance.nippleDescription(this, rowIdx);
		}

		public function chestDesc():String
		{
			if (biggestTitSize() < 1) return "chest";
			return Appearance.biggestBreastSizeDescript(this);
//			return Appearance.chestDesc(this);
		}

		public function allChestDesc():String {
			if (biggestTitSize() < 1) return "chest";
			return allBreastsDescript();
		}
		
		public function biggestBreastSizeDescript():String {
			return Appearance.biggestBreastSizeDescript(this);
		}
		
		public function clitDescript():String {
			return Appearance.clitDescription(this);
		}

		public function cockHead(cockNum:int = 0):String {
			if (cockNum < 0 || cockNum > cocks.length - 1) {
				CoC_Settings.error("");
				return "ERROR";
			}
			switch (cocks[cockNum].cockType) {
				case CockTypesEnum.CAT:
					if (rand(2) == 0) return "point";
					return "narrow tip";
				case CockTypesEnum.DEMON:
					if (rand(2) == 0) return "tainted crown";
					return "nub-ringed tip";
				case CockTypesEnum.DISPLACER:
					switch (rand(5)) {
						case  0: return "star tip";
						case  1: return "blooming cock-head";
						case  2: return "open crown";
						case  3: return "alien tip";
						default: return "bizarre head";
					}
				case CockTypesEnum.DOG:
				case CockTypesEnum.WOLF:
				case CockTypesEnum.FOX:
					if (rand(2) == 0) return "pointed tip";
					return "narrow tip";
				case CockTypesEnum.HORSE:
					if (rand(2) == 0) return "flare";
					return "flat tip";
				case CockTypesEnum.KANGAROO:
					if (rand(2) == 0) return "tip";
					return "point";
				case CockTypesEnum.LIZARD:
					if (rand(2) == 0) return "crown";
					return "head";
				case CockTypesEnum.TENTACLE:
					if (rand(2) == 0) return "mushroom-like tip";
					return "wide plant-like crown";
				case CockTypesEnum.PIG:
					if (rand(2) == 0) return "corkscrew tip";
					return "corkscrew head";
				case CockTypesEnum.RHINO:
					if (rand(2) == 0) return "flared head";
					return "rhinoceros dickhead";
				case CockTypesEnum.ECHIDNA:
					if (rand(2) == 0) return "quad heads";
					return "echidna quad heads";
				default:
			}
			if (rand(2) == 0) return "crown";
			if (rand(2) == 0) return "head";
			return "cock-head";
		}

		//Short cock description. Describes length or girth. Supports multiple cocks.
		public function cockDescriptShort(i_cockIndex:int = 0):String
		{
			// catch calls where we're outside of combat, and eCockDescript could be called.
			if (cocks.length == 0)
				return "<B>ERROR. INVALID CREATURE SPECIFIED to cockDescriptShort</B>";

			var description:String = "";
			var descripted:Boolean = false;
			//Discuss length one in 3 times
			if (rand(3) == 0) {
				if (cocks[i_cockIndex].cockLength >= 30)
					description = "towering ";
				else if (cocks[i_cockIndex].cockLength >= 18)
					description = "enormous ";
				else if (cocks[i_cockIndex].cockLength >= 13)
					description = "massive ";
				else if (cocks[i_cockIndex].cockLength >= 10)
					description = "huge ";
				else if (cocks[i_cockIndex].cockLength >= 7)
					description = "long ";
				else if (cocks[i_cockIndex].cockLength >= 5)
					description = "average ";
				else
					description = "short ";
				descripted = true;
			}
			else if (rand(2) == 0) { //Discuss girth one in 2 times if not already talked about length.
				//narrow, thin, ample, broad, distended, voluminous
				if (cocks[i_cockIndex].cockThickness <= .75) description = "narrow ";
				if (cocks[i_cockIndex].cockThickness > 1 && cocks[i_cockIndex].cockThickness <= 1.4) description = "ample ";
				if (cocks[i_cockIndex].cockThickness > 1.4 && cocks[i_cockIndex].cockThickness <= 2) description = "broad ";
				if (cocks[i_cockIndex].cockThickness > 2 && cocks[i_cockIndex].cockThickness <= 3.5) description = "fat ";
				if (cocks[i_cockIndex].cockThickness > 3.5) description = "distended ";
				descripted = true;
			}
//Seems to work better without this comma:			if (descripted && cocks[i_cockIndex].cockType != CockTypesEnum.HUMAN) description += ", ";
			description += Appearance.cockNoun(cocks[i_cockIndex].cockType);

			return description;
		}
		
		public function assholeDescript():String
		{
			return Appearance.assholeDescript(this);
		}
		
		public function assholeOrPussy():String
		{
			return Appearance.assholeOrPussy(this);
		}

		public function multiCockDescriptLight():String
		{
			return Appearance.multiCockDescriptLight(this);
		}

		public function multiCockDescript():String
		{
			return Appearance.multiCockDescript(this);
		}

		public function ballDescript(forcedSize:Boolean = true):String
		{
			return Appearance.ballsDescription(forcedSize, false, this);
		}
		
		public function ballsDescript(forcedSize:Boolean = true):String
		{
			return ballsDescriptLight(forcedSize);
		}
		
		public function ballsDescriptLight(forcedSize:Boolean = true):String
		{
			return Appearance.ballsDescription(forcedSize, true, this);
		}
		
		public function simpleBallsDescript():String
		{
			return Appearance.ballsDescription(false, true, this);
		}
		
		public function sackDescript():String
		{
			return Appearance.sackDescript(this);
		}

		public function breastDescript(rowNum:int):String {
			//ERROR PREVENTION
			if (breastRows.length - 1 < rowNum) {
				CoC_Settings.error("");
				return "<b>ERROR, breastDescript() working with invalid breastRow</b>";
			}
			if (breastRows.length == 0) {
				CoC_Settings.error("");
				return "<b>ERROR, breastDescript() called when no breasts are present.</b>";
			}
			return BreastStore.breastDescript(breastRows[rowNum].breastRating, breastRows[rowNum].lactationMultiplier);
		}

		private function breastSize(val:Number):String
		{
			return Appearance.breastSize(val);
		}
		
		/**
		 * Echidna 1 ft long (i'd consider it barely qualifying), demonic 2 ft long, draconic 4 ft long
		 */
		public function hasLongTongue():Boolean {
			return tongueType == TONGUE_DEMONIC || tongueType == TONGUE_DRACONIC || tongueType == TONGUE_ECHIDNA;
		}
		
		public function damageToughnessModifier(displayMode:Boolean = false):Number {
			//Return 0 if Grimdark
			if (flags[kFLAGS.GRIMDARK_MODE] > 0) return 0;
			//Calculate
			var temp:Number = 0;
			if (tou < 25) temp = (tou * 0.4);
			else if (tou < 50) temp = 10 + ((tou-25) * 0.3);
			else if (tou < 75) temp = 17.5 + ((tou-50) * 0.2);
			else if (tou < 100) temp = 22.5 + ((tou-75) * 0.1);
			else temp = 25;
			//displayMode is for stats screen.
			if (displayMode) return temp;
			else return rand(temp);
		}
		
		public function damagePercent(displayMode:Boolean = false, applyModifiers:Boolean = false):Number {
			var mult:Number = 100;
			var armorMod:Number = armorDef;
			//--BASE--
			//Toughness modifier.
			if (!displayMode) {
				mult -= damageToughnessModifier();
				if (mult < 75) mult = 75;
			}
			//Modify armor rating based on weapons.
			if (applyModifiers) {
				if (game.player.weapon == game.weapons.JRAPIER || game.player.weapon == game.weapons.SPEAR || game.player.weaponName.indexOf("staff") != -1 && game.player.hasPerk(PerkLib.StaffChanneling)) armorMod = 0;
				if (game.player.weapon == game.weapons.KATANA) armorMod -= 5;
				if (game.player.hasPerk(PerkLib.LungingAttacks)) armorMod /= 2;
				if (armorMod < 0) armorMod = 0;
			}
			mult -= armorMod;
			
			//--PERKS--
			//Take damage you masochist!
			if (hasPerk(PerkLib.Masochist) && lib >= 60) {
				mult *= 0.8;
				if (short == game.player.short && !displayMode) dynStats("lus", 2);
			}
			if (hasPerk(PerkLib.ImmovableObject) && tou >= 75) {
				mult *= 0.9;
			}
			
			//--STATUS AFFECTS--
			//Black cat beer = 25% reduction!
			if (statusEffectv1(StatusEffects.BlackCatBeer) > 0)
				mult *= 0.75;
			// Uma's Massage bonuses
			var effect:StatusEffectClass = statusEffectByType(StatusEffects.UmasMassage);
			if (effect != null && effect.value1 == UmasShop.MASSAGE_RELAXATION) {
				mult *= effect.value2;
			}
			//Round things off.
			mult = Math.round(mult);
			//Caps damage reduction at 80%.
			if (mult < 20) mult = 20;
			return mult;
		}
		
		public function lustPercent():Number {
			var lust:Number = 100;
			var minLustCap:Number = 25;
			if (flags[kFLAGS.NEW_GAME_PLUS_LEVEL] > 0 && flags[kFLAGS.NEW_GAME_PLUS_LEVEL] < 3) minLustCap -= flags[kFLAGS.NEW_GAME_PLUS_LEVEL] * 5;
			else if (flags[kFLAGS.NEW_GAME_PLUS_LEVEL] >= 3) minLustCap -= 15;
			//2.5% lust resistance per level - max 75.
			if (level < 100) {
				if (level <= 11) lust -= (level - 1) * 3;
				else if (level > 11 && level <= 21) lust -= (30 + (level - 11) * 2);
				else if (level > 21 && level <= 31) lust -= (50 + (level - 21) * 1);
				else if (level > 31) lust -= (60 + (level - 31) * 0.2);
			}
			else lust = 25;
			
			//++++++++++++++++++++++++++++++++++++++++++++++++++
			//ADDITIVE REDUCTIONS
			//THESE ARE FLAT BONUSES WITH LITTLE TO NO DOWNSIDE
			//TOTAL IS LIMITED TO 75%!
			//++++++++++++++++++++++++++++++++++++++++++++++++++
			//Corrupted Libido reduces lust gain by 10%!
			if (hasPerk(PerkLib.CorruptedLibido)) lust -= 10;
			//Acclimation reduces by 15%
			if (hasPerk(PerkLib.Acclimation)) lust -= 15;
			//Purity blessing reduces lust gain
			if (hasPerk(PerkLib.PurityBlessing)) lust -= 5;
			//Resistance = 10%
			if (hasPerk(PerkLib.Resistance)) lust -= 10;
			if (hasPerk(PerkLib.ChiReflowLust)) lust -= UmasShop.NEEDLEWORK_LUST_LUST_RESIST;
			
			if (lust < minLustCap) lust = minLustCap;
			if (statusEffectv1(StatusEffects.BlackCatBeer) > 0) {
				if (lust >= 80) lust = 100;
				else lust += 20;
			}
			lust += Math.round(perkv1(PerkLib.PentUp)/2);
			//++++++++++++++++++++++++++++++++++++++++++++++++++
			//MULTIPLICATIVE REDUCTIONS
			//THESE PERKS ALSO RAISE MINIMUM LUST OR HAVE OTHER
			//DRAWBACKS TO JUSTIFY IT.
			//++++++++++++++++++++++++++++++++++++++++++++++++++
			//Bimbo body slows lust gains!
			if ((hasStatusEffect(StatusEffects.BimboChampagne) || hasPerk(PerkLib.BimboBody)) && lust > 0) lust *= .75;
			if (hasPerk(PerkLib.BroBody) && lust > 0) lust *= .75;
			if (hasPerk(PerkLib.FutaForm) && lust > 0) lust *= .75;
			//Omnibus' Gift reduces lust gain by 15%
			if (hasPerk(PerkLib.OmnibusGift)) lust *= .85;
			//Luststick reduces lust gain by 10% to match increased min lust
			if (hasPerk(PerkLib.LuststickAdapted)) lust *= 0.9;
			if (hasStatusEffect(StatusEffects.Berzerking)) lust *= .6;
			if (hasPerk(PerkLib.PureAndLoving)) lust *= 0.95;
			//Berserking removes half!
			if (hasStatusEffect(StatusEffects.Lustzerking)) lust += ((100 - lust) / 2);
			//Items
			if (jewelryEffectId == JewelryLib.PURITY) lust *= 1 - (jewelryEffectMagnitude / 100);
			if (armorName == game.armors.DBARMOR.name) lust *= 0.9;
			if (weaponName == game.weapons.HNTCANE.name) lust *= 0.75;
			// Lust mods from Uma's content -- Given the short duration and the gem cost, I think them being multiplicative is justified.
			// Changing them to an additive bonus should be pretty simple (check the static values in UmasShop.as)
			var effect:StatusEffectClass = statusEffectByType(StatusEffects.UmasMassage);
			if (effect != null) {
				if (effect.value1 == UmasShop.MASSAGE_RELIEF || effect.value1 == UmasShop.MASSAGE_LUST) {
					lust *= effect.value2;
				}
			}
			
			lust = Math.round(lust);
			return lust;
		}
		
		/**
		* Look into perks and special effects and @return summery extra chance to avoid attack granted by them.
		* 
		* Is overriden in Player to work with Unhindered.
		*/
		public function getEvasionChance():Number
		{
			var chance:Number = 0;
			if (hasPerk(PerkLib.Evade)) chance += 10;
			if (hasPerk(PerkLib.Flexibility)) chance += 6;
			if (hasPerk(PerkLib.Misdirection) && armorName == "red, high-society bodysuit") chance += 10;
			return chance;
		}
	   
		public const EVASION_SPEED:String = "Speed"; // enum maybe?
		public const EVASION_EVADE:String = "Evade";
		public const EVASION_FLEXIBILITY:String = "Flexibility";
		public const EVASION_MISDIRECTION:String = "Misdirection";
		public const EVASION_UNHINDERED:String = "Unhindered";
		protected var evasionRoll:Number = 0;
	   
		/**
	    * Try to avoid and @return a reason if successfull or null if failed to evade.
		* 
		* If attacker is null then you can specify attack speed for enviromental and non-combat cases. If no speed and attacker specified and then only perks would be accounted.
		* 
		* This does NOT account blind!
		* 
		* Is overriden in Player to work with Unhindered.
	    */
		public function getEvasionReason(useMonster:Boolean = true, attackSpeed:int = int.MIN_VALUE):String
		{
			// speed
			if (useMonster && game.monster != null && attackSpeed == int.MIN_VALUE) attackSpeed = game.monster.spe;
			if (attackSpeed != int.MIN_VALUE && spe - attackSpeed > 0 && int(Math.random() * (((spe - attackSpeed) / 4) + 80)) > 80) return "Speed";
			//note, Player.speedDodge is still used, since this function can't return how close it was

			evasionRoll = rand(100);

			// perks
			if (hasPerk(PerkLib.Evade) && ((evasionRoll = evasionRoll - 10) < 0)) return "Evade";
			if (hasPerk(PerkLib.Flexibility) && ((evasionRoll = evasionRoll - 6) < 0)) return "Flexibility";
			if (hasPerk(PerkLib.Misdirection) && armorName == "red, high-society bodysuit" && ((evasionRoll = evasionRoll - 10) < 0)) return "Misdirection";
			return null;
		}
	   
		public function getEvasionRoll(useMonster:Boolean = true, attackSpeed:int = int.MIN_VALUE):Boolean
		{
			return getEvasionReason(useMonster, attackSpeed) != null;
		}
		
		public function maxFatigue():Number
		{
			var max:Number = 100;
			if (findPerk(PerkLib.ImprovedEndurance) >= 0) max += 20;
			if (findPerk(PerkLib.AscensionEndurance) >= 0) max += perkv1(PerkLib.AscensionEndurance) * 5;
			if (max > 999) max = 999;
			return max;
		}
		public function getMaxStats(stats:String):int {
			return 100;
		}

		public function maxHP():Number
		{
			var max:Number = 0;
			max += int(tou * 2 + 50);
			if (findPerk(PerkLib.Tank) >= 0) max += 50;
			if (findPerk(PerkLib.Tank2) >= 0) max += Math.round(tou);
			if (findPerk(PerkLib.ChiReflowDefense) >= 0) max += UmasShop.NEEDLEWORK_DEFENSE_EXTRA_HP;
			if (flags[kFLAGS.GRIMDARK_MODE] >= 1)
				max += level * 5;
			else
				max += level * 15;
			if (jewelryEffectId == JewelryLib.MODIFIER_HP) max += jewelryEffectMagnitude;
			max *= 1 + (countCockSocks("green") * 0.02);
			max = Math.round(max);
			if (max > 9999) max = 9999;
			return max;
		}

		public function minLib():Number {
			return 1;
		}
		public function minSens():Number {
			return 10;
		}
		public function minLust():Number {
			return 100;
		}

		public function maxLust():Number
		{
			var max:Number = 100;
			if (this == game.player && game.player.demonScore() >= 4) max += 20;
			if (findPerk(PerkLib.ImprovedSelfControl) >= 0) max += 20;
			if (findPerk(PerkLib.BroBody) >= 0 || findPerk(PerkLib.BimboBody) >= 0 || findPerk(PerkLib.FutaForm) >= 0) max += 20;
			if (findPerk(PerkLib.OmnibusGift) >= 0) max += 15;
			if (findPerk(PerkLib.AscensionDesires) >= 0) max += perkv1(PerkLib.AscensionDesires) * 5;
			if (max > 999) max = 999;
			return max;
		}
		public function takeDamage(damage:Number, display:Boolean = false):Number {
			HP = boundFloat(0,HP-Math.round(damage),HP);
			return (damage > 0 && damage < 1) ? 1 : damage;
		}
		public function takeLustDamage(lustDmg:Number, display:Boolean = true, applyRes:Boolean = true):Number{
			if (applyRes) lustDmg *= lustPercent()/100;
			lust = boundFloat(minLust(),lust+Math.round(lustDmg),maxLust());
			return (lustDmg > 0 && lustDmg < 1) ? 1 : lustDmg;
		}
		/**
		 *Get the remaining fatigue of the Creature.
		 *@return maximum amount of fatigue that still can be used
		 */
		public function fatigueLeft():Number
		{
			return maxFatigue() - fatigue;
		}

		public function spellMod():Number {
			var mod:Number = 1;
			if (hasPerk(PerkLib.Archmage) && inte >= 75) mod += .5;
			if (hasPerk(PerkLib.Channeling) && inte >= 60) mod += .5;
			if (hasPerk(PerkLib.Mage) && inte >= 50) mod += .5;
			if (hasPerk(PerkLib.Spellpower) && inte >= 50) mod += .5;
			if (hasPerk(PerkLib.WizardsFocus)) {
				mod += perkv1(PerkLib.WizardsFocus);
			}
			if (hasPerk(PerkLib.ChiReflowMagic)) mod += UmasShop.NEEDLEWORK_MAGIC_SPELL_MULTI;
			if (jewelryEffectId == JewelryLib.MODIFIER_SPELL_POWER) mod += (jewelryEffectMagnitude / 100);
			if (countCockSocks("blue") > 0) mod += (countCockSocks("blue") * .05);
			if (hasPerk(PerkLib.AscensionMysticality)) mod *= 1 + (perkv1(PerkLib.AscensionMysticality) * 0.05);
			return mod;
		}
		// returns OLD OP VAL
		public static function applyOperator(old:Number, op:String, val:Number):Number {
			switch(op) {
				case "=":
					return val;
				case "+":
					return old + val;
				case "-":
					return old - val;
				case "*":
					return old * val;
				case "/":
					return old / val;
				default:
					trace("applyOperator(" + old + ",'" + op + "'," + val + ") unknown op");
					return old;
			}
		}
		/**
		 * Generate increments for stats
		 *
		 * @return Object of (newStat-oldStat) with keys str, tou, spe, inte, lib, sens, lust, cor, scale
		 * */
		public static function parseDynStatsArgs(c:Creature, args:Array):Object {
			// Check num of args, we should have a multiple of 2
			if ((args.length % 2) != 0)
			{
				trace("dynStats aborted. Keys->Arguments could not be matched");
				return {str:0,tou:0,spe:0,inte:0,lib:0,sens:0,lust:0,cor:0,scale:true};
			}

			var argNamesFull:Array 	= 	["strength", "toughness", "speed", "intellect", "libido", "sensitivity", "lust", "corruption", "scale"]; // In case somebody uses full arg names etc
			var argNamesShort:Array = 	["str", 	"tou", 	"spe", 	"int", 	"lib", 	"sen", 	"lus", 	"cor", 	"res", 	"sca"]; // Arg names
			var argVals:Array = 		[0, 		0,	 	0, 		0, 		0, 		0, 		0, 		0, 		true, ]; // Default arg values
			var argOps:Array = 			["+",	"+",    "+",    "+",    "+",    "+",    "+",    "+",    "="];   // Default operators

			for (var i:int = 0; i < args.length; i += 2)
			{
				if (typeof(args[i]) == "string")
				{
					// Make sure the next arg has the POSSIBILITY of being correct
					if ((typeof(args[i + 1]) != "number") && (typeof(args[i + 1]) != "boolean"))
					{
						trace("dynStats aborted. Next argument after argName is invalid! arg is type " + typeof(args[i + 1]));
						continue;
					}

					var argIndex:int = -1;

					// Figure out which array to search
					var argsi:String = (args[i] as String);
					if (argsi == "lust") argsi = "lus";
					if (argsi == "sens") argsi = "sen";
					if (argsi == "inte") argsi = "int";
					if (argsi == "resisted") argsi = "sca";
					if (argsi == "res") argsi = "sca";
					if (argsi.length <= 4) // Short
					{
						argIndex = argNamesShort.indexOf(argsi.slice(0, 3));
						if (argsi.length == 4 && argIndex != -1) argOps[argIndex] = argsi.charAt(3);
					}
					else // Full
					{
						if ("+-*/=".indexOf(argsi.charAt(argsi.length - 1)) != -1) {
							argIndex = argNamesFull.indexOf(argsi.slice(0, argsi.length - 1));
							if (argIndex != -1) argOps[argIndex] = argsi.charAt(argsi.length - 1);
						} else {
							argIndex = argNamesFull.indexOf(argsi);
						}
					}

					if (argIndex == -1) // Shit fucked up, welp
					{
						trace("Couldn't find the arg name " + argsi + " in the index arrays. Welp!");
						continue;
					}
					else // Stuff the value into our "values" array
					{
						argVals[argIndex] = args[i + 1];
					}
				}
				else
				{
					trace("dynStats aborted. Expected a key and got SHIT");
					return {str:0,tou:0,spe:0,inte:0,lib:0,sen:0,lus:0,cor:0,scale:true};
				}
			}
			// Got this far, we have values to statsify
			var newStr:Number = applyOperator(c.str, argOps[0], argVals[0]);
			var newTou:Number = applyOperator(c.tou, argOps[1], argVals[1]);
			var newSpe:Number = applyOperator(c.spe, argOps[2], argVals[2]);
			var newInte:Number = applyOperator(c.inte, argOps[3], argVals[3]);
			var newLib:Number = applyOperator(c.lib, argOps[4], argVals[4]);
			var newSens:Number = applyOperator(c.sens, argOps[5], argVals[5]);
			var newLust:Number = applyOperator(c.lust, argOps[6], argVals[6]);
			var newCor:Number = applyOperator(c.cor, argOps[7], argVals[7]);
			// Because lots of checks and mods are made in the stats(), calculate deltas and pass them. However, this means that the '=' operator could be resisted
			// In future (as I believe) stats() should be replaced with dynStats(), and checks and mods should be made here
			return {
				str     : newStr - c.str,
				tou     : newTou - c.tou,
				spe     : newSpe - c.spe,
				inte    : newInte - c.inte,
				lib     : newLib - c.lib,
				sens    : newSens - c.sens,
				lust    : newLust - c.lust,
				cor     : newCor - c.cor,
				scale   : argVals[8]
			};
		}
	}
}
