// Minotaur town 
package classes.Scenes.Dungeons 
{
    import classes.*;
    import classes.Scenes.Areas.HighMountains.MinotaurMob;
    import classes.Scenes.Areas.Mountain.Minotaur;
	import classes.GlobalFlags.kGAMECLASS;
    import classes.GlobalFlags.kFLAGS;
    import classes.Scenes.Dungeons.DungeonCore;
    import classes.Scenes.Dungeons.MinoTown.KingMinos;
    import classes.Scenes.Quests.UrtaQuest.MinotaurLord;
    import flash.display.InteractiveObject;
    import classes.Scenes.Dungeons.MinoTown.MinoMazeScene;
    
	
	public class MinoTown extends DungeonAbstractContent
	{
		public var maze:MinoMazeScene = new MinoMazeScene;
        public var king:KingMinosScene = new KingMinosScene;
        
		public  function MinoTown() {
            
			
		}
		
		public  function    enterDungeon():void {
			kGAMECLASS.inDungeon  = true;
			kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_ENTRANCE; // 23;
			playerMenu();
		}
        
        public  function    exitDungeon ():void {
            kGAMECLASS.inDungeon = false;
            outputText("You leave the village and take off through the mountains back towards camp.");
            doNext(camp.returnToCampUseOneHour);
        }
        
        public  function    roomEntrance() : void {
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_ENTRANCE;
            spriteSelect(44);
            var addict:Boolean = (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] > 0);
            
	        clearOutput();
            
            outputText("You approach minotaurs village. Twenty or thirty cave openings are tunneled into the mountain, and an equal number of crude huts are built on the surrounding ledge. ");
            
            if (flags[kFLAGS.MINOTOWN_GUARD_DEFEATED] == 0) {
            
                outputText("Between the two sets of structures there are five of the shaggy beast-men gathered around a fire-pit, roasting some animal and relaxing.  Two of them are vigorously fucking tiny minotaur-like beings with feminine features, spearing their much shorter brethren on their mammoth shafts.");
                if (addict) outputText("The look on the faces of the 'minitaurs' is one you know well, the pure ecstasy of indulging a potent addiction.");
                outputText("\n\n");
	
                if (flags[kFLAGS.FACTORY_SHUTDOWN] > 0) {
                    outputText("A third beast has a human-looking victim suspended by her ankles and is roughly fucking her throat.   Her eyes are rolled back, though whether from pleasure or lack of oxygen you're not sure.  A pair of beach-ball-sized breasts bounces on her chest, and a cock big enough to dwarf the minotaur's flops about weakly, dribbling a constant stream of liquid.  She must be one of the slaves that escaped from the factory, though it doesn't look like her life has improved much since her escape.\n\n");
                }
            }
            else {
                outputText("Between the two sets of structures there are two of the shaggy beast-men near a fire-pit, vigorously fucking tiny minotaur-like beings with feminine features, spearing their much shorter brethren on their mammoth shafts.");
                if (addict) outputText("The look on the faces of the 'minitaurs' is one you know well, the pure ecstasy of indulging a potent addiction.");
                outputText("\n\n");
            }
            dungeons.setDungeonButtons(roomFirePit, null, null, null);
            addButton(11, "Leave", exitDungeon);

       }
        
        public  function    roomFirePit  ():void {
            
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_FIREPIT;
            clearOutput();

            //var addict:Boolean = (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] > 0);
            if (getGame().flags[kFLAGS.MINOTOWN_GUARD_DEFEATED] == 0) {
                clearOutput();
                outputText("Carefully, you climb down to the fire pit. One of the unoccupied monsters glances your way and gives you a predatory smile.  He puts down the axe he was sharpening and strides over, his loincloth nearly tearing itself from his groin as his member inflates to full size.  Amazingly, this minotaur bothers to speak, \"<i>New fuck-toy.  Suck.</i>\"\n\n");
                menu();
                addButton(0, "Suck",  suckMinoGuard);
                addButton(1, "Fight", fightMinoGuard);
            }
            else {
                outputText("Fire pit casts uneven shadows around. You hear moans of copulating beasts. You think they are too preoccupied and won't notice an intrusion\n");
                dungeons.setDungeonButtons(null, roomEntrance, null, roomMazeEntrance);
            }
            
        }
        public  function    roomMaze() : void {
            maze.enterRoom();
        }
		
        public  function    roomMazeEntrance() : void {
            clearOutput();
            if (player.hasStatusEffect(StatusEffects.MinoMazeStatsBackup)) {
                dynStats("str", player.statusEffectv1(StatusEffects.MinoMazeStatsBackup) - player.str);
                dynStats("tou", player.statusEffectv2(StatusEffects.MinoMazeStatsBackup) - player.tou);
            }
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ENTRANCE;
            outputText("You stay before an entrance to a minotaur's cavern. You decide to enter the caverns, but you know you may be lost there forever\n");
            dungeons.setDungeonButtons(null, null, roomFirePit, maze.enterMaze);
            flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] = 0;
            if (!player.hasStatusEffect(StatusEffects.MinoMazeStatsBackup)) {
                player.createStatusEffect(StatusEffects.MinoMazeStatsBackup,0,0,0,0); 
            }
            player.changeStatusValue(StatusEffects.MinoMazeStatsBackup, 1, player.str);
            player.changeStatusValue(StatusEffects.MinoMazeStatsBackup, 2, player.tou);
        }
        
        public  function    roomMazeReturnToEntrance() : void {
            flags[kFLAGS.MINOTOWN_MAZE_TIMES_PASSED]++;
            if (player.hasStatusEffect(StatusEffects.MinoMazeStatsBackup)) {
                dynStats("str", player.statusEffectv1(StatusEffects.MinoMazeStatsBackup));
                dynStats("tou", player.statusEffectv2(StatusEffects.MinoMazeStatsBackup));
            }
            roomMazeEntrance();
        }
        
        private function    generateMazeRoom() : void {
            if (!player.hasStatusEffect(StatusEffects.MinoMazeConfiguration)) {
                player.createStatusEffect(StatusEffects.MinoMazeConfiguration,0,0,0,0);
            }
            
            //if (kGAMECLASS.dungeonLoc == DungeonCore.DUNGEON_MINO_MAZE_ROOM_WEST)  maze.goToRoom(maze.WEST);
            //if (kGAMECLASS.dungeonLoc == DungeonCore.DUNGEON_MINO_MAZE_ROOM_EAST)  maze.goToRoom(maze.EAST);
            //if (kGAMECLASS.dungeonLoc == DungeonCore.DUNGEON_MINO_MAZE_ROOM_NORTH) maze.goToRoom(maze.NORTH);
            //if (kGAMECLASS.dungeonLoc == DungeonCore.DUNGEON_MINO_MAZE_ROOM_SOUTH) maze.goToRoom(maze.SOUTH);
            
      
        }
        
        public  function    roomMazeFunction (location:int = 0):Function {
            
            switch (location) {
                case DungeonCore.DUNGEON_MINO_MAZE_ROOM_WEST:
                    return roomMazeWestEnter;   
                case DungeonCore.DUNGEON_MINO_MAZE_ROOM_EAST:
                    return roomMazeEastEnter;
                case DungeonCore.DUNGEON_MINO_MAZE_ROOM_NORTH:
                    return roomMazeNorthEnter;
                case DungeonCore.DUNGEON_MINO_MAZE_ROOM_SOUTH:
                    return roomMazeSouthEnter;
                case DungeonCore.DUNGEON_MINO_MAZE_HALL:
                    return roomMazeHallEnter;
                case DungeonCore.DUNGEON_MINO_MAZE_EXIT:
                    return roomMazeExit;
                case DungeonCore.DUNGEON_MINO_MAZE_ENTRANCE:
                    return roomMazeReturnToEntrance;
                default:
                    return null;
            }
           
        }
        
        public  function    roomMazeDescription() : void {
            
            var choice : int = player.statusEffectv1(StatusEffects.MinoMazeDescription);
            if  (choice == 0) {
                outputText("You are wandering in the dimly lit caverns. The walls are rough and cold. ");
            }
            else if (choice == 1) {
                outputText("You walk past a dimly lit torch. You realize that you may be totally lost here. ");
            }
            else if (choice == 2) {
                outputText("You think you see a movement in the shadows, but it is just flickering light of a torch. ");
            }
            else if (choice == 3) {
                outputText("A strong feeling of deja vu raise in your head. The walls look too familiar. Have you already been here? ");
            }
            if (rand(4) == 0) {
                outputText("You hear a rambling of a stones in the distance. Or maybe you are hallucinating. ");
            }
            choice = player.statusEffectv2(StatusEffects.MinoMazeDescription);
            if (choice == 0) { 
                if (flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] > 0 && minoCumAddictionStrength() > 0) {
                    if (flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] < 2) outputText("You feel thin smell of minotaurs cum in the air. ");
                    else if (flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] < 4) outputText("You feel a smell of minotaurs cum in the air. It is quite arousing. "); 
                    else if (flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] < 6) outputText("You feel a stench of minotaurs cum. It is hard to think of anything but the cum. ");
                    else if (flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] < 8) outputText("You feel a stench of minotaurs cum. It is hard to think of anything but the cum. ");
                    else outputText("The incredibly strong smell of minotaurs cum make your head drum. With a great effort you try to focus yourself on walking. ");
                }
            }
            outputText("\n\n");
            
            choice = player.statusEffectv3(StatusEffects.MinoMazeDescription);
            if (choice == 1) {
                outputText("Under you feet you see a puddle of something white. You turn in disgust. ");
            }
            else if (choice == 2) {
                outputText("You feel a gust of fresh air. ");
            }
            

            
        }
        public  function    roomMazeConfiguration() : void {
        }
           
        private function    roomMazeEastEnter() : void {
            clearOutput();
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOM_EAST;
            mazeStatusUpdate();
            
            generateMazeRoom();
            if (rand(400) == 0 || player.lust >= player.maxLust()) {
                mazeMinotaurEncounter();
            }
            else roomMazeEast();
        }
        private function    roomMazeWestEnter() : void {
            clearOutput();
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOM_WEST;
            mazeStatusUpdate();
            
            generateMazeRoom();
            if (rand(300) == 0 || player.lust >= player.maxLust()) {
                mazeMinotaurEncounter();
            }
            else roomMazeWest();
        }
        private function    roomMazeNorthEnter() : void {
            clearOutput();
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOM_NORTH;
            mazeStatusUpdate();
            
            generateMazeRoom();
            if (rand(500) == 0 || player.lust >= player.maxLust()) {
                mazeMinotaurEncounter();
            }
            else roomMazeNorth();
        }
        private function    roomMazeSouthEnter() : void {
            clearOutput();
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOM_SOUTH;
            mazeStatusUpdate();
            
            generateMazeRoom();
            if (rand(500) == 0 || player.lust >= player.maxLust()) {
                mazeMinotaurEncounter();
            }
            else roomMazeSouth();
        }
        private function    roomMazeHallEnter()  : void {
            clearOutput();
            mazeStatusUpdate();
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_HALL;
            
            generateMazeRoom();
            roomMazeHall();
        }
        
        public  function    roomMazeEast():void     {
            clearOutput();
            roomMazeDescription();
            roomMazeConfiguration();
        }
        public  function    roomMazeWest():void     {
            clearOutput();
            roomMazeDescription();
            roomMazeConfiguration();
        }
        public  function    roomMazeNorth():void    {
            clearOutput();
            roomMazeDescription();
            roomMazeConfiguration();
        }
        public  function    roomMazeSouth():void    {
            clearOutput();
            roomMazeDescription();
            roomMazeConfiguration();
        }
        
        public  function    roomMazeHall():void {
            clearOutput();
            outputText("You step into a large hall. You see the fountain in front of you. You may rest in alcove.");
            roomMazeConfiguration();
            addButton(0,  "Drink",  minoHallDrink);
            addButton(14, "Rest",   minoHallRest);
        }
        public function     minoHallDrink():void {
            clearOutput();
            outputText("You drink from the fountain.\n\n");
            
            var choice : int =  player.statusEffectv3(StatusEffects.MinoMazeDescription);
            
            if (choice == 0) {
                outputText("Strangely enough, you feel nothing happened to you\n\n");
                player.refillHunger(5);
                HPChange(player.HP * 0.1 + rand(player.HP * 0.2), true);
                player.changeFatigue( -25);
                dynStats("lus", -20);
            }
            else if (choice == 1) {
                var tainted:Boolean = (rand(2) == 0);
                var enchanced:Boolean = tainted && (rand(5) == 0);
                mutations.laBova(tainted, enchanced, player, false);
            }
            else if (choice == 2) {
                //lactaidFountain();
            }
            else if (choice == 3) {
                mutations.minotaurCum(false,player,false);
            }
            
            doNext(playerMenu);
            
        }
        public function     minoHallRest():void {
            clearOutput();
            outputText("You are being violently raped by a gang of vicious Minotaurs.\n\n");
            dynStats("int", -20, "lib", 5, "sen", 15, "lus", 50, "cor", 10);
            player.refillHunger(50);
            player.minoCumAddiction(20);
            doNext(playerMenu);
        }
        
        public function     roomMazeExit(): void {
            if (player.hasStatusEffect(StatusEffects.MinoMazeConfiguration)) player.removeStatusEffect(StatusEffects.MinoMazeConfiguration);
            if (player.hasStatusEffect(StatusEffects.MinoMazeDescription))   player.removeStatusEffect(StatusEffects.MinoMazeDescription);
            clearOutput();
            outputText("Finally, you exit the labirynth");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_EXIT;
            flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] = 0;
            dungeons.setDungeonButtons(null, null, roomMazeWestEnter, exitDungeon);
            flags[kFLAGS.MINOTOWN_MAZE_TIMES_PASSED]++;
            
            if (player.hasStatusEffect(StatusEffects.MinoMazeStatsBackup)) {
                dynStats("str", player.statusEffectv1(StatusEffects.MinoMazeStatsBackup) - player.str + 1);
                dynStats("tou", player.statusEffectv2(StatusEffects.MinoMazeStatsBackup) - player.tou + 1);
            }
            if (!player.hasStatusEffect(StatusEffects.MinoMazeStatsBackup)) {
                player.createStatusEffect(StatusEffects.MinoMazeStatsBackup,0,0,0,0); 
            }
            player.changeStatusValue(StatusEffects.MinoMazeStatsBackup, 1, player.str);
            player.changeStatusValue(StatusEffects.MinoMazeStatsBackup, 2, player.tou);
        }
        
        public function     mazeStatusUpdate():void {
            dynStats("lus", rand(flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]));
            dynStats("lus", 10 * minoCumAddictionStrength() * flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]);
            dynStats("lus", rand(player.cowScore() ) * flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] * 0.5);
            if (flags[kFLAGS.HUNGER_ENABLED] > 0) {
                player.damageHunger(rand(10) / 10);
                if (player.hunger < 25) { 
                    outputText("<b>You have to eat something; your stomach is growling " + (player.hunger < 1 ? "painfully": "loudly") + ". </b>");
		            if (player.hunger < 10) {
			            outputText("<b>You are getting thinner and you're losing muscles. </b>");
		            }
		            if (player.hunger <= 0) {
			            outputText("<b>You are getting weaker due to starvation. </b>");
		            }
		            outputText("\n\n");
                }
				if (player.hunger <= 0) {
					//Lose HP and makes fatigue go up. Lose body weight and muscles.
					if (player.thickness < 25) {
						player.takeDamage(player.maxHP() / 25);
						player.changeFatigue(2);
						dynStats("str", -0.5);
						dynStats("tou", -0.5);
					}
					player.hunger = 0; //Prevents negative
				}
				if (player.hunger < 10) {
					player.modThickness(1, 0.3);
					player.modTone(1, 0.3);
				}
            }
            dynStats("tou", -0.3 * rand(flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]));
            dynStats("str", -0.3 * rand(flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]));
            getGame().mountain.minotaurScene.minoCumUpdate();
        }
        
        public function     mazeMinotaurEncounter() : void {
            outputText("You encountered a minotaur\n\n");
            if (rand(3) == 0) startCombat(new MinotaurLord(), false);
            else startCombat(new Minotaur(), false);
            monster.createStatusEffect(StatusEffects.MinoMazeFight, 0, 0, 0, 0);
            doNext(playerMenu);
            return;
        }
        
        public function     minoEncounterDecrement() : void {
        }
        
        public function     mazeMinotaurLoss() : void {
            // Text about stuff
            
            doNext(playerMenu);
        }
        
        public function     mazeMinotaurWin()  : void {
            
            doNext(playerMenu);
        }
        
        public function     fightMinoGuard() : void {
            //clearOutput();
            outputText("No way you are going to please that beast. It's a fight!\n\n");
            startCombat(new Minotaur(), true);
            monster.createStatusEffect(StatusEffects.MinoTownFight, 0, 0, 0, 0);
            doNext(playerMenu);
            return;
        }
        public function     fightMinotaurWin() : void {
            getGame().flags[kFLAGS.MINOTOWN_GUARD_DEFEATED] = 1;
            doNext(playerMenu);
        }
        public function     fightMinotaurLoss() : void {
            minoBadEnd ();
        }
        
        public function     suckMinoGuard () : void {
            clearOutput();
            outputText("The words of minotaur guard are music to your ears.  Crawling forwards, you wallow in the dirt until you're prostrate before him.  Looking up with wide eyes, you grip him in your hands and give him a gentle squeeze.  You open wide, struggling to fit his girthy member into your eager mouth, but you manage.  A drop of pre-cum rewards your efforts, and you happily plunge forwards, opening wider as he slips into the back of your throat.  Miraculously, your powerful needs have overcome your gag reflex, and you're gurgling noisily as your tongue slides along the underside of his cock, massaging him.\n\n");
	
	        outputText("\"<i>Need... more!</i>\" grunts the beast, grabbing you around the neck and pulling you upwards, forcing himself further and further into your throat.   Normally being unable to breathe would incite panic, but the pre-cum dripping into your gullet blasts away the worry in your mind.   You're face-fucked hard and fast until you feel your master's cock swelling with pleasure inside your throat.  It unloads a thick batch of creamy minotaur jism directly into your stomach, rewarding you until your belly bulges out with the appearance of a mild pregnancy.\n\n");
	
	        outputText("Your master pulls out and fastens a leather collar around your neck before dragging you through the mud back to his campfire.  Between the tugging of your collar and rough throat-fucking, you're breathless and gasping, but you couldn't be any happier.  Your new owner lifts you up by your " + player.assDescript() + " and forces himself inside your " + player.assholeDescript() + ", stuffing you full of thick minotaur cock.  Still heavily drugged by the load in your gut, you giggle happily as you're bounced up and down, totally relaxed in your master's presence.\n\n");
	
	        outputText("He grunts and cums inside you for the second time, somehow still able to flood your bowels with what feels like a gallon of cum.  Drooling brainlessly, happy gurgles trickle from your throat as you're pulled off and tossed to the side.  You don't feel the impact of your body landing in the mud, or even notice when you're passed around the camp-fire, broken in as each of your new monstrous masters has his turn.");
            dynStats("int", -20, "lib", 5, "sen", 15, "lus", 50, "cor", 10);
            doNext(minoBadEnd);
        }
		
        
        private function    minoBadEnd () : void {
            
	        spriteSelect(44);
	        hideUpDown();
	        clearOutput();
	        outputText("Days and weeks pass in a half-remembered haze.  You're violated countless time, and after the first day they don't even bother to keep you on a leash.  Why would they need to restrain such an eager slave?  You're tossed to the side whenever you're not needed as a cum-dump, but as soon as you start to come out of your daze, you crawl back, gaping, dripping, and ready for another dose.  For their part, your new masters seem happy to take care of your needs.  The only time you aren't drugged is when the minotaurs are sleeping, but the minitaurs seem all too happy to let you suckle the pre from their tiny horse-cocks in the huddled slave-pile.\n\n");
	
	        outputText("You are no longer the Champion of your village.  The only thing you're a champion of is cum-guzzling.  You take immense pride in showing the other cum-sluts just how many thick loads you can coax from your horny masters every day.  Life couldn't be any better.");
	        getGame().gameOver();
	        dynStats("int", -1, "lib", 5, "sen", 30, "lus=", 100, "cor", 20);
        }
        
        private function    minoCumAddictionStrength () : Number {
            if (flags[kFLAGS.MINOTAUR_CUM_INTAKE_COUNT] > 0 || flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] > 0 || player.findPerk(PerkLib.MinotaurCumAddict) >= 0 || player.findPerk(PerkLib.MinotaurCumResistance) >= 0) {
                
				if (player.findPerk(PerkLib.MinotaurCumAddict) < 0)
                    return flags[kFLAGS.MINOTAUR_CUM_ADDICTION_TRACKER] / 100;
				else if (player.findPerk(PerkLib.MinotaurCumResistance) >= 0)
                    return 0;
				else
                    return 1;
			}
            else return 0;
            
        }
	

        
    }


}