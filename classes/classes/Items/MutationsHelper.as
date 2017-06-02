package classes.Items 
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.Scenes.Places.Ingnam;
	
	/**
	 * Helper class to get rid of the copy&paste-mess in classes.Items.Mutations
	 * @since July 8, 2016
	 * @author Stadler76
	 * Mega revamp by Foxwells May/29/17 to make this damn thing more useful
	 * 
	 * Some body parts have their own useage notes. Be sure to read over them.
	 * 
	 * USEAGE NOTES:
	 * When calling this, be sure to include an if (rand(#) === 0)
	 * If you have body part requirements, include them in your if statement
	 * If you're making a new body part, add it to the possible changes. Otherwise, things are gonna error!
	 * For things with tone: You will need multiple calls if you want to provide multiple colour options
	 * 
	 * ADDING NOTES:
	 * Avoid adding any custom text outside of what is absolutely necessary
	 * Avoid changing any existing code! We want to keep change texts as similar as reasonably possible
	 * Do NOT add body part requirements (eg, bunny ears for bunny face). Add those to your if statement.
	 * > There are miscellaneous exceptions to this, but try to avoid creating such exceptions
	 */
	
	public class MutationsHelper extends BaseContent 
	{
		include "../../../includes/appearanceDefs.as";

		public var changes:int = 0;
		public var changeLimit:int = 1;
		public var temp2:Number = 0;
		public var temp3:Number = 0;

		public function MutationsHelper() { }
		
		public function changeOviPerk(create:Boolean):void { //Change oviposition perk, either create or remove
				trace("oviperk freeze time!");
			if (changes < changeLimit) {
				if (create == true && !player.hasPerk(PerkLib.Oviposition)) { //Create perk if doesn't have
					outputText("\n\nDeep inside yourself, there is a change. It makes you feel a little woozy, but passes quickly. Beyond that, you aren't sure exactly what just happened, but you are sure it originated from your womb. (<b>Perk Gained: Oviposition</b>)");
					player.createPerk(PerkLib.Oviposition, 0, 0, 0, 0);
					changes++;
				}
				else if (create == false && player.hasPerk(PerkLib.Oviposition)) { //Remove if have
					outputText("\n\nA change in your uterus ripples through your reproductive systems. Somehow you know you've lost your egg-based reproductive ability. (<b>Perk Lost: Oviposition</b>)");
					player.removePerk(PerkLib.Oviposition);
					changes++;
				}
			}
		}

		public function changeSkin(newType:int, newTone:String, currentToneStays:Boolean = false):void { //Change skin type. Supports only changing the tone if skin type is already newType. currentToneStays should be true if you don't want tone change.
			if (changes < changeLimit && player.skinType !== newType) { //Change type and tone
				outputText("\n\nYou look down at a furious itching in your arm, only to see ");
					if (player.skinType === SKIN_TYPE_GOO) outputText("your gooey skin solidifying. ");
					else if (player.skinType === SKIN_TYPE_FUR || player.skinType === SKIN_TYPE_WOOL) outputText("your fluffy coat changing. ");
					else if (player.skinType === SKIN_TYPE_LIZARD_SCALES || player.skinType === SKIN_TYPE_DRAGON_SCALES) outputText("your scales changing. ");
					else outputText("your skin changing. ");
				outputText("<b>You now have " + newTone + "");
					if (newType === SKIN_TYPE_PLAIN) outputText(", plain skin!</b>");
					else if (newType === SKIN_TYPE_FUR) outputText(" fur!</b>");
					else if (newType === SKIN_TYPE_LIZARD_SCALES) outputText(" lizard scales!</b>");
					else if (newType === SKIN_TYPE_GOO) outputText(" goo for skin!</b>");
					else if (newType === SKIN_TYPE_DRAGON_SCALES) outputText(" dragon scales!</b>");
					else if (newType === SKIN_TYPE_WOOL) outputText(" wool!</b>");
				player.skinType = newType;
				if (currentToneStays = false) player.skinTone = newTone;
				changes++;
			}
			else if (changes < changeLimit && player.skinType === newType && player.skinTone != newTone && currentToneStays == false) { //Change only tone
				outputText("Your look down at yourself as your ");
					if (newType === SKIN_TYPE_FUR) outputText("fur changes ");
					else if (newType === SKIN_TYPE_LIZARD_SCALES) outputText("lizard scales change ");
					else if (newType === SKIN_TYPE_GOO) outputText("gooey skin changes ");
					else if (newType === SKIN_TYPE_DRAGON_SCALES) outputText("dragon scales change ");
					else if (newType === SKIN_TYPE_WOOL) outputText("wool changes ");
					else outputText("skin changes ");
				outputText("color, becoming a " + newTone + " hue. <b>Your </b>");
					if (newType === SKIN_TYPE_FUR) outputText("fur is ");
					else if (newType === SKIN_TYPE_LIZARD_SCALES) outputText("lizard scales are ");
					else if (newType === SKIN_TYPE_GOO) outputText("gooey skin is ");
					else if (newType === SKIN_TYPE_DRAGON_SCALES) outputText("dragon scales are ");
					else if (newType === SKIN_TYPE_WOOL) outputText("wool is ");
					else outputText("skin is ");
				outputText("<b>now " + newTone + "!</b>");
				player.skinTone = newTone;
				changes++;
			}
		}

		/** 
		 * changeHair is a bit of a mouthful at first glance, so let me break it down a bit.
		 * 
		 * setLength forces hair to a certain length. Does NOT support increasing length at the moment.
		 * Making setLength true and having newLength at 0 will force special going bald text.
		 * 
		 * gainBasiliskHair will grow Basilisk hair. If it's set to true, don't worry about any other fields.
		 * newHair/newColor can be whatever. It doesn't use those fields.
		 * 
		 * The same does NOT apply to removeBasiliskHair, as it needs a new hair type and color to go to.
		 * removeBasiliskHair uses newLength. If you don't want PC to be bald, set something for it.
		 * 
		 * Priority: gainBasiliskHair will always happen if true. If you want other changes, create a new call.
		 * removeBasiliskHair will always happen first if gainBasiliskHair is false and PC has Basilisk hair.
		 * Otherwise, it moves to changing hair types.
		 * 
		 * If you don't want gainBasiliskHair/want removeBasiliskHair, you only need to set newHair and newColor.
		 * Those are the only two absolute requirements. All else have default values most likely to happen.
		**/
		public function changeHair(newHair:int, newColor:String, setLength:Boolean = false, newLength:int = 0, stopGrowth:Boolean = false, startGrowth:Boolean = true, gainBasiliskHair:Boolean = false, removeBasiliskHair:Boolean = true):void {
			if (changes < changeLimit) {
			var hairPinID:int = player.hasKeyItem("Feathery hair-pin");
				if (gainBasiliskHair == true) { //Gain Basilisk hair. Will always run checks and will cancel out the other checks if gainBasiliskHair is true.
					if (/*Start checks*/
					(/*Wrap plume requirements*/
					(player.hairType === HAIR_BASILISK_PLUME && player.cor >= Math.max(80, (65 + player.corruptionTolerance())))/*Allow corrupt Basilisk plumes to go to spines, comes before spine check so they aren't locked out*/
					|| (player.hairType !== HAIR_BASILISK_PLUME && player.isFemaleOrHerm() && player.cor < Math.max(80, (15 + player.corruptionTolerance())) && player.featheryHairPinEquipped() && player.isBasilisk())/*Force requirements for plume*/
					)/*Close plume wrap*/
					|| (player.hairType !== HAIR_BASILISK_SPINES && player.cor >= Math.max(80, (65 + player.corruptionTolerance())) && player.hairType != HAIR_BASILISK_SPINES && player.hasLizardScales() && player.hasReptileFace())/*Force requirements for spines*/
					) {/*Close checks, start code launch*/
						
						if (player.isFemaleOrHerm() && player.cor < Math.max(80, (15 + player.corruptionTolerance())) && player.featheryHairPinEquipped() && player.isBasilisk() && player.hairType !== HAIR_BASILISK_PLUME) { /*Gain plume; keeps its requirment checks so that else if can just be else*/
							outputText("\n\nYour head begins to tickle, and you reach up to scratch at it, only to be surprised by sudden softness. It reminds you of the down of baby chickens, velvety soft and slightly fluffy. You look at yourself in a nearby puddle and gasp. ");
							if (player.hairLength > 0) outputText("Where your hair once was, you ");
							else outputText("You ");
							outputText("now have red feathers");
							if (player.hairLength <= 0) outputText(" for hair");
							outputText("! The floppy but soft plume sits daintily on your head, reminding you of a lady's hair. After a moment of studying, you realize that you have the plume of a female basilisk! <b>Your hair is now a plume of short red feathers.</b>");
							flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] = 0;
							player.hairLength = 2;
							player.hairColor = "red";
							player.hairType = HAIR_BASILISK_PLUME;
							player.keyItems[hairPinID].value2 = 0;
							changes++;
						}
						
						else { /*Gain spines*/
							// Corrupted Basilisk
							if (player.hairLength > 0 && player.hairType !== HAIR_BASILISK_PLUME && player.hairType !== HAIR_GOO) {
								outputText("\n\nYour scalp feels tight and hot, causing you to run a hand through your [hair] to rub at it gingerly. ");
								if (player.featheryHairPinEquipped()) outputText("The pin in your hair heats up to the point where you have to pull it free and toss it to the ground. It sizzles where it lays. ");
								outputText("To your shock a handful of your [hair] comes loose, exposing the [skinFurScales] beneath. You wonder why this is happening to you, but realise it must be the potion-- lizards don't tend to have hair after all. You continue to rub at your scalp, the cool air against your slowly revealed skin a welcome relief. After several minutes of this, you're certain you've shed all your hair. When you think it's all over, you feel an uncomfortable pressure build, your scalp morphing and changing as you grimace. When the sensation finally fades you rush to look at yourself in a puddle. ");
							}
							// Female Basilisk to Corrupted Basilisk
							else if (player.hairLength > 0 && player.hairType === HAIR_BASILISK_PLUME) {
								output.text("\n\nA sudden sharp pain drills through your skull, a pressure forming across your scalp. If you didn't know any better you'd think you were being plucked!");
								if (player.featheryHairPinEquipped()) outputText("The pin in your hair heats up to the point where you have to pull it free and toss it to the ground. It sizzles where it lays. ");
								outputText("You clutch your head as you feel the feathers on your head push out further, thickening up as they do so. The soft vane seems to fall from the spine of the feathers, stripping them bare as the red fluff falls to the floor. Soon the tips of the feathers follow, leaving some rather alien looking spines behind. Your head throbs with dull pain as the transformation seems to end and you go to look at your reflection in a nearby puddle. Your once magnificent plume has turned into a dull crown of spines, like that of the corrupt basilisk in the mountains. As you mourn the loss of your feathered hair, you notice your spines move with your emotions, their sensitive tips picking up on the breeze as they lower closer to your skull. ");
							}
							// Corrupted basilisk with gooey or no hair (bald)
							else if (player.hairType === HAIR_GOO || player.hairLength <= 0) {
								if (player.hairType == HAIR_GOO) outputText("\n\nYour gooey hair begins to fall out in globs, eventually leaving you with a bald head. ");
								else outputText("\n\n");
								if (player.featheryHairPinEquipped()) outputText("The pin in your hair heats up to the point where you have to pull it free and toss it to the ground. It sizzles where it lays. ");
								else outputText("\n\n");
								output.text("Your scalp feels tight, as though the skin is shifting and morphing. You let out groan as you grip your head, praying for the pain to subside quickly. Pressure builds, your head feeling ready to split. As the sensation fades you're left wondering what just happened and you run to look at yourself in a nearby puddle. ");
							}
							// Finalize Corrupted Basilisk TFs
							player.hairColor = player.skinTone;                   // hairColor always set to player.skinTone
							player.hairType = HAIR_BASILISK_SPINES;               // hairType set to basilisk spines
							player.hairLength = 2;                                // hairLength set to 2 (inches, displayed as ‘short’)
							flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] = 1; // Hair growth stops
							changes++;
							output.text("<b>Where your hair would be, you now have a crown of dull reptilian spines!</b>");
							if (player.featheryHairPinEquipped()) outputText("\n\nYou place the hair-pin in your inventory, no longer able to wear it.");
							else if (hairPinID >= 0) outputText("\n\nYour thoughts wander to the hair-pin while you adjust to your new [hair]. You probably won't be able to wear it while you're this tainted.");
							if (hairPinID >= 0) {                                 // hair-pin set to unequipped
								player.keyItems[hairPinID].value1 = 0;
								player.keyItems[hairPinID].value2 = 0;
							}
							changes++;
						}
					}
				}

				else if (removeBasiliskHair == true && (player.hairType === HAIR_BASILISK_SPINES || player.hairType === HAIR_BASILISK_PLUME)) { //Remove Basilisk hair, but only if PC has it. Otherwise goes to normal changes.
					if (player.hairType === HAIR_BASILISK_PLUME) {
						if (player.hairLength >= 5) {
							outputText("\n\nA lock of your feathery plume droops over your eye.  Before you can blow the offending down away, you realize the feather is collapsing in on itself. It continues to curl inward until all that remains is a strand of hair.");
						}
						else {
							outputText("\n\nYou run your fingers through your feathery plume while you await the effects of the item you just ingested. While your hand is up there, it detects a change in the texture of your feathers. They're completely disappearing, merging down into strands of hair.");
						}
					}
					else {
						outputText("\n\nYou feel a tingling on your scalp. You reach up to your basilisk spines to find out what is happening. The moment your hand touches a spine, it comes loose and falls in front of you. One after another the other spines fall out, until all the spines that once decorated your head now lay around you, leaving you with new hair.");
					}
					if (newHair === HAIR_FEATHER) outputText(" <b>You now have feathery hair!</b>");
					else if (newHair === HAIR_GHOST) outputText(" <b>You now have ghostly, transparent hair!</b>");
					else if (newHair === HAIR_GOO) outputText(" <b>You now have goo hair!</b>");
					else if (newHair === HAIR_ANEMONE) outputText(" <b>You now have anemone hair!</b>");
					else if (newHair === HAIR_QUILL) outputText(" <b>You now have quilled hair!</b>");
					else if (newHair === HAIR_WOOL) outputText(" <b>You now have wool hair!</b>");
					else outputText(" <b>You now have normal hair!</b>");
					player.hairType = newHair;
					player.hairColor = newColor;
					player.hairLength = newLength;
					changes++;
				}

				else if (setLength == true && newLength === 0) { //Go bald
					outputText("\n\nYour hair suddenly starts falling out in large clumps, leaving you completely bald. <b>You no longer have hair!</b>");
					player.hairType = newHair;
					player.hairColor = newColor;
					player.hairLength = newLength;
					changes++;
				}

				else if (player.hairType !== newHair) { //Normal hair changes
					outputText("\n\nYour hair suddenly starts falling from your head, falling to the ground in large clumps before new, strange hair takes its place. <b>You now have " + newColor + ", ");
					if (newHair === HAIR_FEATHER) outputText("feathery");
					else if (newHair === HAIR_GHOST) outputText("ghostly");
					else if (newHair === HAIR_GOO) outputText("have goo");
					else if (newHair === HAIR_ANEMONE) outputText("anemone");
					else if (newHair === HAIR_QUILL) outputText("quilled");
					else if (newHair === HAIR_WOOL) outputText("wool");
					else outputText("normal");
					outputText(" hair!</b>");
					player.hairType = newHair;
					player.hairColor = newColor;
					if (setLength == true) player.hairLength = newLength;
					changes++;
				}

				if (startGrowth == true && flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] === 1) { // Hair growth starts
					outputText("\n\nAn odd tingling takes over your scalp, and somehow, you know your hair will start growing again.");
					flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] = 0;
					changes++;
				}

				if (stopGrowth == true && flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] === 0) { // Hair growth stops
					outputText("\n\nAn odd tingling takes over your scalp, and somehow, you know your hair won't be growing anymore.");
					flags[kFLAGS.HAIR_GROWTH_STOPPED_BECAUSE_LIZARD] = 1;
					changes++;
				}

			}
		}

		public function changeHorns(newHorns:int, newCount:Number):void { //Change horns. Supports no horns to horns, supports count being length, supports size increase, supports horn removal
			if (changes < changeLimit && newHorns === HORNS_NONE && player.hornType !== newHorns) { //Horn removal
				outputText("\n\nYour ");
					if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("horn crumbles and flakes away, ");
					else outputText("horns crumble and flake away, ");
				outputText("falling apart until ");
					if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("it's ");
					else outputText("they're ");
				outputText("gone completely. <b>You have lost your");
					if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("horn");
					else outputText("horns");
				outputText("!</b>");
				
				player.horns = 0;
				player.hornType = newHorns;
				changes++;
			}
			
			else if (changes < changeLimit && player.hornType !== newHorns) { //New horn type
				if (player.hornType === HORNS_NONE) { //No horns to start
					outputText("\n\nYour head starts to ache and you grip your forehead in time to feel ");
						if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("a large horn ");
						else outputText("a pair of horns ");
					outputText("sprout out of it. <b>You now have ");
						if (newHorns === HORNS_DEMON) outputText("demon horns!</b>");
						else if (newHorns === HORNS_COW_MINOTAUR) outputText("" + player.mf("minotaur", "cow") + " horns!</b>");
						else if (newHorns === HORNS_DRACONIC_X2) outputText("dragon horns!</b>");
						else if (newHorns === HORNS_DRACONIC_X4_12_INCH_LONG) outputText("four long dragon horns!</b>");
						else if (newHorns === HORNS_ANTLERS) outputText("antlers!</b>");
						else if (newHorns === HORNS_GOAT) outputText("goat horns!</b>");
						else if (newHorns === HORNS_UNICORN) outputText("a unicorn horn!</b>");
						else if (newHorns === HORNS_RHINO) outputText("a rhinoceros horn!</b>");
						else if (newHorns === HORNS_SHEEP) outputText("sheep horns!</b>");
						else if (newHorns === HORNS_RAM) outputText("ram horns!</b>");
						else if (newHorns === HORNS_IMP) outputText("imp horns!</b>");
					else outputText("ERROR! Horn type not found! Report this bug immediately!</b>");
				}
				else { //Had horns
					outputText("\n\nYou grip your head as your ");
						if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("horn rearranges itself, ");
						else outputText("horns rearrange themselves, ");
					outputText("sending dizzying pain through you. When it finally subsides, you look into the nearest reflective surface and see a ");
						if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("large horn ");
						else outputText("pair of horns ");
					outputText("sprouting out of your forehead. <b>You now have ");
						if (newHorns === HORNS_DEMON) outputText("demon horns!</b>");
						else if (newHorns === HORNS_COW_MINOTAUR) outputText("" + player.mf("minotaur", "cow") + " horns!</b>");
						else if (newHorns === HORNS_DRACONIC_X2) outputText("dragon horns!</b>");
						else if (newHorns === HORNS_DRACONIC_X4_12_INCH_LONG) outputText("four long dragon horns!</b>");
						else if (newHorns === HORNS_ANTLERS) outputText("antlers!</b>");
						else if (newHorns === HORNS_GOAT) outputText("goat horns!</b>");
						else if (newHorns === HORNS_UNICORN) outputText("a unicorn horn!</b>");
						else if (newHorns === HORNS_RHINO) outputText("a rhinoceros horn!</b>");
						else if (newHorns === HORNS_SHEEP) outputText("sheep horns!</b>");
						else if (newHorns === HORNS_RAM) outputText("ram horns!</b>");
						else if (newHorns === HORNS_IMP) outputText("imp horns!</b>");
					else outputText("ERROR! Horn type not found! Report this bug immediately!</b>");
				}
				player.hornType = newHorns;
				player.horns = newCount;
				changes++;
			}
			
			else if (changes < changeLimit && player.hornType === newHorns) { //Increase size if horns same type
				outputText("\n\nYou groan and hold your head as your ");
					if (newHorns === HORNS_UNICORN || newHorns === HORNS_RHINO) outputText("horn gets longer");
					else if (newHorns === HORNS_ANTLERS) outputText("antlers grow more branches");
					else outputText("horns get longer");
				if (newHorns === HORNS_DEMON) outputText(", a new row also sprouting behind your existing ones");
				outputText(".");
				
				player.horns += newCount;
				changes++;
			}
		}

		public function removeAntennae():void { //Remove bee antennae
			if (changes < changeLimit && player.antennae === ANTENNAE_BEE) {
				outputText("\n\nYour antennae suddenly fall from your head, landing on the ground in front of you. <b>You have lost your antennae!</b>");
				player.antennae = ANTENNAE_NONE;
				changes++;
			}
		}

		public function changeEars(newEars:int):void { //Change ear type
			if (changes < changeLimit && player.earType !== newEars) {
				outputText("\n\nYour ears suddenly twist and reform, changing shape. <b>You now have ");
					if (newEars === EARS_HUMAN) outputText("human ");
					else if (newEars === EARS_HORSE) outputText("horse ");
					else if (newEars === EARS_DOG) outputText("dog ");
					else if (newEars === EARS_COW) outputText("cow ");
					else if (newEars === EARS_ELFIN) outputText("pointed elfin ");
					else if (newEars === EARS_CAT) outputText("cat ");
					else if (newEars === EARS_LIZARD) outputText("lizard ");
					else if (newEars === EARS_BUNNY) outputText("floppy bunny ");
					else if (newEars === EARS_KANGAROO) outputText("kangaroo ");
					else if (newEars === EARS_FOX) outputText("fox ");
					else if (newEars === EARS_DRAGON) outputText("dragon-fin ");
					else if (newEars === EARS_RACCOON) outputText("raccoon ");
					else if (newEars === EARS_MOUSE) outputText("mouse ");
					else if (newEars === EARS_FERRET) outputText("ferret ");
					else if (newEars === EARS_PIG) outputText("pig ");
					else if (newEars === EARS_RHINO) outputText("rhinoceros ");
					else if (newEars === EARS_ECHIDNA) outputText("echidna ");
					else if (newEars === EARS_DEER) outputText("deer ");
					else if (newEars === EARS_WOLF) outputText("wolf ");
					else if (newEars === EARS_SHEEP) outputText("soft sheep ");
					else if (newEars === EARS_IMP) outputText("pointy imp ");
					else outputText("ERROR! Ear type not found! Report this bug immediately!");
				outputText("ears!</b>");
				
				player.earType = newEars;
				changes++;
			}
		}

		public function changeEyes(newEyes:int, newEyeCount:Number = 2):void { //Change eyes. Supports changing count.
			if (changes < changeLimit && player.eyeType !== newEyes) {
				outputText("\n\nYour vision suddenly goes dark as your eyes change. You sit down while you wait for your face to stop shifting, and once you can see again, you bee-line for the nearest reflective surface. <b>You now have ");
				if (newEyeCount === 1) outputText("a single ");
				else if (newEyeCount === 4) outputText("four ");
				else if (newEyeCount > 2 && newEyeCount !== 4) outputText("several ");
				else if (newEyeCount === 2 && player.eyeCount !== 2) outputText("two ");
				else outputText("");
				
				if (newEyes === EYES_HUMAN) outputText("human ");
				else if (newEyes === EYES_BLACK_EYES_SAND_TRAP) outputText("all-black sand trap ");
				else if (newEyes === EYES_LIZARD) outputText("lizard ");
				else if (newEyes === EYES_DRAGON) outputText("dragon ");
				else if (newEyes === EYES_BASILISK) outputText("basilisk ");
				else if (newEyes === EYES_WOLF) outputText("wolf ");
				else if (newEyes === EYES_SPIDER) outputText("spider ");
				else outputText("different ");
				
				if (newEyeCount === 1) outputText("eye!</b>");
				else outputText("eyes!</b>");
				
				if (newEyeCount === 1) outputText(" Your eye sits right between your nose and forehead.");
				else if (newEyeCount === 3) outputText(" Your new eye sits in the middle of your forehead.");
				else if (newEyeCount === 4) outputText(" Your two new eyes sit on your forehead.");
				else if (newEyeCount >= 5) outputText(" Your new eyes sit on and around your forehead.");
				else outputText("");
				
				player.eyeType = newEyes;
				player.eyeCount = newEyeCount;
				
				changes++;
			}
		}

		public function changeEyeCount(newEyeCount:Number):void { //For changing just the count.
			if (changes < changeLimit && player.eyeCount !== newEyeCount) {
				outputText("\n\nYour vision suddenly goes dark as your eyes change. You sit down while you wait for your face to stop shifting, and once you can see again, you bee-line for the nearest reflective surface. <b>You now have ");
				if (newEyeCount === 1) outputText("a single eye!</b> Your eye sits right between your nose and forehead.");
				else if (newEyeCount === 3) outputText("three eyes!</b> Your new eye sits in the middle of your forehead.");
				else if (newEyeCount === 4) outputText("four eyes!</b> Your two new eyes sit on your forehead.");
				else if (newEyeCount >= 5) outputText("several eyes!</b> Your new eyes sit on and around your forehead.");
				else if (newEyeCount === 2 && player.eyeCount !== 2) outputText("two eyes!</b>");
				else outputText("new eyes!</b>");
				
				player.eyeCount = newEyeCount;
				changes++;
			}
		}

		public function changeTongue(newTongue:int):void { //Change tongue type, supports snake to demon (plain-to-demon not enabled)
			if (changes < changeLimit && (player.tongueType === TONGUE_SNAKE && newTongue === TONGUE_DEMONIC || player.tongueType !== newTongue && newTongue !== TONGUE_DEMONIC)) {
				if (player.tongueType === TONGUE_SNAKE && newTongue === TONGUE_DEMONIC) {
					outputText("\n\nYour snake-like tongue tingles, thickening in your mouth until it feels more like your old human tongue, at least for the first few inches. It bunches up inside you, and when you open up your mouth to release it, roughly two feet of tongue dangles out. You find it easy to move and control, as natural as walking. <b>You now have a long demon-tongue!</b>");
				}
				else if (newTongue === TONGUE_SNAKE) {
					outputText("\n\nYour tongue shortens, pulling tight in the very back of your throat. After a moment the bunched-up tongue-flesh begins to flatten out, then extend forwards. By the time the transformation has finished, <b>your tongue has changed into a long, forked snake-tongue!</b>");
				}
				else if (newTongue === TONGUE_DRACONIC) {
					output.text("\n\nYour tongue suddenly falls out of your mouth and begins undulating as it grows longer. For a moment, it swings wildly, completely out of control-- but then settles down and you find you can control it at will, almost like a limb. You're able to stretch it to nearly 4 feet and retract it back into your mouth to the point it looks like a normal human tongue. <b>You now have a draconic tongue!</b>");
				}
				else if (newTongue === TONGUE_ECHIDNA) {
					outputText("\n\nYou feel an uncomfortable pressure in your tongue as it begins to shift and change. Within moments, you are able to behold your long, thin tongue. It has to be at least a foot long. <b>You now have an echidna tongue!</b>");
				}
				else if (newTongue === TONGUE_LIZARD) {
					outputText("\n\nYour tongue goes numb, making your surprised noise little more than a gurgle as your tongue flops comically. ");
					if (player.tongueType === TONGUE_DEMONIC || player.tongueType === TONGUE_DRACONIC) {
						outputText("Your tongue ");
						if (player.tongueType === TONGUE_DEMONIC) outputText("gently ");
						else outputText("rapidly ");
						outputText("shrinks down, the thick appendage remaining flexible but getting much smaller. There's little you can do but endure the weird pinching feeling as your tongue eventually settles at being a foot long. The pinching sensation continues as the tip of your tongue morphs, becoming a distinctly forked shape. As you inspect your tongue you slowly regain control, retracting it into your mouth, the forked tips picking up on things you couldn't taste before.");
					}
					else {
						outputText("Slowly, your tongue swells, thickening up until it's about as thick as your thumb");
						if (newTongue !== TONGUE_SNAKE) {
							if (newTongue === TONGUE_ECHIDNA) outputText(" while still staying long");
							else outputText(", filling your mouth and making you splutter. It begins lengthening afterwards, continuing until it hangs out your mouth, settling at about a foot long");
							outputText(". The tip pinches, making you wince, and it morphs into a distinct, forked shape. As you inspect your tongue, you begin to regain control and retract it into your mouth, the forked tips picking up on things you couldn't taste before.");
						}
						else outputText(" while still staying quite flexible. You drool, your tongue lolling out of your mouth as you slowly begin to regain control of your forked organ. When you retract your tongue however, you are shocked to find it is much longer than it used to be, now a foot long. As you cram your newly shifted appendage back in your mouth, you feel a sudden SNAP, and on inspection, you realize you've snapped off your fangs! Well, you suppose you needed the room anyway.");
					}
					outputText(" <b>You now have a lizard tongue!</b>");
				}
				var oldTongue:int = player.tongueType; //Used in case some kind of tongue bridge slipped through
				player.tongueType = newTongue;
				changes++;
				if (newTongue === TONGUE_DEMONIC && oldTongue !== TONGUE_SNAKE) {
					player.tongueType = oldTongue;
					changes--;
				}
			}
		}

		public function changeFace(newFace:int):void { //Change face type
			if (changes < changeLimit && player.faceType !== newFace) {
				outputText("\n\nYou double over and howl in pain as your face rearranges itself, bones and skin shifting in transformation. <b>You now have a </b>");
					if (newFace === FACE_HUMAN) outputText("<b>human's </b>");
					else if (newFace === FACE_HORSE) outputText("<b>horse's </b>");
					else if (newFace === FACE_DOG) outputText("<b>dog's </b>");
					else if (newFace === FACE_COW_MINOTAUR) outputText("<b>" + player.mf("minotaur's","cow's") + " </b>");
					else if (newFace === FACE_SHARK_TEETH) outputText("<b>shark-toothed </b>");
					else if (newFace === FACE_SNAKE_FANGS) outputText("<b>snake-fanged </b>");
					else if (newFace === FACE_CAT) outputText("<b>cat's </b>");
					else if (newFace === FACE_LIZARD) outputText("<b>lizard's </b>");
					else if (newFace === FACE_BUNNY) outputText("<b>bunny's </b>");
					else if (newFace === FACE_KANGAROO) outputText("<b>kangaroo's </b>");
					else if (newFace === FACE_SPIDER_FANGS) outputText("<b>spider-fanged </b>");
					else if (newFace === FACE_FOX) outputText("<b>fox's </b>");
					else if (newFace === FACE_DRAGON) outputText("<b>dragon's </b>");
					else if (newFace === FACE_RACCOON_MASK) outputText("<b>raccoon-masked </b>");
					else if (newFace === FACE_RACCOON) outputText("<b>raccoon's </b>");
					else if (newFace === FACE_BUCKTEETH) outputText("<b>bucktoothed </b>");
					else if (newFace === FACE_MOUSE) outputText("<b>mouse's </b>");
					else if (newFace === FACE_FERRET_MASK) outputText("<b>ferret-masked </b>");
					else if (newFace === FACE_FERRET) outputText("<b>ferret's </b>");
					else if (newFace === FACE_PIG) outputText("<b>pig's </b>");
					else if (newFace === FACE_BOAR) outputText("<b>boar's </b>");
					else if (newFace === FACE_RHINO) outputText("<b>rhino's </b>");
					else if (newFace === FACE_ECHIDNA) outputText("<b>echidna's </b>");
					else if (newFace === FACE_DEER) outputText("<b>deer's </b>");
					else if (newFace === FACE_WOLF) outputText("<b>wolf's </b>");
					else outputText("<b>new </b>");
				outputText("<b>face!</b>");
				player.faceType = newFace;
				changes++;
			}
		}

		public function changeArms(newArm:int, changeClaws:Boolean = false, newClaws:int = CLAW_TYPE_NORMAL, newClawTone:String = "", predArmDesc:String = "predator"):void { //Changes arms to whatever has been specified. predArmDesc is so you can do like "imp" or whatever. Supports changing claws in one go!
			
			if (changes < changeLimit && player.armType !== newArm) { //Lock to prevent arms changing into what they already are.
				outputText("\n\nPain suddenly twists your arms as they shift and lose their ");
					if (player.armType === ARM_TYPE_HUMAN) outputText("human shape, ");
					else if (player.armType === ARM_TYPE_HARPY) outputText("feathers, ");
					else if (player.armType === ARM_TYPE_SPIDER) outputText("chitinous coverings, ");
					else if (player.armType === ARM_TYPE_PREDATOR) outputText("predatory shape, ");
					else if (player.armType === ARM_TYPE_SALAMANDER) outputText("scales, ");
					else outputText("<b>ERROR! Arm type not found! Please report this bug immediately!</b>");
				outputText("becoming ");
					if (newArm === ARM_TYPE_HUMAN) outputText("human-like ");
					else if (newArm === ARM_TYPE_HARPY) outputText("feathery ");
					else if (newArm === ARM_TYPE_SPIDER) outputText("chitinous, arachnoid ");
					else if (newArm === ARM_TYPE_PREDATOR) outputText("more " + predArmDesc + "-like ");
					else if (newArm === ARM_TYPE_SALAMANDER) outputText("scaley salamander ");
					else outputText("<b>ERROR! Arm type not found! Please report this bug immediately!</b>");
				outputText("arms. ");
				player.armType = newArm; //MUST BE BEFORE THE REST OF THE OUTPUT, OR ELSE THE ARM DESC GETS FUCKED
					
				if (changeClaws == true && player.clawType !== newClaws) {
					outputText(" Your ");
					if (player.clawType === CLAW_TYPE_NORMAL) outputText("fingers");
					else outputText("claws");
					player.clawType = newClaws; //MUST BE BEFORE NEXT OUTPUT, OR ELSE THE CLAW DESC GETS FUCKED
					player.clawTone = newClawTone;
					outputText(" shift as well, morphing into ");
					if (player.clawType === CLAW_TYPE_NORMAL) outputText("regular fingers.");
					else outputText("" + player.clawTone + " claws. ");
				}
				
				outputText(" <b>You now have </b>");
					if (player.armType === ARM_TYPE_HUMAN) outputText("<b>human arms</b>");
					else if (player.armType === ARM_TYPE_HARPY) outputText("<b>harpy arms</b>");
					else if (player.armType === ARM_TYPE_SPIDER) outputText("<b>spider arms</b>");
					else if (player.armType === ARM_TYPE_PREDATOR) outputText("<b>" + predArmDesc + " arms</b>");
					else if (player.armType === ARM_TYPE_SALAMANDER) outputText("<b>salamander arms</b>");
					else outputText("<b>ERROR! Arm type not found! Please report this bug immediately!</b>");
				if (changeClaws == true && player.clawType !== CLAW_TYPE_NORMAL) outputText("<b> and claws</b>");
				outputText("<b>!</b>");
				
				changes++;
			}
		}

		public function changeClaws(newClaws:int, customTone:Boolean = false, newTone:String = ""):void { //Change claws. Supports changing tone to something custom if claw type is already newClaws
			if (changes < changeLimit && player.clawType !== newClaws) {
				
				outputText("\n\nYour ");
				if (player.clawType === CLAW_TYPE_NORMAL) outputText("fingers ");
				else outputText("claws ");
				outputText("wrench and twist painfully, morphing into ");
				
				if (customTone == true) {
					outputText("" + newTone + " ");
					if (newClaws === CLAW_TYPE_NORMAL) outputText("fingers ");
					else {
						if (newClaws === CLAW_TYPE_LIZARD) outputText("reptilian ");
						else if (newClaws === CLAW_TYPE_DRAGON) outputText("draconic ");
						else if (newClaws === CLAW_TYPE_SALAMANDER) outputText("salamander ");
						else if (newClaws === CLAW_TYPE_IMP) outputText("imp ");
						else outputText("");
						
						outputText("claws");
					}
				}
				
				else {
					if (newClaws === CLAW_TYPE_NORMAL || newClaws === CLAW_TYPE_LIZARD || newClaws === CLAW_TYPE_IMP) {
						newTone = player.skinTone;
						if (newClaws === CLAW_TYPE_IMP) outputText("" + newTone + " imp claws");
						if (newClaws === CLAW_TYPE_LIZARD) outputText("scaley, " + newTone + " reptile claws");
						else outputText("human-like fingers");
					}
					else if (newClaws === CLAW_TYPE_DRAGON) {
						newTone = "steely gray";
						outputText("sharp, " + newTone + ", draconic claws");
					}
					else if (newClaws === CLAW_TYPE_SALAMANDER) {
						newTone = "fiery-red";
						outputText("fiery-red salamander claws");
					}
					else {
						newTone = player.skinTone;
						outputText("odd claws");
					}
				}
				
				outputText("! <b>You now have </b>");
				if (newClaws === CLAW_TYPE_NORMAL) outputText("<b>human fingers!</b>");
				else outputText("<b>new claws!</b>");
				
				player.clawTone = newTone;
				player.clawType = newClaws;
				
				changes++;
			}
			
			else if (changes < changeLimit && player.clawType === newClaws && customTone == true) {
				outputText("Your ");
				if (player.clawType === CLAW_TYPE_NORMAL) outputText("fingers ");
				else outputText("claws ");
				outputText("wrench and twist painfully, morphing into " + newTone + "-colored");
				if (newClaws === CLAW_TYPE_NORMAL) outputText("fingers");
				else outputText("claws");
				outputText(". <b>Your </b>");
				if (player.clawType === CLAW_TYPE_NORMAL) outputText("<b>hands </b>");
				else outputText("<b>claws </b>");
				outputText("<b>have changed color!</b>");
				
				player.clawTone = newTone;
				
				changes++;
			}
		}

		public function changeGills(newGills:int):void { //Change gills. Removal is done by just setting newGills as none.
			if (changes < changeLimit && player.gillType !== newGills) {
				if (newGills === GILLS_NONE) {
					outputText("\n\nAbsent-mindedly, you start scratching at your chest as it begins to furiously itch. You don't think of it at first, but as the itching turns to burning, you finally look down to investigate, and notice that <b>you have lost your gills!</b>");
				}
				else {
					outputText("\n\nYour chest suddenly itches and burns. You scratch at it to sate it, but when that doesn't help, you look to see what happened. Your torso has changed. <b>You now have </b>");
					if (newGills === GILLS_ANEMONE) outputText("<b>anemone </b>");
					else if (newGills === GILLS_FISH) outputText("<b>fish </b>");
					else outputText("<b>marine-life </b>");
					outputText("<b>gills!</b>");
				}
				player.gillType = newGills;
				changes++;
			}
		}

		public function changeWings(newWings:int):void { //Change wings. Remove by setting wings as none.
			if (changes < changeLimit && player.wingType !== newWings) {
				if (newWings === WING_TYPE_NONE) { //Lose wings
					outputText("\n\nYou feel a sharp pinch in your back, then a sudden loss of weight. You turn around and see your wings on the ground, instead of on your back where they belong. <b>You have lost your wings!</b>");
				}
				else { //Grow wings
					outputText("\n\nA burning sensation fills your backside as ");
					if (player.wingType !== WING_TYPE_NONE) outputText("your wings degrade, falling apart and flaking away while ");
					outputText("sharp pain takes over, and ");
					if (player.wingType !== WING_TYPE_NONE) outputText("new ");
						
					if (newWings === WING_TYPE_SHARK_FIN) outputText("a fin sprouts ");
					else outputText("wings sprout ");
					outputText("from your back. <b>You now have ");
					
					if (newWings === WING_TYPE_BEE_LIKE_SMALL || newWings === WING_TYPE_IMP || newWings === WING_TYPE_BAT_LIKE_TINY || newWings === WING_TYPE_DRACONIC_SMALL) outputText("small ");
					else if (newWings === WING_TYPE_SHARK_FIN) outputText("a ");
					else outputText("large ");
					
					if (newWings === WING_TYPE_BEE_LIKE_SMALL || newWings === WING_TYPE_BEE_LIKE_LARGE) outputText("bee ");
					else if (newWings === WING_TYPE_IMP || newWings === WING_TYPE_IMP_LARGE) outputText("imp ");
					else if (newWings === WING_TYPE_BAT_LIKE_TINY || newWings === WING_TYPE_BAT_LIKE_LARGE) outputText("bat-like ");
					else if (newWings === WING_TYPE_FEATHERED_LARGE) outputText("feathered ");
					else if (newWings === WING_TYPE_DRACONIC_SMALL || newWings === WING_TYPE_DRACONIC_LARGE) outputText("dragon ");
					else if (newWings === WING_TYPE_GIANT_DRAGONFLY) outputText("dragonfly ");
					else outputText("and new ");
						
					if (newWings === WING_TYPE_SHARK_FIN) outputText("shark fin!</b>");
					else outputText("wings!</b>");
				}
				player.wingType = newWings;
				changes++;
			}
		}

		public function changeHips(sizeGoal:int, maxChangeAmount:Number, sizeIsIncreasing:Boolean):void { //Change hip size. If increase, sizeIsIncreasing should be true. Otherwise, set it to false. maxChangeAmount is plugged into a rand, determines by how much it changes. Will never change lower than 1.
			var changeAmount:Number = (rand(maxChangeAmount) + 1);
			if (changes < changeLimit && ((sizeIsIncreasing == true && player.hipRating < sizeGoal) || (sizeIsIncreasing == false && player.hipRating > sizeGoal))) { //Checks for if size isn't goal, but doesn't need to be reduced/increased
				outputText("\n\nYou stumble a bit as your balance is thrown off. You keep yourself from falling, but do notice that your hips seem to have gotten ");
				if (changeAmount > 3) outputText("much ");
				
				if (sizeIsIncreasing == true) { //Increase size
					outputText("wider.");
					player.hipRating += changeAmount;
					if (player.hipRating > sizeGoal) player.hipRating = sizeGoal;
				}
				else { //Decrease size
					outputText("smaller.");
					player.hipRating -= changeAmount;
					if (player.hipRating < sizeGoal) player.hipRating = sizeGoal;
				}
				
				changes++;
			}
		}

		public function changeButt(sizeGoal:int, maxChangeAmount:Number, sizeIsIncreasing:Boolean):void { //Change butt size. Works the same as changeHips.
			var changeAmount:Number = (rand(maxChangeAmount) + 1);
			if (changes < changeLimit && ((sizeIsIncreasing == true && player.buttRating < sizeGoal) || (sizeIsIncreasing == false && player.buttRating > sizeGoal))) { //Checks for if size isn't goal, but doesn't need to be reduced/increased
				outputText("\n\nYou stumble a bit as your balance is thrown off. You keep yourself from falling, but do notice that your butt seems to have gotten ");
				if (changeAmount > 3) outputText("much ");
				
				if (sizeIsIncreasing == true) { //Increase size
					outputText("bigger.");
					player.buttRating += changeAmount;
					if (player.buttRating > sizeGoal) player.buttRating = sizeGoal;
				}
				else { //Decrease size
					outputText("smaller.");
					player.buttRating -= changeAmount;
					if (player.buttRating < sizeGoal) player.buttRating = sizeGoal;
				}
				
				changes++;
			}
		}

		public function changeHeight(heightGoal:int, maxChangeAmount:Number, heightIsIncreasing:Boolean):void { //Change height. Works same as changeHips.
			var changeAmount:Number = (rand(maxChangeAmount) + 1);
			if (changes < changeLimit && ((heightIsIncreasing == true && player.tallness < heightGoal) || (heightIsIncreasing == false && player.tallness > heightGoal))) { //Checks for if size isn't goal, but doesn't need to be reduced/increased
				outputText("\n\nThe world suddenly spins, and you nearly walk off your feet. You manage to keep yourself from falling, but do notice that you've become ");
				if (changeAmount > 3) outputText("much ");
				
				if (heightIsIncreasing == true) { //Increase height
					outputText("taller.");
					player.tallness += changeAmount;
					if (player.tallness > heightGoal) player.tallness = heightGoal;
				}
				else { //Decrease size
					outputText("shorter.");
					player.tallness -= changeAmount;
					if (player.tallness < heightGoal) player.tallness = heightGoal;
				}
				
				changes++;
			}
		}

		public function changeTail(newTail:int, setVenom:Number = 0, setRecharge:Number = 5):void { //Change tail. Does not support venom changes, those fields are only for initial set-up. USE changeVenom FOR FOX TAIL GAINS.
			if (changes < changeLimit && player.tailType !== newTail) {
				if (newTail === TAIL_TYPE_NONE) { //Remove tail
					outputText("\n\nYou feel a sharp pain in your backside. You look behind you to investigate, only to find that your ");
					if (player.tailType === TAIL_TYPE_FOX && player.tailVenom > 1) outputText("tails ");
					else if (player.tailType === TAIL_TYPE_SPIDER_ADBOMEN) outputText("arachnid abdomen ");
					else if (player.tailType === TAIL_TYPE_BEE_ABDOMEN) outputText("insectoid abdomen ");
					else if (player.tailType === TAIL_TYPE_SCORPION) outputText("scorpion stinger ");
					else if (player.tailType === TAIL_TYPE_HARPY) outputText("tail feathers ");
					else outputText("tail ");
					
					if (player.tailType === TAIL_TYPE_HARPY || (player.tailType === TAIL_TYPE_FOX && player.tailVenom > 1)) outputText("are ");
					else outputText("is ");
					
					outputText("gone! <b>You have lost your tail!</b>");
					player.tailType = newTail;
					player.tailVenom = 0;
					player.tailRecharge = 5;
				}
				
				else { //Gain tail
					outputText("\n\nYou feel a sharp pain in your backside. You look behind you to investigate, only to find that you've grown a new tail! <b>You now have a");
					
					if (newTail === TAIL_TYPE_HORSE) outputText(" horse's ");
					else if (newTail === TAIL_TYPE_DOG) outputText(" dog's ");
					else if (newTail === TAIL_TYPE_DEMONIC) outputText(" demon's ");
					else if (newTail === TAIL_TYPE_COW) outputText(" cow's ");
					else if (newTail === TAIL_TYPE_SPIDER_ADBOMEN) outputText(" spider's ");
					else if (newTail === TAIL_TYPE_BEE_ABDOMEN) outputText(" bee's ");
					else if (newTail === TAIL_TYPE_SHARK) outputText(" shark's ");
					else if (newTail === TAIL_TYPE_CAT) outputText(" cat's ");
					else if (newTail === TAIL_TYPE_LIZARD) outputText(" lizard's ");
					else if (newTail === TAIL_TYPE_RABBIT) outputText(" rabbit's ");
					else if (newTail === TAIL_TYPE_HARPY) outputText(" harpy's ");
					else if (newTail === TAIL_TYPE_KANGAROO) outputText(" kangaroo's ");
					else if (newTail === TAIL_TYPE_FOX) outputText(" fox's ");
					else if (newTail === TAIL_TYPE_DRACONIC) outputText(" dragon's ");
					else if (newTail === TAIL_TYPE_RACCOON) outputText(" raccoon's ");
					else if (newTail === TAIL_TYPE_MOUSE) outputText(" mouse's ");
					else if (newTail === TAIL_TYPE_FERRET) outputText(" ferret's ");
					else if (newTail === TAIL_TYPE_BEHEMOTH) outputText(" Behemoth's ");
					else if (newTail === TAIL_TYPE_PIG) outputText(" pig's ");
					else if (newTail === TAIL_TYPE_SCORPION) outputText(" scorpion's ");
					else if (newTail === TAIL_TYPE_GOAT) outputText(" goat's ");
					else if (newTail === TAIL_TYPE_RHINO) outputText(" rhinoceros' ");
					else if (newTail === TAIL_TYPE_ECHIDNA) outputText("n echidna's ");
					else if (newTail === TAIL_TYPE_DEER) outputText(" deer's ");
					else if (newTail === TAIL_TYPE_SALAMANDER) outputText(" salamander's ");
					else if (newTail === TAIL_TYPE_WOLF) outputText(" wolf's ");
					else if (newTail === TAIL_TYPE_SHEEP) outputText(" sheep's ");
					else if (newTail === TAIL_TYPE_IMP) outputText("n imp's ");
					else outputText("!!ERROR!! Tail type not found! Report this bug immediately!");
					
					if (newTail === TAIL_TYPE_SCORPION) outputText("stinger for a tail");
					else if (newTail === TAIL_TYPE_SPIDER_ADBOMEN || newTail === TAIL_TYPE_BEE_ABDOMEN) outputText("abdomen for a tail");
					else if (newTail === TAIL_TYPE_HARPY) outputText("tail feathers");
					else outputText("tail");
					
					outputText("!</b>");
					
					player.tailType = newTail;
					player.tailVenom = setVenom;
					player.tailRecharge = setRecharge;
				}
				
				changes++;
			}
		}

		public function changeVenom(maxChangeAmount:Number, venomIsIncreasing:Boolean = true, changingFoxTail:Boolean = false):void { //Change tail venom, does NOT support recharge changes. changingFoxTail will always add 1 tail. Otherwise, venom can be increased or decreased as declared by venomIsIncreasing
			var changeAmount:Number = (rand(maxChangeAmount) + 1);
			if (changes < changeLimit) {
				if (changingFoxTail == false) { //Change actual venom
					outputText("\n\nYou feel a shift in your body as your tail's venom grows ");
					if (venomIsIncreasing == true) outputText("more ");
					else outputText("less ");
					outputText("potent.");
					
					if (venomIsIncreasing == true) player.tailVenom += changeAmount;
					else player.tailVenom -= changeAmount;
					changes++;
				}
				else if (changingFoxTail == true && player.tailVenom < 8) { //Add a fox tail, max of 8. 9th tails are handled with special text set on Fox Jewels.
					outputText("\n\nA bolt like lightning shoots through you as your tail");
					if (player.tailVenom > 1) outputText("s");
					outputText(" split");
					if (player.tailVenom === 1) outputText("s");
					
					player.tailVenom += 1; //Must be before next call, or the text displays the wrong number
					changes++;
					
					outputText(" apart, turning into a set of " + player.tailVenom + " tails!");
				}
			}
		}

		public function changeUnderbody(newType:int, customTone:Boolean = false, newTone:String = ""):void { //Change underbody type and tone. Default sets underbody to (fur/)skin tone if custom tone isn't set. Supports changing just tone if type is same.
			if (changes < changeLimit) {
				if (player.underBody.type !== newType) { //Changes underbody (and tone, if set)
					outputText("\n\nYou shift uncomfortably as a weird feeling comes over you. You glance down to investigate and immediately notice what's wrong. <b>Your underbody is now made of ");
					if (customTone == true) outputText("" + newTone +" ");
					
					if (newType === UNDER_BODY_TYPE_NONE) outputText("skin");
					else if (newType === UNDER_BODY_TYPE_LIZARD) outputText("lizard scales");
					else if (newType === UNDER_BODY_TYPE_DRAGON) outputText("dragon scales");
					else if (newType === UNDER_BODY_TYPE_NAGA) outputText("snake scales");
					else if (newType === UNDER_BODY_TYPE_FUR) outputText("fur");
					else if (newType === UNDER_BODY_TYPE_WOOL) outputText("wool");
					else outputText("!!ERROR!! Underbody type not found! Report this bug immediately!");
					
					outputText("!</b>");
					
					player.underBody.type = newType;
					if (customTone == false) { //No custom tone, use default values
						if (player.isFurry()) { //Fur/wool colour takes importance
							player.underBody.skin.tone = player.furColor;
						}
						else { //Set to skin color
							player.underBody.skin.tone = player.skinTone;
						}
					}
					else { //Set to custom tone
						player.underBody.skin.tone = newTone;
					}
					changes++;
				}
				
				else if (customTone == true && player.underBody.type === newType) { //Change tone to custom
					outputText("\n\nYou shift uncomfortably as a weird feeling comes over you. You glance down to investigate and immediately notice what's wrong. <b>Your underbody is now colored " + newTone + "!</b>");
					player.underBody.skin.tone = newTone;
					changes++;
				}
			}
		}

		public function changeLegs(newLegs:int, newLegCount:Number = 2):void { //Changes legs and how many.
			if (changes < changeLimit && player.lowerBody !== newLegs) {
				outputText("\n\nPain suddenly shoots through your lower body and you take a stumble as horrific pain surges through you. You curl up and look down at yourself in time to watch as your body twists into ");
				
				if (player.legCount !== newLegCount) {
					if (newLegCount === 1) outputText("a ");
					else if (newLegCount === 2) outputText("two ");
					else if (newLegCount === 4) outputText("four ");
					else if (newLegCount === 8) outputText("eight "); //Damn spiders
					else outputText("several "); //No idea when this would be used, but just in case!
				}
				
				else if (player.legCount === newLegCount && newLegCount === 1) outputText("a "); //For Naga/goo/etc
				
				if (newLegs === LOWER_BODY_TYPE_HUMAN) outputText("human ");
				else if (newLegs === LOWER_BODY_TYPE_HOOFED) outputText("hoofed ");
				else if (newLegs === LOWER_BODY_TYPE_DOG) outputText("dog-like ");
				else if (newLegs === LOWER_BODY_TYPE_NAGA) outputText("Naga ");
				else if (newLegs === LOWER_BODY_TYPE_DEMONIC_HIGH_HEELS) outputText("demonic high-heeled ");
				else if (newLegs === LOWER_BODY_TYPE_DEMONIC_CLAWS) outputText("demonic clawed ");
				else if (newLegs === LOWER_BODY_TYPE_BEE) outputText("fuzzy, chitin-covered bee ");
				else if (newLegs === LOWER_BODY_TYPE_GOO) outputText("gooey ");
				else if (newLegs === LOWER_BODY_TYPE_CAT) outputText("cat-like ");
				else if (newLegs === LOWER_BODY_TYPE_LIZARD) outputText("lizard-like ");
				else if (newLegs === LOWER_BODY_TYPE_PONY) outputText("pony-hoofed ");
				else if (newLegs === LOWER_BODY_TYPE_BUNNY) outputText("bunny ");
				else if (newLegs === LOWER_BODY_TYPE_HARPY) outputText("avian-esque ");
				else if (newLegs === LOWER_BODY_TYPE_KANGAROO) outputText("kangaroo-like ");
				else if (newLegs === LOWER_BODY_TYPE_CHITINOUS_SPIDER_LEGS) outputText("chitinous spider ");
				else if (newLegs === LOWER_BODY_TYPE_DRIDER_LOWER_BODY) outputText("Drider-like ");
				else if (newLegs === LOWER_BODY_TYPE_FOX) outputText("fox-like ");
				else if (newLegs === LOWER_BODY_TYPE_DRAGON) outputText("dragon-like ");
				else if (newLegs === LOWER_BODY_TYPE_RACCOON) outputText("raccoon-like ");
				else if (newLegs === LOWER_BODY_TYPE_FERRET) outputText("ferret-like ");
				else if (newLegs === LOWER_BODY_TYPE_CLOVEN_HOOFED) outputText("cloven hoofed ");
				else if (newLegs === LOWER_BODY_TYPE_ECHIDNA) outputText("echidna-like ");
				else if (newLegs === LOWER_BODY_TYPE_SALAMANDER) outputText("leathery salamander ");
				else if (newLegs === LOWER_BODY_TYPE_WOLF) outputText("strong, wolf-like ");
				else if (newLegs === LOWER_BODY_TYPE_IMP) outputText("stubby imp ");
				
				else outputText("<b>ERROR! Lower body type not found! Please report this bug immediately!</b>");
				if (newLegCount === 4) outputText("legs, your spine reshaping as you gain an animalistic lower half."); //Avoided saying taur in case we have a four-legged non-taur
				else if (newLegCount === 8 || newLegs === LOWER_BODY_TYPE_DRIDER_LOWER_BODY) outputText("legs, complete with the abdomen of one!");
				else if (newLegCount === 1) outputText("lower half, devoid of any definable legs.");
				else outputText("legs.");
				
				outputText(" <b>You have a new lower body!</b>");
				
				player.lowerBody = newLegs;
				player.legCount = newLegCount;
				changes++;
			}
		}

		public function changeBreasts(sizeIsIncreasing:Boolean = true):void { //Enlarge/shrink breasts. Turn boolean false to decrease size. 1/15 chance of crit (x3) change.
			var crit:Boolean;
			if (rand(15) === 0) crit = true;
			else crit = false;
			
			if (changes < changeLimit) {
				if (sizeIsIncreasing == true) {
					if (crit == true) player.breastRows[0].breastRating += 3;
					else player.breastRows[0].breastRating ++;
					
					outputText("\n\nYou heave your chest as it suddenly feels ");
					if (crit == true) outputText("much ");
					outputText("heavier. You do a quick measure and determine your breasts are now " + player.breastCup(0) + "s.");
				}
				else if (sizeIsIncreasing == false && player.breastRows[0].breastRating > 0) { //Don't shrink flats!
					if (crit == true) player.breastRows[0].breastRating -= 3;
					else player.breastRows[0].breastRating --;
					//If size goes below 0...
					if (player.breastRows[0].breastRating < 0) player.breastRows[0].breastRating = 0;
					
					outputText("\n\nYou take a deep breath as your chest suddenly feels ");
					if (crit == true) outputText("much ");
					outputText("lighter. You do a quick measure and determine your breasts are now " + player.breastCup(0) + "s.");
				}
			}
		}

		public function changeBreastRows(maxRows:int, newRowSize:Number = 2, maxBreastSize:Number = 4):void { //Create/remove breast rows, based on if maxRows is hit or not. newRowSize declares size of new row being created. maxBreastSize used to shrink breasts if have all rows allowed and size is over limit
			//Add breast row
			if (player.breastRows.length > 0 && player.breastRows.length <= maxRows && changes < changeLimit) {
				if (player.breastRows[0].breastRating > 0) {
					if (player.breastRows.length < maxRows) {
						player.createBreastRow();
						//Store temp to the index of the newest row
						var temp:int = player.breastRows.length - 1;
						//Primary breasts are too small to grow a new row, so they get bigger first
						if (player.breastRows[0].breastRating <= player.breastRows.length || player.breastRows[0].breastRating <= newRowSize) {
							outputText("\n\nYour " + player.breastDescript(0) + " feel constrained and painful against your top as they grow larger by the moment, finally stopping as they reach ");
							player.breastRows[0].breastRating += 1;
							outputText(player.breastCup(0) + " size.");
							player.removeBreastRow(temp, 1); //Remove new row, since you didn't grow one
							changes++;
						}
						//Had 1 qualifying row to start
						else if (player.breastRows[0].breastRating >= player.breastRows.length && player.breastRows.length === 2 && changes < changeLimit) {
							player.breastRows[temp].breastRating = newRowSize;
							outputText("\n\nA second set of breasts bulges forth under your current pair, stopping as they reach " + player.breastCup(temp) + "s.");
							outputText(" A nub grows on the summit of each new breast, becoming a nipple.");
							player.breastRows[temp].breasts = 2;
							player.nippleLength = 0.25;
							changes++;
						}
						//Many breast rows, primary qualifies
						else if (player.breastRows.length > 2 && player.breastRows[0].breastRating > player.breastRows.length && changes < changeLimit) {
							player.breastRows[temp].breastRating = newRowSize;
							outputText("\n\nYour abdomen tingles and twitches as a new row of " + player.breastCup(temp) + " " + player.breastDescript(temp) + " sprouts below your others.");
							outputText(" A nub grows on the summit of each new breast, becoming a nipple.");
							player.breastRows[temp].breasts = 2;
							player.nippleLength = 0.25;
							changes++;
						}
					}
					//If already has max breasts
					else {
						//Check for size mismatches, and move closer to spec
						temp = player.breastRows.length;
						temp2 = 0;
						var evened: Boolean = false;
						//Check each row, and if the row above or below it is
						while (temp > 1 && temp2 === 0) {
							temp--;
							if (player.breastRows[temp].breastRating + 1 < player.breastRows[temp - 1].breastRating) {
								if (!evened) {
									evened = true;
									outputText("\n");
								}
								outputText("\nYour ");
								if (temp === 0) outputText("first ");
								if (temp === 1) outputText("second ");
								if (temp === 2) outputText("third ");
								if (temp === 3) outputText("fourth ");
								if (temp > 3) outputText("lowest ");
								outputText("row of " + player.breastDescript(temp) + " grows larger, as if jealous of the jiggling flesh above.");
								temp2 = (player.breastRows[temp - 1].breastRating) - player.breastRows[temp].breastRating - 1;
								if (temp2 > maxRows) temp2 = maxRows;
								if (temp2 < 1) temp2 = 1;
								player.breastRows[temp].breastRating += temp2;
							}
						}
					}
				}
			}
			//Remove breast rows if over limit
			else if (changes < changeLimit && player.bRows() > maxRows) {
				outputText("\n\nYou stumble back when your center of balance shifts, and though you adjust before you can fall over, you're left to watch in awe as your bottom-most " + player.breastDescript(player.breastRows.length - 1) + " shrink down, disappearing completely into your ");
				if (player.bRows() >= 3) outputText("abdomen");
				else outputText("chest");
				outputText(". The " + player.nippleDescript(player.breastRows.length - 1) + "s even fade until nothing but ");
				if (player.hasFur()) outputText(player.hairColor + " " + player.skinDesc);
				else outputText(player.skinTone + " " + player.skinDesc);
				outputText(" remains. <b>You've lost a row of breasts!</b>");
				player.removeBreastRow(player.breastRows.length - 1, 1);
				changes++;
			}
			//Grow breasts if has vagina and has no breasts/nips
			else if (player.hasVagina() && player.bRows() === 0 && player.breastRows[0].breastRating === 0 && player.nippleLength === 0 && changes < changeLimit) {
				player.createBreastRow();
				player.breastRows[0].breastRating = newRowSize;
				player.breastRows[0].breasts = 2;
				player.nippleLength = 0.25;
				changes++;
				outputText("\n\nYour chest tingles uncomfortably as your center of balance shifts. <b>You now have a pair of " + player.breastCup(0) + " breasts.</b>");
				outputText(" A nub grows on the summit of each breast, becoming a new nipple.");
			}
			//Shrink breasts if over size limit
			else if (changes < changeLimit) {
				temp2 = 0;
				temp3 = 0;
				//Determine if shrinking is required
				if (player.biggestTitSize() > maxBreastSize) temp2 = maxBreastSize;
				if (temp2 > 0) {
					//temp3 stores how many rows are changed
					temp3 = 0;
					for (var k: Number = 0; k < player.breastRows.length; k++) {
						//If this row is over threshhold
						if (player.breastRows[k].breastRating > temp2) {
							//Big change
							if (player.breastRows[k].breastRating > 10) {
								player.breastRows[k].breastRating -= 2 + rand(3);
								if (temp3 === 0) outputText("\n\nThe " + player.breastDescript(0) + " on your chest wobble for a second, then tighten up, losing several cup-sizes in the process!");
								else outputText(" The change moves down to your " + num2Text2(k + 1) + " row of " + player.breastDescript(0) + ". They shrink greatly, losing a couple cup-sizes.");
							}
							//Small change
							else {
								player.breastRows[k].breastRating -= 1;
								if (temp3 === 0) outputText("\n\nAll at once, your sense of gravity shifts. Your back feels a sense of relief, and it takes you a moment to realize your " + player.breastDescript(k) + " have shrunk!");
								else outputText(" Your " + num2Text2(k + 1) + " row of " + player.breastDescript(k) + " gives a tiny jiggle as it shrinks, losing some off its mass.");
							}
							//Increment changed rows
							temp3++;
						}
					}
				}
				//Count shrinking
				if (temp3 > 0) changes++;
			}
		}

		public function changeNipples(maxChangeAmount:Number, sizeIsIncreasing:Boolean = true, maxPerBreast:Number = 1, removeBlackNipples:Boolean = true):void { //Change nipple size/count. maxChangeAmount is how high rand() will be. maxPerBreast is how many nipples per breast you want. removeBlackNipples removes black nipples if true, and if PC has them.
			if (changes < changeLimit) {
				var changeAmount:Number = (rand(maxChangeAmount) + 0.1);
				outputText("\n\nYour nipples suddenly feel sore, and you check your chest only to find that they've ");
					if (sizeIsIncreasing == true) {
						outputText("grown!");
						player.nippleLength += changeAmount;
					}
					else {
						outputText("shrunk!");
						player.nippleLength -= changeAmount;
					}
				
				if (removeBlackNipples == true && player.hasStatusEffect(StatusEffects.BlackNipples)) {
					outputText(" You also notice that they've lost their black color.");
					player.removeStatusEffect(StatusEffects.BlackNipples);
				}
				
				if (player.breastRows[0].nipplesPerBreast > maxPerBreast) {
					outputText(" Furthermore, you've lost ");
					if (maxPerBreast === 1) outputText("all ");
					else outputText("some ");
					outputText("of your extra nipples!");
					player.breastRows[0].nipplesPerBreast = maxPerBreast;
				}
			
			changes++;
			}
		}

		public function changeAss(wetnessGoal:Number = 0, loosenessGoal:Number = 0, onlyChangeWetness:Boolean = false, onlyChangeLooseness:Boolean = false):void { //Change wetness and looseness, or just one. Default changes both. Default goals are normal wetness and tight looseness.
			if (changes < changeLimit && (player.ass.analWetness !== wetnessGoal || player.ass.analLooseness !== loosenessGoal)) {
				if (onlyChangeWetness == true) { //Only changes wetness. Force-ends the code, even if onlyChangeLooseness is on.
					if (player.ass.analWetness < wetnessGoal) { //Increases wetness
						outputText("\n\nYour eyes widen in shock as you feel oily moisture bead out of your [asshole]. Your asshole has become wetter.");
						player.ass.analWetness++;
						changes++;
					}
					else { //Decreases wetness
						outputText("\n\nYou feel a tightening up in your colon and your [asshole] sucks into itself. You feel sharp pain at first, but thankfully, it fades. Your ass seems to have dried up some.");
						player.ass.analWetness--;
						changes++;
					}
				}
				else if (onlyChangeLooseness == true) { //Only changes looseness. Force-ends the code when done.
					if (player.ass.analLooseness < loosenessGoal) { //Increases looseness
						outputText("\n\nA strange feeling passes through your asshole as it seems to loosen up, relaxing and accomodating itself for bigger insertions.");
						player.ass.analLooseness++;
						changes++;
					}
					else { //Decreases looseness
						outputText("\n\nYou feel a tightening up in your colon and your [asshole] sucks into itself. You feel sharp pain at first, but thankfully, it fades. Your ass seems to have tightened up.");
						player.ass.analLooseness--;
						changes++;
					}
				}
				else { //Change both looseness and wetness.
					var wetChange:Boolean = false;
					if (player.ass.analWetness !== wetnessGoal) { //Handles wetness changes, if needed
						if (player.ass.analWetness < wetnessGoal) { //Increases wetness
							outputText("\n\nYour eyes widen in shock as you feel oily moisture bead out of your [asshole]. Your asshole has become wetter. ");
							player.ass.analWetness++;
						}
						else { //Decreases wetness
							outputText("\n\nYou feel a tightening up in your colon and your [asshole] sucks into itself. You feel sharp pain at first, but thankfully, it fades. Your ass seems to have dried up. ");
							player.ass.analWetness--;
						}
						wetChange = true;
					}
					if (player.ass.analLooseness !== loosenessGoal) {
						if (wetChange == true) outputText("It also ");
						else outputText("A strange feeling passes through your asshole as it seems to ");
						if (player.ass.analLooseness < loosenessGoal) { //Increases looseness
							outputText("loosen");
							if (wetChange == true) outputText("s");
							outputText(" up.");
							player.ass.analLooseness++;
							changes++;
						}
						else { //Decreases looseness
							outputText("tighten");
							if (wetChange == true) outputText("s");
							outputText(" up.");
							player.ass.analLooseness--;
							changes++;
						}
					}
					changes++;
				}
			}
		}
	
		public function changeVag(wetnessGoal:Number = 1, loosenessGoal:Number = 0, onlyChangeWetness:Boolean = false, onlyChangeLooseness:Boolean = false):void { //Works same as changeAss
			if (changes < changeLimit && player.hasVagina() && (player.vaginas[0].vaginalWetness !== wetnessGoal || player.vaginas[0].vaginalLooseness !== loosenessGoal)) {
				if (onlyChangeWetness == true) { //Only changes wetness. Force-ends the code, even if onlyChangeLooseness is on.
					if (player.vaginas[0].vaginalWetness < wetnessGoal) { //Increases wetness
						outputText("\n\nBeads of lubricant drip from your [cunt] as it seems to get wetter.");
						player.vaginas[0].vaginalWetness++;
						changes++;
					}
					else { //Decreases wetness
						outputText("\n\nYour thighs seem strangely dry. Your [cunt] isn't as wet anymore.");
						player.vaginas[0].vaginalWetness--;
						changes++;
					}
				}
				else if (onlyChangeLooseness == true) { //Only changes looseness. Force-ends the code when done.
					outputText("\n\nA strange feeling passes through your [cunt] as it seems to get ");
					if (player.vaginas[0].vaginalLooseness < loosenessGoal) { //Increases looseness
						outputText("looser.");
						player.vaginas[0].vaginalLooseness++;
						changes++;
					}
					else { //Decreases looseness
						outputText("tighter.");
						player.vaginas[0].vaginalLooseness--;
						changes++;
					}
				}
				else { //Change both looseness and wetness.
					var wetChange:Boolean = false;
					if (player.vaginas[0].vaginalWetness !== wetnessGoal) { //Handles wetness changes, if needed
						if (player.vaginas[0].vaginalWetness < wetnessGoal) { //Increases wetness
							outputText("\n\nBeads of lubricant drip from your [cunt] as it seems to get wetter.");
							player.vaginas[0].vaginalWetness++;
						}
						else { //Decreases wetness
							outputText("\n\nYour thighs seem strangely dry. Your [cunt] isn't as wet anymore.");
							player.vaginas[0].vaginalWetness--;
						}
						wetChange = true;
					}
					if (player.vaginas[0].vaginalLooseness !== loosenessGoal) {
						outputText(" A strange feeling ");
						if (wetChange == true) outputText("also ");
						outputText("passes through you as your [pussy] seems to get ");
						if (player.vaginas[0].vaginalLooseness < loosenessGoal) { //Increases looseness
							outputText("looser.");
							player.vaginas[0].vaginalLooseness++;
							changes++;
						}
						else { //Decreases looseness
							outputText("tighter.");
							player.vaginas[0].vaginalLooseness--;
							changes++;
						}
					}
					changes++;
				}
			}
		}
	
		public function changeVagCount(growVag:Boolean):void { //Either grows (if has none) or removes (if has) a vagina, based on the Boolean
			if (changes < changeLimit) {
				if (player.hasVagina() && growVag == false) { //Removes vag
					outputText("\n\nYour vagina clenches in pain, doubling you over. You slip a hand down to check on it, only to feel the slit growing smaller and smaller until it disappears, taking your clit with it! <b>Your vagina is gone!</b>");
					player.setClitLength(.5);
					player.removeVagina();
					changes++;
				}
				else if (!player.hasVagina() && growVag == true) { //Grows vag
					player.createVagina();
					outputText("\n\nAn itching starts in your crotch and spreads vertically. You reach down and discover an opening. You have grown a <b>new " + player.vaginaDescript(0) + "</b>!");
					changes++;
				}
			}
		}

		public function changeBalls(sizeGoal:Number, createBalls:Boolean = true, changeCount:Boolean = false, allowUniball:Boolean = false, allowQuadBalls:Boolean = false, createUniball:Boolean = false, createQuadBalls:Boolean = false):void { //Increase/decrease size to set goal, create balls if have none, enable messing with uni/quad balls, remove uni/quad balls (if has), create a uni/quad balls (if has balls)
			if (changes < changeLimit) {
				if (createBalls == true && player.balls === 0) { //Grow balls, if has none + creation enabled
					outputText("\n\nIncredible pain scythes through your crotch, doubling you over. You stagger around, struggling to pull open your " + player.armorName + ". In shock, you barely register the sight before your eyes: <b>You have balls!</b>");
					player.balls = 2;
					player.ballSize = sizeGoal;
					changes++;
				}
				else if (player.balls > 0 && player.ballSize !== sizeGoal) { //Change size
					if (player.ballSize < sizeGoal) { //Increase sie
						if (player.ballSize <= 2) outputText("\n\nA flash of warmth passes through you and a sudden weight develops in your groin. You pause to examine the changes and your roving fingers discover your " + player.simpleBallsDescript() + " have grown larger than a human's.");
						else outputText("\n\nA sudden onset of heat envelops your groin, focusing on your " + player.sackDescript() + ". Walking becomes difficult as you discover your " + player.simpleBallsDescript() + " have enlarged again.");
						player.ballSize++;
						if (player.ballSize > 6) player.ballSize -= .5; //Inrease slower the larger they are
						changes++;
					}
					else { //Decrease size
						if (player.ballSize < 4) { //Small change
							outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose about a half of an inch of their diameter.");
							player.ballSize -= .5; //Decrease slower the smaller they are.
						}
						else if (player.ballSize < 10) { //Normal change
							outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose about an inch of their diameter.");
							player.ballSize--;
						}
						else if (player.ballSize < 25) { //Large change
							outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose a few inches of their diameter. Wow, it feels so much easier to move!");
							player.ballSize -= (2 + rand(3));
						}
						else { //Huge change
							outputText("\n\nRelief washes through your groin as your " + player.ballsDescript() + " lose at least six inches of diameter. Wow, it feels so much easier to move!");
							player.ballSize -= (6 + rand(3));
						}
						changes++;
					}
				}
				else if (changeCount == true) {
					if (allowQuadBalls == false && player.balls > 2) { //Remove quad balls
						outputText("\n\nYour scrotum slowly shrinks until they seem to have reached a normal size. <b>Your extra balls have fused together, leaving you with only two.</b>");
						player.balls = 2;
						if (player.ballSize > sizeGoal) player.ballSize = sizeGoal;
						changes++;
					}
					else if (allowQuadBalls == true && createQuadBalls == true && player.balls !== 4) { //Create quad balls
						outputText("\n\nIncredible pain scythes through your crotch, doubling you over. You stagger around, struggling to pull open your " + player.armorName + ". In shock, you barely register the sight before your eyes: <b>You have four balls.</b>");
						player.balls = 4;
						if (player.ballSize < sizeGoal) player.ballSize = sizeGoal;
						changes++;
					}
					
					if (allowUniball == false && (player.balls === 1 || player.hasStatusEffect(StatusEffects.Uniball))) { //Remove uniball
						outputText("\n\nYour scrotum slowly expands, and you feel a great pressure release in your groin. <b>Your uniball has split apart, leaving you with a pair of balls.</b>");
						player.removeStatusEffect(StatusEffects.Uniball);
						if (player.balls !== 2) player.balls = 2; //Not sure if Uniball sets balls at 1 so here's a just in case.
						player.ballSize++;
					}
					else if (allowUniball == true && createUniball == true && (player.balls !== 1 || !player.hasStatusEffect(StatusEffects.Uniball)) && player.ballSize === 1) { //Create uniball
						outputText("\n\nYou whimper as your balls tighten and shrink. Your eyes widen when you feel the gentle weight of your testicles pushing against the top of your [hips], and a few hesitant swings of your rear confirm what you can feel - you've tightened your balls up so much they no longer hang beneath you, but press perkily upwards. Heat ringing your ears, you explore your new sack with a careful hand. You are deeply grateful you apparently haven't reversed puberty, but you discover that though you still have " + num2Text(player.balls) + "-- your balls just now look and feel like one. One cute, tight little sissy parcel, and its warm, insistent pressure upwards upon the joining of your thighs act as a never-ending reminder of it.");
						player.createStatusEffect(StatusEffects.Uniball, 0, 0, 0, 0);
					}
				}
			}
		}

		public function changePenisCount(growPenis:Boolean, newType:CockTypesEnum = null, newLength:Number = 6, newThickness:Number = 1, newKnot:Number = 1):void { //Create cocks (up to 10 cocks), or remove one. If removing, don't worry about any variables but growPenis (which should be false). If creating, worry.
			if (changes < changeLimit) {
				if (growPenis == true && player.cocks.length < 10) {
					player.createCock(newLength, newThickness, newType);
					var newCockIndex:Number = (player.cocks.length - 1);
					if (newKnot > 1) player.cocks[newCockIndex].knotMultiplier = newKnot;
					outputText("\n\nYou feel a sudden stabbing pain in your crotch and bend over, moaning in agony. Your hands clasp protectively over the surface-- which is swelling in an alarming fashion under your fingers! Stripping off your clothes, you are presented with the shocking site of once-smooth flesh swelling and flowing like self-animate clay, resculpting itself into the form of male genitalia! When the pain dies down, you are the proud owner of a new [cock].");
					changes++;
				}
				else {
					player.killCocks(1);
					changes++;
				}
			}
		}

		public function changePenisType(newType:CockTypesEnum, knotMultiplier:Number = 1):void { //Change type and apply knot if necessary
			var typeCocks:Number = player.countCocksOfType(newType);
			if (changes < changeLimit && player.hasCock()) {
				if (typeCocks < player.cocks.length) {
					//Select first cock not of type
					temp = player.cocks.length;
					temp2 = 0;
					while (temp > 0 && temp2 === 0) {
						temp--;
						//Store cock index if not a typeCock and exit loop
						if (player.cocks[temp].cockType !== newType) {
							temp3 = temp;
							//kicking out of the loop
							temp2 = 1000;
						}
					}
					outputText("\n\nYour " + player.cockDescript(temp3) + " trembles, resizing and reshaping itself into a new cock");
					if (knotMultiplier > 1) outputText(" with a fat knot at the base");
					outputText(". <b>You now have a ");
					if (newType == CockTypesEnum.HUMAN) outputText("human");
					else if (newType == CockTypesEnum.HORSE) outputText("horse");
					else if (newType == CockTypesEnum.DOG) outputText("dog");
					else if (newType == CockTypesEnum.DEMON) outputText("demon");
					else if (newType == CockTypesEnum.TENTACLE) outputText("tentacle");
					else if (newType == CockTypesEnum.CAT) outputText("cat");
					else if (newType == CockTypesEnum.LIZARD) outputText("lizard");
					else if (newType == CockTypesEnum.ANEMONE) outputText("anemone");
					else if (newType == CockTypesEnum.KANGAROO) outputText("kangaroo");
					else if (newType == CockTypesEnum.DRAGON) outputText("dragon");
					else if (newType == CockTypesEnum.DISPLACER) outputText("Coeurl");
					else if (newType == CockTypesEnum.FOX) outputText("fox");
					else if (newType == CockTypesEnum.BEE) outputText("bee");
					else if (newType == CockTypesEnum.PIG) outputText("pig");
					else if (newType == CockTypesEnum.AVIAN) outputText("avian");
					else if (newType == CockTypesEnum.RHINO) outputText("rhino");
					else if (newType == CockTypesEnum.ECHIDNA) outputText("echidna");
					else if (newType == CockTypesEnum.WOLF) outputText("wolf");
					else outputText("!!ERROR!! Cock type not found! Report this bug immediately.");
					outputText(" cock!</b>");
					if (newType !== CockTypesEnum.HORSE) {
						if (player.cocks[temp3].cockType === CockTypesEnum.HORSE) { //Horses changes
							if (player.cocks[temp3].cockLength > 6) player.cocks[temp3].cockLength -= 2;
							else player.cocks[temp3].cockLength -= .5;
							player.cocks[temp3].cockThickness += .5;
						}
					}
					else { //Is horse! let's boost up its size, shall we?
						if (player.cocks[temp3].cockLength < 6) player.cocks[temp3].cockLength += 2;
						else player.cocks[temp3].cockLength += .5;
						player.cocks[temp3].cockThickness -= .5;
					}
					player.cocks[temp3].cockType = newType;
					if (knotMultiplier > 1) player.cocks[temp3].knotMultiplier = knotMultiplier;
					changes++;
				}
			}
		}

		public function changePenisSize(sizeIsIncreasing:Boolean, maxLengthChange:Number, maxThicknessChange:Number, maxKnotChange:Number = 1):void { //Used to change penis length, thickness, and knot. If you don't want a specific field to be changed, set its value to 0. Or keep it at 1, in the case of knot change. Either works. Lowest changes are 0.1
			var lengthChange:Number = (rand(maxLengthChange) + 0.1);
			var thicknessChange:Number = (rand(maxThicknessChange) + 0.1);
			var knotChange:Number = (rand(maxKnotChange) + 0.1);
			if (changes < changeLimit) { //if else unused due to all three being possible to run at once-- they aren't exclusive.
				outputText("\n\n");
				
				if (maxLengthChange > 0) { //Length changes
					var x:Number = player.shortestCockIndex();
					var x2:Number = player.biggestCockIndex();
					if (sizeIsIncreasing == true) { //Get longer
						outputText("Your " + player.cockDescriptShort(x) +  " suddenly grows inhumanly hard, and begins to pour out new length. ");
						if (lengthChange < .5) outputText(" It stops almost as soon as it starts, growing only a tiny bit longer. ");
						if (lengthChange >= .5 && lengthChange < 1) outputText(" It grows slowly, stopping after roughly half an inch of growth. ");
						if (lengthChange >= 1 && lengthChange <= 2) outputText(" The sensation is incredible as more than an inch of lengthened dick-flesh grows in. ");
						if (lengthChange > 2) outputText(" You smile and idly stroke your lengthening " + player.cockDescript(x) + " as a few more inches sprout. ");
						outputText("It then comes to a stop and relaxes, leaving you to admire your new size. ");
						player.cocks[x].cockLength += lengthChange;
					}
					else { //Get shorter
						outputText("A pinching sensation racks the entire length of your " + player.cockDescript(x2) + ".  Within moments, the sensation is gone, but it appears to have become smaller. ");
						player.cocks[x2].cockLength -= lengthChange;
					}
				}
				
				if (maxThicknessChange > 0) { //Thickness changes
					var y:Number = player.thinnestCockIndex();
					var y2:Number = player.thickestCock(); //Why isn't that called Index...
					if (sizeIsIncreasing == true) { //Get thicker
						if (thicknessChange <= .5) outputText("Your cock feels swollen and heavy. With a firm, but gentle, squeeze, you confirm your suspicions. It's definitely thicker. ");
						else if (thicknessChange > .5 && thicknessChange < 1) outputText("Your cock seems to swell up, feeling heavier. You look down and watch it growing fatter as it thickens. ");
						else if (thicknessChange >= 1) outputText("Your cock spreads rapidly, swelling an inch or more in girth, making it feel fat and floppy. ");
						player.cocks[y].cockThickness += thicknessChange;
					}
					else { //Get thinner
						outputText("You flinch and gasp as your cock suddenly becomes incredibly sensitive and retracts into your body. Anxiously you pull down your underclothes to examine your nether regions. To your relief, it is still present, and as you touch it, the sensitivity fades, however it seems to have become thinner.");
						player.cocks[y2].cockThickness -= thicknessChange;
					}
				}
				
				if (maxKnotChange > 1) { //Knot changes
					if (sizeIsIncreasing == true) { //Grow knot
						outputText("Your cock expands at the base, growing a ");
						if (player.hasKnot()) outputText("larger ");
						outputText("knot.");
						player.cocks[0].knotMultiplier += knotChange;
					}
					else if (player.hasKnot()) { //Shrink knot, so long as you actually have one!
						outputText("Your cock shrinks at the base, losing some of its knot size.");
						player.cocks[0].knotMultiplier -= knotChange;
					}
				}
			
				changes++;
			}
		}

	}
}
