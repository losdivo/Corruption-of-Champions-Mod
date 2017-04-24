// Minotaur town 
package classes.Scenes.Dungeons 
{
    import classes.*;
    import classes.Scenes.Areas.Mountain.Minotaur;
	import classes.GlobalFlags.kGAMECLASS;
    import classes.GlobalFlags.kFLAGS;
    import classes.Scenes.Dungeons.DungeonCore;
    
    
	
	public class MinoTown extends DungeonAbstractContent
	{
		
		public function MinoTown() {
			
		}
		
		public function     enterDungeon():void {
			kGAMECLASS.inDungeon  = true;
			kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_ENTRANCE; // 23;
			playerMenu();
		}
        
        public function     exitDungeon ():void {
            kGAMECLASS.inDungeon = false;
            outputText("You leave the village and take off through the mountains back towards camp.", true);
            doNext(camp.returnToCampUseOneHour);
        }
        
        public function     roomEntrance() : void {
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_ENTRANCE;
            spriteSelect(44);
            var addict:Boolean = (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] > 0);
            
	        clearOutput();
            
            outputText("You approach minotaurs village. Twenty or thirty cave openings are tunneled into the mountain, and an equal number of crude huts are built on the surrounding ledge. ");
            
            if (flags[kFLAGS.MINOTOWN_GUARD_DEFEATED] == 0) {
            
                outputText("Between the two sets of structures there are five of the shaggy beast-men gathered around a fire-pit, roasting some animal and relaxing.  Two of them are vigorously fucking tiny minotaur-like beings with feminine features, spearing their much shorter brethren on their mammoth shafts.", false);
                if (addict) outputText("The look on the faces of the 'minitaurs' is one you know well, the pure ecstasy of indulging a potent addiction.", false);
                outputText("\n\n");
	
                if (flags[kFLAGS.FACTORY_SHUTDOWN] > 0) {
                    outputText("A third beast has a human-looking victim suspended by her ankles and is roughly fucking her throat.   Her eyes are rolled back, though whether from pleasure or lack of oxygen you're not sure.  A pair of beach-ball-sized breasts bounces on her chest, and a cock big enough to dwarf the minotaur's flops about weakly, dribbling a constant stream of liquid.  She must be one of the slaves that escaped from the factory, though it doesn't look like her life has improved much since her escape.\n\n", false);
                }
            }
            else {
                outputText("Between the two sets of structures there are two of the shaggy beast-men near a fire-pit, vigorously fucking tiny minotaur-like beings with feminine features, spearing their much shorter brethren on their mammoth shafts.", false);
                if (addict) outputText("The look on the faces of the 'minitaurs' is one you know well, the pure ecstasy of indulging a potent addiction.", false);
                outputText("\n\n");
            }
            dungeons.setDungeonButtons(roomFirePit, null, null, null);
            addButton(11, "Leave", exitDungeon);

       }
        
        public function     roomFirePit  ():void {
            
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_FIREPIT;
            clearOutput();

            //var addict:Boolean = (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] > 0);
            if (getGame().flags[kFLAGS.MINOTOWN_GUARD_DEFEATED] == 0) {
                clearOutput();
                outputText("Carefully, you climb down to the fire pit. One of the unoccupied monsters glances your way and gives you a predatory smile.  He puts down the axe he was sharpening and strides over, his loincloth nearly tearing itself from his groin as his member inflates to full size.  Amazingly, this minotaur bothers to speak, \"<i>New fuck-toy.  Suck.</i>\"\n\n", false);
                menu();
                addButton(0, "Suck",  suckMinoGuard);
                addButton(1, "Fight", fightMinoGuard);
            }
            else {
                outputText("Fire pit casts uneven shadows around. You hear moans of copulating beasts. You think they are too preoccupied and won't notice an intrusion\n", false);
                dungeons.setDungeonButtons(null, roomEntrance, null, roomMazeEntrance);
            }
            
        }
		
        public function     roomMazeEntrance() : void {
            clearOutput();
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ENTRANCE;
            outputText("You stay before an entrance to a minotaur's cavern. You decide to enter the caverns, but you know you may be lost there forever\n");
            dungeons.setDungeonButtons(null, null, null, roomMazeEast);
        }
        
        private function     setMazeRoom (direction:String = 'hall') : void {
            var east:Function  = null;
            var west:Function  = null;
            var south:Function = null;
            var north:Function = null;
            if (rand(4) == 0) west  = roomMazeWest;
            if (rand(4) == 0) south = roomMazeSouth;
            if (rand(4) == 0) north = roomMazeNorth;
            if (rand(4) == 0) east  = roomMazeEast;
            
            if (rand(4) == 0 && south == null) south = roomMazeHall;
            if (rand(4) == 0 && north == null) north = roomMazeHall;
            
            switch (direction) {
                case 'east' : 
                    if (rand(10) == 0 && east == null) east = roomMazeExit;
                    west = roomMazeWest;
                    break;
                case 'west':
                    if (rand(10) == 0 && east == null) west = roomMazeEntrance;
                    east = roomMazeEast;
                    break;
                case 'north':
                    south = roomMazeSouth;
                    break;
                case 'south':
                    north = roomMazeNorth;
                    break;
                default:
                    west = roomMazeWest;
            }
            dungeons.setDungeonButtons(north,south,west,east);
        }
        public  function     roomMazeEast():void     {
            clearOutput();
            outputText("You are wondering in the maze\n\n");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOME;
            setMazeRoom('east');
        }
        public function     roomMazeWest():void     {
            clearOutput();
            outputText("You guess you may be lost in a labirynth\n\n");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOMW;
            setMazeRoom('west');
            
        }
        public function     roomMazeNorth():void    {
            clearOutput();
            outputText("You think you see a movement in the shadows, but it is just flickering light of a torch.\n\n");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOMN;
            setMazeRoom('north');
        }
        public function     roomMazeSouth():void    {
            clearOutput();
            outputText("Under you feet you see a puddle of something white. You turn in disgust.\n\n");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ROOMS;
            setMazeRoom('south');
        }
        public function     roomMazeHall():void {
            clearOutput();
            outputText("You step into a large hall");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_HALL;
            setMazeRoom();
        }
        public function     roomMazeExit(): void {
            clearOutput();
            outputText("Finally, you exit the labirynth");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_EXIT;
            dungeons.setDungeonButtons(null,null,roomMazeWest, exitDungeon);
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
            outputText("The words of minotaur guard are music to your ears.  Crawling forwards, you wallow in the dirt until you're prostrate before him.  Looking up with wide eyes, you grip him in your hands and give him a gentle squeeze.  You open wide, struggling to fit his girthy member into your eager mouth, but you manage.  A drop of pre-cum rewards your efforts, and you happily plunge forwards, opening wider as he slips into the back of your throat.  Miraculously, your powerful needs have overcome your gag reflex, and you're gurgling noisily as your tongue slides along the underside of his cock, massaging him.\n\n", false);
	
	        outputText("\"<i>Need... more!</i>\" grunts the beast, grabbing you around the neck and pulling you upwards, forcing himself further and further into your throat.   Normally being unable to breathe would incite panic, but the pre-cum dripping into your gullet blasts away the worry in your mind.   You're face-fucked hard and fast until you feel your master's cock swelling with pleasure inside your throat.  It unloads a thick batch of creamy minotaur jism directly into your stomach, rewarding you until your belly bulges out with the appearance of a mild pregnancy.\n\n", false);
	
	        outputText("Your master pulls out and fastens a leather collar around your neck before dragging you through the mud back to his campfire.  Between the tugging of your collar and rough throat-fucking, you're breathless and gasping, but you couldn't be any happier.  Your new owner lifts you up by your " + player.assDescript() + " and forces himself inside your " + player.assholeDescript() + ", stuffing you full of thick minotaur cock.  Still heavily drugged by the load in your gut, you giggle happily as you're bounced up and down, totally relaxed in your master's presence.\n\n", false);
	
	        outputText("He grunts and cums inside you for the second time, somehow still able to flood your bowels with what feels like a gallon of cum.  Drooling brainlessly, happy gurgles trickle from your throat as you're pulled off and tossed to the side.  You don't feel the impact of your body landing in the mud, or even notice when you're passed around the camp-fire, broken in as each of your new monstrous masters has his turn.", false);
            dynStats("int", -20, "lib", 5, "sen", 15, "lus", 50, "cor", 10);
            doNext(minoBadEnd);
        }
		
        
        private function    minoBadEnd () : void {
            
	        spriteSelect(44);
	        hideUpDown();
	        clearOutput();
	        outputText("Days and weeks pass in a half-remembered haze.  You're violated countless time, and after the first day they don't even bother to keep you on a leash.  Why would they need to restrain such an eager slave?  You're tossed to the side whenever you're not needed as a cum-dump, but as soon as you start to come out of your daze, you crawl back, gaping, dripping, and ready for another dose.  For their part, your new masters seem happy to take care of your needs.  The only time you aren't drugged is when the minotaurs are sleeping, but the minitaurs seem all too happy to let you suckle the pre from their tiny horse-cocks in the huddled slave-pile.\n\n", false);
	
	        outputText("You are no longer the Champion of your village.  The only thing you're a champion of is cum-guzzling.  You take immense pride in showing the other cum-sluts just how many thick loads you can coax from your horny masters every day.  Life couldn't be any better.", false);
	        getGame().gameOver();
	        dynStats("int", -1, "lib", 5, "sen", 30, "lus=", 100, "cor", 20);
        }
	}
    
    

}