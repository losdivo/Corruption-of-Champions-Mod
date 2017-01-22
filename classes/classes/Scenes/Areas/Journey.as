/**
 * Created by losdivo on 20.01.17.
 */
package classes.Scenes.Areas
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;

	import coc.view.MainView;

	
	use namespace kGAMECLASS;

	public class Journey extends BaseContent
	{
		
		public static const JOURNEY_CAMP:int 					=	0; 
		public static const JOURNEY_FOREST:int 					=  	1;	
		public static const JOURNEY_LAKE:int 					=  	2;
		public static const JOURNEY_DESERT:int 					=  	3;
		public static const JOURNEY_MOUNTAIN:int 				=  	4;
		public static const JOURNEY_SWAMP:int 					=  	5;
		public static const JOURNEY_PLAINS:int 					=  	6;
		public static const JOURNEY_DEEPWOODS:int 				=  	7;
		public static const JOURNEY_HIGH_MOUNTAINS:int 			=  	8;
		public static const JOURNEY_BOG:int 					=  	9;
		public static const JOURNEY_GLACIAL_RIFT:int 			=  	10;
		public static const JOURNEY_VOLCANO:int 				=  	11;
		public static const JOURNEY_MIRKWOODS:int 				=  	12;
		public static const JOURNEY_STEPPE:int 					=  	13;
		public static const JOURNEY_TUNDRA:int 					=  	14;
		public static const JOURNEY_DARKWOODS:int 				=  	15;
		public static const JOURNEY_BADLANDS:int 				=  	16;
		public static const JOURNEY_PRISON:int 					=  	17;
		public static const JOURNEY_INGNAM:int 					=  	18;
		
		
		public function get inJourney():Boolean { return flags[kFLAGS.JOURNEY_MODE]  == 1 || flags[kFLAGS.JOURNEY_MODE]  == 2; }
		
		public function Journey() {
		}
		public function locationName():String {
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_FOREST)  			return "forest";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_LAKE)    			return "lake shore";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_DESERT)   		return "desert";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_MOUNTAIN) 		return "mountains";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_SWAMP)			return "swamp";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_PLAINS)			return "plains";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_DEEPWOODS) 		return "deep woods";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_HIGH_MOUNTAINS) 	return "high mountains";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_BOG)				return "bog";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_GLACIAL_RIFT)		return "glacial rift";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_VOLCANO)			return "volcanic crag";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_MIRKWOODS)		return "mirkwoods";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_STEPPE)			return "steppe";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_TUNDRA)			return "tundra";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_DARKWOODS)		return "darkwoods";
			if (flags[kFLAGS.JOURNEY_LOCATION] == JOURNEY_BADLANDS)			return "badlands";
			return "wilderness";
		}
		public function exploreJourney():void
		{
			clearOutput();
			//outputText("You are not prepared to take a spiritual journey in the lands of Mareth yet.\n");
			
			outputText("You start your journey to find your home.\n");
			
			flags[kFLAGS.JOURNEY_MODE] = 1;
			flags[kFLAGS.JOURNEY_LOCATION] = 1;
			
			
			
			doNext(camp.returnToCampUseOneHour);
			
		}
		public function menuJourney() : void  {
			
			if (player.findStatusEffect(StatusEffects.SlimeCravingOutput) >= 0) player.removeStatusEffect(StatusEffects.SlimeCravingOutput);
			//Reset luststick display status (see event parser)
			flags[kFLAGS.PC_CURRENTLY_LUSTSTICK_AFFECTED] = 0;
			//Display Proper Buttons
			mainView.showMenuButton( MainView.MENU_APPEARANCE );
			mainView.showMenuButton( MainView.MENU_PERKS );
			mainView.showMenuButton( MainView.MENU_STATS );
			mainView.showMenuButton( MainView.MENU_DATA );
			showStats();
			//Change settings of new game buttons to go to main menu
			mainView.setMenuButton( MainView.MENU_NEW_MAIN, "Main Menu", kGAMECLASS.mainMenu.mainMenu );
			mainView.newGameButton.toolTipText = "Return to main menu.";
			mainView.newGameButton.toolTipHeader = "Main Menu";
			//clear up/down arrows
			hideUpDown();
			//Level junk
			
			if (camp.setLevelButton()) return;
			
			//Build main menu
			var forwardEvent:Function = journeyForward; 
			var returnEvent:Function = journeyForward; // DEBUG
			clearOutput();
			camp.updateAchievements();
			
			outputText(images.showImage("camping"), false);
			//Isabella upgrades camp level!

			outputText("Your campsite in the " + locationName() + " is fairly simple.  Your tent and bedroll are set in front of the rocks.  You have a small fire pit as well.  ", false);

			//Hunger check!
			if (flags[kFLAGS.HUNGER_ENABLED] > 0 && player.hunger < 25) {
				
				outputText("<b>You have to eat something; your stomach is growling " + (player.hunger < 1 ? "painfully": "loudly") + ". </b>", false);
				if (player.hunger < 10) {
					outputText("<b>You are getting thinner and you're losing muscles. </b>");
				}
				if (player.hunger <= 0) {
					outputText("<b>You are getting weaker due to starvation. </b>");
				}
				outputText("\n\n");
			}
			
			//The uber horny
			if (player.lust >= player.maxLust()) {
				if (player.findStatusEffect(StatusEffects.Dysfunction) >= 0) {
					outputText("<b>You are debilitatingly aroused, but your sexual organs are so numbed the only way to get off would be to find something tight to fuck or get fucked...</b>\n\n", false);
				}
				else if (flags[kFLAGS.UNABLE_TO_MASTURBATE_BECAUSE_CENTAUR] > 0 && player.isTaur()) {
					outputText("<b>You are delibitatingly aroused, but your sex organs are so difficult to reach that masturbation isn't at the forefront of your mind.</b>\n\n", false);
				}
				else {
					outputText("<b>You are debilitatingly aroused, and can think of doing nothing other than masturbating.</b>\n\n", false);
					returnEvent  = null;
					forwardEvent = null;
				}
			}
			//Set up rest stuff
			
			//Night
			if (model.time.hours < 6 || model.time.hours > 20) {
				if (flags[kFLAGS.GAME_END] == 0) { //Lethice not defeated
					outputText("It is dark out, made worse by the lack of stars in the sky.  A blood-red moon hangs in the sky, seeming to watch you, but providing little light. It's far too dark to leave camp.\n\n");
				}
				else { //Lethice defeated, proceed with weather
					switch(flags[kFLAGS.CURRENT_WEATHER]) {
						case 0:
						case 1:
							outputText("It is dark out. Stars dot the night sky. A blood-red moon hangs in the sky, seeming to watch you, but providing little light. It's far too dark to leave camp.\n\n");
							break;
						case 2:
							outputText("It is dark out. The sky is covered by clouds and you could faintly make out the red spot in the clouds which is presumed to be the moon. It's far too dark to leave camp.\n\n");
							break;
						case 3:
							outputText("It is dark out. The sky is covered by clouds raining water upon the ground. It's far too dark to leave camp.\n\n");
							break;
						case 4:
							outputText("It is dark out. The sky is covered by clouds raining water upon the ground and occasionally the sky flashes with lightning. It's far too dark to leave camp.\n\n");
							break;
						default:
							outputText("It is dark out. Stars dot the night sky. A blood-red moon hangs in the sky, seeming to watch you, but providing little light. It's far too dark to leave camp.\n\n");
					}
				}
				returnEvent  = null;
				forwardEvent = null;
			}
			//Day Time!
			else {
				if (flags[kFLAGS.GAME_END] > 0) { //Lethice defeated
					switch(flags[kFLAGS.CURRENT_WEATHER]) {
						case 0:
							outputText("The sun shines brightly, illuminating the now-blue sky. ");
							break;
						case 1:
							outputText("The sun shines brightly, illuminating the now-blue sky. Occasional clouds dot the sky, appearing to form different shapes. ");
							break;
						case 2:
							outputText("The sky is light gray as it's covered by the clouds. ");
							break;
						case 3:
							outputText("The sky is fairly dark as it's covered by the clouds that rain water upon the lands. ");
							break;
						case 4:
							outputText("The sky is dark as it's thick with dark grey clouds that rain and occasionally the sky flashes with lightning. ");
							break;
					}
				}
				if (model.time.hours == 19) {
					if (flags[kFLAGS.CURRENT_WEATHER] < 2)
						outputText("The sun is close to the horizon, getting ready to set. ");
					else
						outputText("Though you cannot see the sun, the sky near the horizon began to glow orange. ");
				}
				if (model.time.hours == 20) {
					if (flags[kFLAGS.CURRENT_WEATHER] < 2)
						outputText("The sun has already set below the horizon. The sky glows orange. ");
					else
						outputText("Even with the clouds, the sky near the horizon is glowing bright orange. The sun may have already set at this point. ");
				}
				outputText("It's light outside, a good time to explore and forage for supplies with which to fortify your camp.\n");

			}
			//Weather!

			//Menu
			menu();
			addButton(0, "Forward", 	forwardEvent, 	null, null, null, "Journey forward to visit unexplored regions.");
			addButton(1, "Return", 		returnEvent, 	null, null, null, "Turn back and return to your main camp.");
			addButton(2, "Inventory", 	inventory.inventoryMenu, null, null, null, "The inventory allows you to use an item.  Be careful as this leaves you open to a counterattack when in combat.");
			
			var canFap:Boolean = player.findStatusEffect(StatusEffects.Dysfunction) < 0 && (flags[kFLAGS.UNABLE_TO_MASTURBATE_BECAUSE_CENTAUR] == 0 && !player.isTaur());
			if (player.lust >= 30) {
				addButton(8, "Masturbate", kGAMECLASS.masturbation.masturbateMenu);
				if (((player.findPerk(PerkLib.HistoryReligious) >= 0 && player.cor <= 66) || (player.findPerk(PerkLib.Enlightened) >= 0 && player.cor < 10)) && !(player.findStatusEffect(StatusEffects.Exgartuan) >= 0 && player.statusEffectv2(StatusEffects.Exgartuan) == 0) || flags[kFLAGS.SFW_MODE] >= 1) addButton(8, "Meditate", kGAMECLASS.masturbation.masturbateMenu);
			}
			addButton(9, "Wait", camp.doWait, null, null, null, "Wait for four hours.\n\nShift-click to wait until the night comes.");
			if (player.fatigue > 40 || player.HP / player.maxHP() <= .9) addButton(9, "Rest", camp.rest, null, null, null, "Rest for four hours.\n\nShift-click to rest until fully healed or night comes.");
			if (model.time.hours >= 21 || model.time.hours < 6) addButton(9, "Sleep", camp.doSleep, null, null, null, "Turn yourself in for the night.");

			//Remove buttons according to conditions.
			if (model.time.hours >= 21 || model.time.hours < 6) {
				removeButton(0); //Explore
				removeButton(1); //Places
			}
			if (player.lust >= player.maxLust() && canFap) {
				removeButton(0); //Explore
				removeButton(1); //Places
			}
			//Massive Balls Bad End (Realistic Mode only)
			if (flags[kFLAGS.HUNGER_ENABLED] >= 1 && player.ballSize > (18 + (player.str / 2) + (player.tallness / 4))) {
				camp.badEndGIANTBALLZ();
				return;
			}
			//Hunger Bad End
			if (flags[kFLAGS.HUNGER_ENABLED] > 0 && player.hunger <= 0) {
				//Bad end at 0 HP!
				if (player.HP <= 0 && (player.str + player.tou) < 30) {
					camp.badEndHunger();
					return;
				}
			}
			//Min Lust Bad End (Must not have any removable/temporary min lust.)
			if (player.minLust() >= player.maxLust() && !flags[kFLAGS.SHOULDRA_SLEEP_TIMER] <= 168 && !player.eggs() >= 20 && !player.findStatusEffect(StatusEffects.BimboChampagne) >= 0 && !player.findStatusEffect(StatusEffects.Luststick) >= 0 && player.jewelryEffectId != 1) {
				camp.badEndMinLust();
				return;
			}
			
			
			
			//journeyForward();
			
			// 1) Go forward
			// 1) Turn back
			// 2) Items 
			// 3) Meditate
			// 4) Wait
			// 5) Sleep
			
			
		}
		public function changeJourneyLocation() : int {
			
			
			var choice:int = rand(100);
			
			if (flags[kFLAGS.JOURNEY_MODE] == 1) {
				// Journey to Ignam
				
				switch (flags[kFLAGS.JOURNEY_LOCATION]) {
					
					case JOURNEY_CAMP: {
						if (choice < 50) return JOURNEY_FOREST; // forest
						else return 			JOURNEY_LAKE; 	// lake
						break;
					}
					case JOURNEY_FOREST: {
						if 		(choice < 3) 	return JOURNEY_CAMP; 
						else if (choice < 6) 	return JOURNEY_LAKE;
						else if (choice < 9) 	return JOURNEY_PLAINS;
						else if (choice < 12) 	return JOURNEY_MOUNTAIN;
						else if (choice < 15) 	return JOURNEY_SWAMP;
						else if (choice < 25) 	return JOURNEY_DEEPWOODS;
						break;
					}
					case JOURNEY_LAKE: {
						if 		(choice < 3)  return JOURNEY_CAMP;
						else if (choice < 10) return JOURNEY_PLAINS;
						else if (choice < 15) return JOURNEY_DESERT;
						break;
					}
					case JOURNEY_PLAINS: {
						if 		(choice < 3) 	return JOURNEY_FOREST;
						else if (choice < 6) 	return JOURNEY_LAKE;
						else if (choice < 16) 	return JOURNEY_MOUNTAIN;
						else if (choice < 26) 	return JOURNEY_DESERT;
						break;
					}
					case JOURNEY_DESERT: {
						if 		(choice < 3) 	return JOURNEY_LAKE;
						else if (choice < 9)	return JOURNEY_PLAINS;
						else if (choice < 15) 	return JOURNEY_MOUNTAIN;
						else if (choice < 25) 	return JOURNEY_BADLANDS;
						break;
					}
					case JOURNEY_MOUNTAIN: {
						if 		(choice < 3)	return JOURNEY_FOREST;
						else if (choice < 8) 	return JOURNEY_PLAINS;
						else if (choice < 13)	return JOURNEY_DESERT;
						else if (choice < 20) 	return JOURNEY_BADLANDS;
						else if (choice < 25)	return JOURNEY_HIGH_MOUNTAINS;
						else if (choice < 30) 	return JOURNEY_VOLCANO;
						break;
					}
					case JOURNEY_HIGH_MOUNTAINS: {
						if 		(choice < 5)	return JOURNEY_MOUNTAIN;
						else if (choice < 15)	return JOURNEY_VOLCANO;
						else if (choice < 25)	return JOURNEY_GLACIAL_RIFT;
						break;
					}
					case JOURNEY_VOLCANO: {
						if 		(choice < 10)	return JOURNEY_MOUNTAIN;
						else if (choice < 30)	return JOURNEY_HIGH_MOUNTAINS;
						break;
					}
					case JOURNEY_BADLANDS: {
						if 		(choice < 10)	return JOURNEY_DESERT;
						else if (choice < 15)	return JOURNEY_PRISON;
						else if (choice < 25)	return JOURNEY_GLACIAL_RIFT;
						break;
					}
					case JOURNEY_PRISON:	{
						if 		(choice < 75) 	return JOURNEY_BADLANDS;
						break;
					}
					case JOURNEY_GLACIAL_RIFT: {
						if 		(choice < 5)	return JOURNEY_HIGH_MOUNTAINS;
						else if (choice < 10)	return JOURNEY_BADLANDS;
						else if (choice < 20)	return JOURNEY_TUNDRA;
						break;
					}
					case JOURNEY_DEEPWOODS: 	{
						if 		(choice < 5)	return JOURNEY_FOREST;
						else if (choice < 10)	return JOURNEY_SWAMP;
						else if (choice < 20)	return JOURNEY_BOG;
						break;
					}
					case JOURNEY_SWAMP:{
						if 		(choice < 3)	return JOURNEY_FOREST;
						else if (choice < 9)	return JOURNEY_DEEPWOODS;
						else if (choice < 15)	return JOURNEY_BOG;
						else if (choice < 25)	return JOURNEY_MIRKWOODS;
						break;
					}
					case JOURNEY_BOG:{
						if 		(choice < 3)	return JOURNEY_DEEPWOODS;
						else if (choice < 6)	return JOURNEY_SWAMP;
						else if (choice < 20)	return JOURNEY_MIRKWOODS;
						break;
					}					
					case JOURNEY_MIRKWOODS:{
						if 		(choice < 5)	return JOURNEY_BOG;
						else if (choice < 10)	return JOURNEY_SWAMP;
						else if (choice < 20)	return JOURNEY_STEPPE;
						break;
					}
					case JOURNEY_STEPPE: {
						if 		(choice < 3)	return JOURNEY_MIRKWOODS;
						else if (choice < 6)	return JOURNEY_TUNDRA;
						else if (choice < 20)	return JOURNEY_DARKWOODS;
						break;
					}
					case JOURNEY_TUNDRA: {
						if 		(choice < 5)	return JOURNEY_GLACIAL_RIFT;
						else if (choice < 20)	return JOURNEY_STEPPE;
						break;
					}
					case JOURNEY_DARKWOODS: {
						if 		(choice < 3)	return JOURNEY_STEPPE;
						else if (choice < 15)	return JOURNEY_INGNAM;
						break;
					}
					case JOURNEY_INGNAM:
						break;
				}
				
			}
			return flags[kFLAGS.JOURNEY_LOCATION];
			
			
			// 0 : camp: 
			// 1 : forest:			kGAMECLASS.forest.exploreForest
			// 2 : lake:			kGAMECLASS.lake.exploreLake
			// 3 : desert:			kGAMECLASS.desert.exploreDesert
			// 4 : mountain: 		kGAMECLASS.mountain.exploreMountain
			// 5 : swamp:			kGAMECLASS.swamp.exploreSwamp
			// 6 : plains:			kGAMECLASS.plains.explorePlains
			// 7 : deepwoods:		kGAMECLASS.forest.exploreDeepwoods
			// 8 : highMountains:	kGAMECLASS.highMountains.exploreHighMountain
			// 9 : bog:				kGAMECLASS.bog.exploreBog
			// 10: glacialRift:		kGAMECLASS.glacialRift.exploreGlacialRift
			// 11: volcano:			kGAMECLASS.volcanicCrag.exploreVolcanicCrag
			// 12: mirkwoods:		kGAMECLASS.forest.exploreForest | kGAMECLASS.forest.exploreDeepwoods
			// 13: steppe:			kGAMECLASS.plains.explorePlains | kGAMECLASS.desert.exploreDesert
			// 14: tundra:			kGAMECLASS.plains.explorePlains | kGAMECLASS.glacialRift.exploreGlacialRift
			// 15: darkwoods:		kGAMECLASS.forest.exploreForest | kGAMECLASS.swamp.exploreSwamp
			// 16: badlands:		kGAMECLASS.desert.exploreDesert | kGAMECLASS.mountain.exploreMountain
			// 17: prison:			
			// 18: ingnam:
			
			addButton(4,  "Journey", kGAMECLASS.journey.exploreJourney, null, null, null, "Perform spiritual journey.\n");
			
			
		}
		public function makeJourney() : void {
			switch (flags[kFLAGS.JOURNEY_LOCATION]) {
				case JOURNEY_CAMP:{
					outputText("You return to your camp. Your journey is over.\n");
					break;
				}
				case JOURNEY_FOREST: {
					trace("forest");
					kGAMECLASS.forest.exploreForest();
					break;
				}
				case JOURNEY_LAKE: {
					trace("lake");
					kGAMECLASS.lake.exploreLake();
					break;
				}
				case JOURNEY_PLAINS: {
					trace("plains");
					kGAMECLASS.plains.explorePlains();
					break;
				}
				case JOURNEY_DESERT: {
					trace("desert");
					kGAMECLASS.desert.exploreDesert();
					break;
				}
				case JOURNEY_MOUNTAIN: {
					trace("mountain");
					kGAMECLASS.mountain.exploreMountain();
					break;
				}
				case JOURNEY_HIGH_MOUNTAINS: {
					kGAMECLASS.highMountains.exploreHighMountain();
					break;
				}
				case JOURNEY_VOLCANO: {
					kGAMECLASS.volcanicCrag.exploreVolcanicCrag();
					break;
				}
				case JOURNEY_BADLANDS: {
					if (rand(2) == 0) kGAMECLASS.desert.exploreDesert();
					else 			kGAMECLASS.mountain.exploreMountain();
					break;
				}
				case JOURNEY_PRISON:	{
					outputText("You get into a prison\n");
					break;
				}
				case JOURNEY_GLACIAL_RIFT: {
					kGAMECLASS.glacialRift.exploreGlacialRift();
					break;
				}
				case JOURNEY_DEEPWOODS: 	{
					kGAMECLASS.forest.exploreDeepwoods();
					break;
				}
				case JOURNEY_SWAMP:{
					kGAMECLASS.swamp.exploreSwamp();
					break;
				}
				case JOURNEY_BOG:{
					kGAMECLASS.bog.exploreBog();
					break;
				}					
				case JOURNEY_MIRKWOODS:{
					if (rand(2) == 0) kGAMECLASS.forest.exploreForest();
					else 			  kGAMECLASS.forest.exploreDeepwoods();
					break;
				}
				case JOURNEY_STEPPE: {
					if (rand(2) == 0) kGAMECLASS.plains.explorePlains();
					else 			  kGAMECLASS.desert.exploreDesert();
					break;
				}
				case JOURNEY_TUNDRA: {
					if (rand(2) == 0) kGAMECLASS.plains.explorePlains();
					else 			  kGAMECLASS.glacialRift.exploreGlacialRift();
					break;
				}
				case JOURNEY_DARKWOODS: {
					if (rand(2) == 0) kGAMECLASS.forest.exploreForest();
					else 			  kGAMECLASS.swamp.exploreSwamp();
					break;
				}
				case JOURNEY_INGNAM:
					outputText("You arrive to Ingnam.\n");
					break;
			}
		}
		public function journeyForward() : void {
			
			outputText("You continue going forward\n");
			
			flags[kFLAGS.JOURNEY_LOCATION] = changeJourneyLocation();
			
			makeJourney();
			
			
			
		}
		
	}
	
	
}

