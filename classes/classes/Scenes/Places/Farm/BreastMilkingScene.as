package classes.Scenes.Places.Farm 
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.Scenes.NPCs.MarbleScene;
	import classes.Scenes.Places.Farm.*;
	use namespace kGAMECLASS;
	/**
	 * ...
	 * @author losdivo
	 */
	
	 
	// 1. There should be no scenes for 
	// 
	public class BreastMilkingScene extends AbstractFarmContent 
	{
		
		public function BreastMilkingScene() {
			
		}
		
		private function formattedNumber(x:Number) : String {
			var n:int = x * 100;
			var d0:int = n / 100;
			var d1:int = (n - d0 * 100) / 10;
			var d2:int = (n - d0 * 100 - d1 * 10);
			if (d1 == 0 && d2 == 0) return d0.toString();
			if (d2 == 0) return d0.toString() + "." + d1.toString();
			return d0.toString() + "." + d1.toString() + d2.toString();
		}
		
		private function outputMilkingInfo() : void {
			outputText("<i><b>Milking:</b>\n");
			outputText("LactationQ: " + formattedNumber(player.lactationQ()) + "\n");
			outputText("Lactation endurance: " + formattedNumber(player.statusEffectv1(StatusEffects.LactationEndurance)) + "\n");
			
			for (var counter:int = 0; counter < player.breastRows.length; counter ++ ){
				outputText("Breast row " + counter + ":\n");
				outputText("\tsize " + formattedNumber(player.breastRows[counter].breastRating) + "\n");
				outputText("\tmult " + formattedNumber(player.breastRows[counter].lactationMultiplier)  + "\n");
			}
			//outputText("<i>biggestTitSize: " + player.biggestTitSize() + "</i>\n");
			//outputText("<i>averageLactation: " + player.averageLactation() + "</i>\n");
			outputText("</i>\n");
		}
		
		private function prepareForMilking():void {
			
			//First time barn entrance
			outputText("The barn looms tall ahead of you as you step into its shadow.  ", false);
			if (player.findStatusEffect(StatusEffects.BreastsMilked) < 0) {
				if (player.cor < 50) outputText("You shiver nervously when you step inside.", false);
				else outputText("You smile eagerly as you walk inside.", false);
				outputText("  The barn is filled with the earthy smells of earth, wood, and grease.  It's clean for the most part, though the floor is just packed dirt and the stalls look old and well-used.  A bank of machinery along the wall thrums and pulses as if it's a living creature.  Hoses and cables run from it in a dozen places, disappearing into the walls.   There is even a set of stout wooden doorways along the west wall.  That must be where the farm's intelligent denizens stay.  You notice each of the stalls have name-plates on them, and there is even one that says " + player.short + ".  It must be for you.\n\n", false);
			}
			//Repeat
			else {
				outputText("You walk over to the barn, eagerly anticipating the opportunity to get milked.", false);
				//If ilk withdrawl or high lactation no dicks
				if (player.findStatusEffect(StatusEffects.LactationReduction) >= 0 && player.totalCocks() == 0) outputText("  Your " + player.nippleDescript(0) + "s are engorged and ready to be taken care of.", false);
				//If cocks
				else if (player.totalCocks() > 0) {
					outputText("  Your " + player.multiCockDescriptLight() + " erect", false);
					if (player.totalCocks() > 1) outputText("s", false);
					outputText(" and throb", false);
					if (player.totalCocks() == 1) outputText("s", false);
					outputText(" with desire.", false);
				}
				//If both
				else if (player.findStatusEffect(StatusEffects.LactationReduction) >= 0 && player.cockTotal() > 0) {
					outputText("  Your " + player.nippleDescript(0) + "s and " + player.multiCockDescriptLight() + " grow", false);
					outputText(" hard and ready of ", false);
					outputText("their", false);
					outputText(" own volition.", false);
				}
				outputText("  The doors part easily, and you breeze into your stall in a rush.\n\n", false);
			}
			//Step into harness – first time only
			if (player.findStatusEffect(StatusEffects.BreastsMilked) < 0) {
				outputText("A harness hangs limply in the stall, there to hold the occupant in place while they are milked of every last drop.  You exhale slowly and force yourself to step into it.  As you puzzle out the straps, it gets easier and easier to get the rest of the harness into place.  As you snap the last one into position, machinery whirs and pulls it tight, lifting you off the ground and suspending you, facedown.  The breast milk pumps pulse and vibrate on a tray below you, twitching slightly as you hear the machinery activate.\n\n", false);
			}
			//REPEAT
			else {
				outputText("You easily attach the harnesses and lift up into position, hearing the machinery activate automatically. ", false);
			}
			
		}
		private function titGrowthProbability(): Number {
			// Mapping 0 -> 0 and +inf -> 1 (approx 0.78)  using atan function
			var expect:Number = player.statusEffectv1(StatusEffects.LactationEndurance) * player.averageLactation() * 0.5;
			var probability:Number = Math.atan(expect) / (Math.PI / 2.0);
			trace("Expectation in " + expect + ", probability is " + probability);
			return 100 * probability;
			
		}
		
		public	function getMilked():void {

			clearOutput();
			
			outputMilkingInfo();
			
			prepareForMilking();
			
			var growTits:Boolean = false;
			growTits = (rand(100) < titGrowthProbability());
			
			// Application 
			var application:Number = rand(3);
			//Super huge nips scene
			if (player.nippleLength == 3 && rand(2) == 0) application = 3;
			//Apply
			if (player.findStatusEffect(StatusEffects.BreastsMilked) < 0 || application == 0) {
				if (player.findStatusEffect(StatusEffects.BreastsMilked) < 0) player.createStatusEffect(StatusEffects.BreastsMilked,0,0,0,0);
				outputText("You manage to grab the suction cups in spite of your constrictive bindings and pull them to your [nipples].  They latch on immediately, ");
				if (player.nippleLength <= 1.5) outputText("pulling each of your nipples entirely into the suction-tubes.  ");
				else outputText("struggling to fit around each of your nipples as they slide into the suction-tubes.  ");
				outputText("There is a mechanical lurching noise as the suction builds rapidly.  Your nipple swells out to " + int(player.nippleLength * 1.5 * 10) / 10 + " inches of length, turning purplish from the strain.");
				if (growTits) outputText("You can feel something welling up inside your [allbreasts], building as it moves towards your [nipples].");
				outputText("\n\n");
			}
			//Apply repeat alternate
			else if (application == 1) {
				outputText("You stretch down and grab onto the suction cups, pulling them up to your eager nipples.  They latch on, slapping tight against you as the vacuum pressure seals them tightly against your body.  You can feel your [nipples] pulling tight, nearly doubling in size from the intense pressure.", false);
				if (player.nippleLength >= 3) outputText("  They nearly burst the tubes designed to milk them by virtue of their sheer size.");
				if (growTits) outputText("  The sensitive flesh of your [allbreasts] fill with a burgeoning pressure that centers around the tubes connected to your nips.");
				outputText("\n\n");
			}
			//Version 3
			else if (application == 2) {
				outputText("Despite the tightness of your harness, you manage to reach down to grab the clear cups of the breast milker.  The cups twitch and move in your hands as you bring them up, ready to milk you.  You begin holding them against your " + player.nippleDescript(0) + "s and with a sudden lurch the suction pulls against you, pressing the breast-milker's cups tightly against your chest, stretching your [nipples] to nearly twice their normal length.");
				if (growTits) outputText("You feel a building pressure as the machine sucks you relentlessly, drawing your milk to the surface.");
				outputText("\n\n ");
			}
			//Version 4 huge nips
			if (application == 3) {
				outputText("In spite of the tightness of your harness, you collect the suction cups and bring them up to your huge nipples, letting the machine pull them into the tight cups with agonizing slowness.  In spite of the large size of your aureola, the machine slowly sucks you inside, the tightness serving only to arouse you further.  The suction pulls the walls of the nipple-tubes tight against your nipples, turning them purple as they swell up like dicks.");
				if (growTits) outputText("Drops of milk leak from the tips as your body lets your milk down, letting it flow through your imprisoned nipples towards its release.");
				outputText("\n\n ");
				dynStats("lus", 10);
			}
			if (growTits) player.growTits(0.2, 2, false, 1);
			
			
	
			//Milksplosion Texts
			//Lactation * breastSize x 10 (milkPerBreast) determines scene
			//< 50 small output
			//< 250 'good' output
			//< 750 'high' output
			//ELSE milk overload
			var milksplosion:Number = rand(3);
			if 		(player.lactationQ() == 0) 	{   // 	Imperceptible
				dynStats("lus", 5);
				milksplosion = rand(2);
				if (milksplosion == 0) {
					outputText("The milker goes on for the better part of an hour, but your [nipples] remain dry. The exercise slightly arouse you, and definitely makes you tougher. By the time the milker shuts off and the harness releases you, your breasts ache terribly.\n\n");
					dynStats("tou", 0.5);
				}
				if (milksplosion == 1) {
					outputText("The milker goes on for the better part of an hour, but your [nipples] remain dry. The exercise slightly arouse you, and definitely makes you stronger. By the time the milker shuts off and the harness releases you, your breasts ache terribly.\n\n");
					dynStats("str", 0.5);
				}
				
			}
			else if (player.lactationQ() < 50) 	{	//	Lightish (+15 lust)
				dynStats("lus", 15);
				if (milksplosion == 0) {
					outputText("A few drops of milk bud on the tips of your " + player.nippleDescript(0) + "s, growing larger as they roll down to the edge of the tube.  It feels as if a ", false);
					if (player.totalBreasts() == 2) outputText("pair", false);
					else if (player.totalBreasts() == 4) outputText("quartet", false);
					else outputText("group", false);
					outputText(" of internal floodgates are opening, and thin streams of milk erupt, spraying to the noisy suckling tubes.   The milk is sucked away before it can build up, leaving you to wonder just how much you're managing to produce.   The milking goes on for the better part of an hour, though you stop producing long before it's over.  By the time the milker shuts off and the harness releases you, your breasts ache terribly.\n\n");
				}
				else if (milksplosion == 1) {
					outputText("A tiny spurt of milk erupts from each of your [nipples] before the hungry machinery devours it, sucking it down the clear tubes that lead back to the Whitney's machinery.  You unconsciously moan from the pleasure, feeling more than a little turned on by the pulsing suckling feeling the devices provide.  You spray your milk out in tiny streams, emptying your [allbreasts] off their motherly fluids. An hour later your harness loosens, easing you to the floor as the milking-cups drop off your painfully sensitive [nipples].\n\n", false);
				}
				else if (milksplosion == 2) {
					outputText("The tips of your [nipples] swell for a moment before releasing tiny streams of milk into the suctioning cups.  It rapidly drains away, down the tubes towards the collection device.  The sensation is pleasurable and intense, but long before the machine finishes with you, your milk supply dries up.  The constant pulsing suckling does not abate, stretching and abusing your poor teats for the better part of an hour.  In spite of the pain and sensitivity, you enjoy it, but when the harness finally lowers yourself to the floor, you find yourself already anticipating the next session.\n\n");
				}
			}
			else if (player.lactationQ() < 250) { 	//	Medium (+30 lust)
				dynStats("lus", 30);
				//MEDIUMLICIOUS
				if (milksplosion == 0) {
					outputText("Drops of your milk roll down the edge of the milk-cups as you begin lactating into them.  Milk sprays in solid streams from your nipples, forming a puddle at the bottom of the cup as the machinery siphons it through the clear tube towards the reservoir.   You moan hotly as the milking progresses, emptying your [allbreasts] of their creamy cargo.  For an hour your world is reduced to the sensation of suction and release, though towards the end nothing is coming out but tiny milk-drops.  At long last the harness lowers you to the floor, letting the cups pop off your abused [nipples].  You feel a little bit sore and sensitive, but overwhelmingly aroused by the experience.\n\n");
				}
				////Medium 2
				if (milksplosion == 1) {
					outputText("A tight stream of milk erupts from your [nipples], pouring into the bottom of the hungry nipple-cups.  It pools there as the tubes work to suction it away.  They turn white and the machinery thrums as it works to keep up with you.  The tugging and releasing of the suction as you squirt out your milk is highly erotic, making you wriggle in the harness with sensual delight.  Unfortunately with all the straps you can't do anything about the heat in your groin.  After an hour of milking, when your output has dropped to barely a trickle, you're slowly lowered to the floor and released when the milking cycle completes.\n\n");
				}
				//Medium 3
				if (milksplosion == 2) {
					outputText("Fat drops of milk pour out of your [nipples] pooling in the milking-cups as the machine begins to extract your creamy breast-milk.   The milk flow begins streaming out of you it bursts of fluid as the machinery switches to a pulsating suction.  You groan happily as your [allbreasts] empty, relieving you of pent up pressure.   The feeling is enjoyable in more than just that way, and you feel yourself getting ");
					if (player.totalCocks() == 0) {
						if (player.hasVagina()) outputText("wet", false);
						else outputText("horny", false);
					}
					else {
						if (player.hasVagina()) outputText("wet and ", false);
						outputText("hard", false);
					}
					outputText(" from the sensation.  Over the next hour you're drained totally dry, until the only answer to the machine's effort is a tiny trickle of whiteness.  The harness gently lowers you to the ground and releases you, leaving you feeling sore.\n\n");
				}
			}
			else if (player.lactationQ() < 750) {	//High Output (+ 40 lust)
				dynStats("lus", 40);
				if (milksplosion == 0) {
					outputText("An eruption of milk floods the suction-tubes with a vortex of cream.  The machinery chugs loudly, struggling to keep up with the waves of fluid as your nipples continue to fountain into the receptacles.  You squeal in delight as your nipples get red and sensitive, but never slow in their production.  Writhing in the harness, you become more and more aroused by this milk-draining device until you feel as if you can bear it no longer.  When you get out, you'll NEED to get off.  After an hour of sexual torture, the suction cuts off and the harness releases.  The nipple-suckers drop off and spill your milk over the floor as droplets continue to leak from your over-productive chest.\n\n");
				}
				//High Output2
				if (milksplosion == 1) {
					outputText("Your [nipples] swell up like tiny balloons for a moment before they unleash a torrent of your milk.  The nipple-cylinders instantly flood to capacity, and the milking machinery chugs loudly as it tries to suck it all down the tubes, barely keeping up with you.  You pant and writhe in the harness, each pulse of milk sending a growing sensation of your warmth to your groin that makes you ");
					if (player.totalCocks() == 0) {
						if (player.hasVagina()) outputText("wet", false);
						else outputText("horny", false);
					}
					else {
						if (player.hasVagina()) outputText("wet and ", false);
						outputText("hard", false);
					}
					outputText(" with excitement.  The milking drags on for an hour, but your output only slows slightly, forcing the machinery to work at maximum capacity the entire time.  At last it ends, and the harnesses lower you to the ground.  The milk cups pop off, leaving your leaky tits to make a puddle on the floor.\n\n");
				}
				//High Output3
				if (milksplosion == 2) {
					outputText("Milk floods the milker's cups as your breasts respond to the mechanized suckling.   The machinery groans as it kicks into high gear, working hard to keep up with your prodigious production rate.  Your nipples tingle with happy little bursts of pleasure as they continue to pour out ever greater quantities of milk.  Arousal wells up, flushing your body with a reddish tint that's difficult to hide.  You wriggle in the harness, sweating profusely and trying to grind against something, anything, whatever it takes to get off.  The milking drags on for an hour, but your breasts keep pouring out milk the entire time.  When it ends, you're lowered to the floor and released.  The milk-tubes pop off, leaving you lying in a milk-puddle as your leaky teats continue to drip.\n\n", false);
				}
			}
			else {	//CRAZY OUTPUT1 (+60 lust)
				dynStats("lus", 60);
				milksplosion = rand(2);
				if (milksplosion == 0) {
					outputText("Your [nipples] twitch and pulse for but a moment, then unleash a torrent of milk, totally filling the tubes.  The machinery lurches, struggling to keep up as you flood the tubes.   An alarm starts blaring as milk begins leaking out around the edges – Whitney's machinery just can't keep up!  You can hear footsteps in the barn, and a pair of soft hands hold the cups against your chest.   The machinery is shut down, but another pair of hands begins massaging your [allbreasts], pumping wave after wave of milk through the tubes, unaided by the machinery.  You practically ");
					if (player.hasVagina()) outputText("cream yourself", false);
					else if (player.cockTotal()) outputText("jizz yourself", false);
					else outputText("orgasm", false);
					outputText(" from the attentions of your mysterious helper as the milking continues, so hot and horny that you try and wriggle in your harness to press against them.   After an hour of non-stop squeezing and spurting, your milking is over, and the hands release you.  The cups fall to the ground, and the harness lowers you to the ground.  By the time you can crane your head around, your helper has left.\n\n", false);
				}
				//CRAZY OUTPUT2
				else {
					outputText("Your body lets down its milk, flooding the tubes with creamy goodness.  Milk immediately begins leaking from the edges as the machine fails to keep up with the quantity of cream being released.   Alarms blare and soft footfalls fill the barn as help arrives.  You hear the clangs of metal on metal, and then the suction intensifies, nearly doubling, milking you HARD and draining you of your vast reservoir of milk.  Your nipples ache with the strange pleasure of it, leaving you grunting and bucking against your restraints, desperate for release, but you just can't get the stimulation you need.  For an hour you're teased like that, pumped of your milk until the machinery shuts off and the harness lowers you to the ground, leaving you in a puddle of your own creation when the nipple-cups pop off.\n\n", false);
				}
			}
	
			
			//Aftermaths
	
	
		//Set temp to liter amount produced.
		var liters:Number = 0;
		var payout:Number = 0;
		var cap:Number = 500;
		//Ez mode cap doubles
		if (flags[kFLAGS.EASY_MODE_ENABLE_FLAG] == 1) cap *= 2;
		if (debug) {
			flags[kFLAGS.WHITNEY_GEMS_PAID_THIS_WEEK] = 0;
			cap = 9999;
		}
		liters = int(player.lactationQ()* (rand(10) + 90) / 100)/1000;
		if (liters < 0) liters = 1337;
	
		// pay 100 gems for 1st half-liter, and 20 gems for every next half-liter
		if (liters < 0.5) payout = int (liters * 2 * 100);
		else payout = 100 + int ( (liters - 0.5) * 2 * 20);
		
		//payout = int(liters*2*4);
	outputText("The machinery displays " + liters + " liters of milk", false);
	//If already at cap
	if (flags[kFLAGS.WHITNEY_GEMS_PAID_THIS_WEEK] >= cap) {
		outputText(" and displays a warning that <b>you're producing more than Whitney can pay for</b>", false);
		payout = 0;
	}
	if (payout > 0) {
		//If over cap reduce payout to the difference
		if (payout + flags[kFLAGS.WHITNEY_GEMS_PAID_THIS_WEEK] > cap) payout = cap - flags[kFLAGS.WHITNEY_GEMS_PAID_THIS_WEEK];
		//Keep track of how much is paid
		flags[kFLAGS.WHITNEY_GEMS_PAID_THIS_WEEK] += payout;
		outputText(" and automatically dispenses " + num2Text(payout) + " gem" + (payout == 1 ? "" : "s") + ".  Whitney really went all out with this setup!", false);
		//Display a warning that you've capped out.
		if (flags[kFLAGS.WHITNEY_GEMS_PAID_THIS_WEEK] >= cap) outputText("  <b>The machinery warns you that Whitney can't afford any more this week!</b>", false);
		player.gems += payout;
	}
	else outputText(".", false);
	//High production = stupid cow.
	if (liters > 2) {
		outputText("\n\nYou feel woozy and lightheaded from the intense milking, and have difficulty focusing on anything but the residue of fluids coating your " + player.allBreastsDescript() + ".", false);
		//Being a cow makes you less dumb
		//Somehow
		if (player.findStatusEffect(StatusEffects.Feeder) >= 0) {
			dynStats("int", -1);
			if (liters > 5) dynStats("int", -1);
			if (liters > 10) dynStats("int", -1);
			if (liters > 20) dynStats("int", -1);
		}
		//not a cow, bimbotize me!
		else {
			if (liters/2 > 10) dynStats("int", -10);
			else dynStats("int", -liters/2);
			if (liters > 30) dynStats("int", -2);
		}
		if (player.inte < 10) {
			doNext(getGame().farm.cowBadEnd1);
			return;
		}
		else if (player.inte < 15) outputText("  You stretch and let out a contented moo, long and loud.  How silly!", false);
		else if (player.inte < 25) outputText("  You quietly moo, then giggle to yourself at how strange you're acting.", false);
	}

	outputText("\n\n", false);
	//Not very horny yet
	if (player.lust < 75) {
		outputText("Feeling sore and VERY hungry, you make yourself decent and stagger back towards camp, ignoring the knowing smile Whitney gives you when you pass by her.", false);
	}
	//Horny
	else {
		outputText("Overwhelmed with your desire, you don't even bother to cover up and make yourself decent, you just run out of the barn, " + player.allBreastsDescript() + " jiggling and wet, heading straight for camp.");
		if (getGame().farm.farmCorruption.whitneyCorruption() < 90) outputText(" It isn't until you get back that you remember the disapproving look Whitney gave you, but if anything, it only makes you hornier.", false);
		dynStats("lus=", player.maxLust());
	}
	//Boost lactation by a tiny bit and prevent lactation reduction
		player.boostLactation(.05);
	//Reset 'feeder' status
	player.changeStatusValue(StatusEffects.Feeder,2,0);
	//Boost endurance rating (more if low)
	if (player.statusEffectv1(StatusEffects.LactationEndurance) < 1.5) player.addStatusValue(StatusEffects.LactationEndurance,1,.05);
	player.addStatusValue(StatusEffects.LactationEndurance,1,.05);
	player.createStatusEffect(StatusEffects.Milked,8,0,0,0);
	doNext(camp.returnToCampUseOneHour);
		}
		
		
		
		
		
	}

}