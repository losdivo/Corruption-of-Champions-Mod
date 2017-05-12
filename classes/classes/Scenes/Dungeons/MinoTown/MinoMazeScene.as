package classes.Scenes.Dungeons.MinoTown 
{
    
    import classes.*;
	import classes.GlobalFlags.kGAMECLASS;
    import classes.GlobalFlags.kFLAGS;
    import classes.Scenes.Dungeons.DungeonCore;
    import classes.Scenes.Dungeons.DungeonAbstractContent;
    import classes.Scenes.Areas.Mountain.Minotaur;
    import classes.Scenes.Quests.UrtaQuest.MinotaurLord;

	/**
     * ...
     * @author losdivo
     */
    public class MinoMazeScene extends DungeonAbstractContent
    {
        
        /*
         * coordinate X increases from west  (-2) to east  (+2) 
         * coordinate Y increases from south (-2) to north (+2)
         * current room has coordinates (0,0) and is located at the center of map
         * values of the map are: 
         *          0 - undefined,
         *          1 - normal room 
         *          2 - hall 
         *          3 - entrance
         *          4 - exit
         *     + 10*A,  where A encodes possible paths [0 = no path, 1 = path]:
         *          A  = north? + 2*south? + 4*west? + 8*east?
         *    +1000*B,  where B encodes the direction to backtrace
         *          0 - from nowhere
         *          1 - from north
         *          2 - from south
         *          3 - from west
         *          4 - from east
         *   +10000*C,  where C encodes additional stuff
         *          C  = lost + 2*minotaur + 4*visited + 8*description
         */
        
        
        private var mazeMap:Array;
        private var mazePos:int;
        
        
        
        
        public static const NORTH:  int             = 1;
        public static const SOUTH:  int             = 2;
        public static const EAST:   int             = 3;
        public static const WEST:   int             = 4;

        
        public static const ROOM_UNDEFINED:int      = 0;
        public static const ROOM_GENERIC:int        = 1;
        public static const ROOM_HALL:int           = 2;
        public static const ROOM_ENTRANCE:int       = 3;
        public static const ROOM_EXIT:int           = 4;
        
        
        private var north:      Boolean;
        private var south:      Boolean;
        private var east:       Boolean;
        private var west:       Boolean;
        private var playerLost: Boolean;
        
        private var description1: int;
        private var description2: int;
        private var description3: int;
        private var cumStench:    int;
        private var numLosses:    int;
        
        public function MinoMazeScene() {
            mazePos = 0;
            mazeMap = [0];
        }
        
        //{region Access to Rooms
        
        private function getRoomType    () : int { 
            return mazeMap[mazePos] % 10;
        }
        private function setRoomType    (newType: int) : void {
            mazeMap[mazePos] = int(mazeMap[mazePos] / 10) * 10 + newType;
        }

        
        private function getRoomExits   () : int {
            return (mazeMap[mazePos] / 10) % 100; 
        }
        private function setRoomExits   (newExits:int) : void {
            mazeMap[mazePos] = int (mazeMap[mazePos] / 1000) * 1000 + 10 * newExits + mazeMap[mazePos] % 10;
        }

        private function encodeExits    (inorth:Boolean, isouth:Boolean, iwest:Boolean, ieast:Boolean) : int {
            var exits:int = 0; 
            if (inorth) exits += 1;
            if (isouth) exits += 2;
            if (iwest)  exits += 4;
            if (ieast)  exits += 8;
            return exits;
        }
        private function encodeCurrentExits() : int {
            var exits:int = 0; 
            if (north) exits += 1;
            if (south) exits += 2;
            if (west)  exits += 4;
            if (east)  exits += 8;
            return exits;
        }

        
        private function setDirectionFrom(direction:int) : void { 
            mazeMap[mazePos] = 10000*int(mazeMap[mazePos] / 10000) + direction*1000 + mazeMap[mazePos] % 1000;
        }
        private function getDirectionFrom() : int {
            return int(mazeMap[mazePos] / 1000) % 10;
        }
        private function getRevertDirection(direction:int) : int  {
            if (direction == NORTH) return SOUTH;
            if (direction == SOUTH) return NORTH;
            if (direction == WEST)  return EAST;
            if (direction == EAST)  return WEST;
            return 0;
        }
        
        private function setStuff        (stuff:int) : void {
            mazeMap[mazePos] = mazeMap[mazePos] % 10000 + 10000 * stuff;
        }
        private function getStuff        () : int {
            return int(mazeMap[mazePos] / 10000);
        }
        
        private function setFirstTimeLoss(firstTimeLoss:Boolean) : void {
            var stuff:int = 2 * int(getStuff() / 2);
            if (firstTimeLoss) stuff += 1;
            setStuff(stuff);
        }
        private function getFirstTimeLoss() : Boolean {
            return (getStuff() % 2 == 1);
        }
        
        private function setMinotaur(mino:Boolean) : void {
            var stuff:int = getStuff();
            stuff = (stuff % 2) + 4 * int(stuff / 4) + 2 * (mino ? 1 : 0);
            setStuff(stuff);
        }
        private function getMinotaur() : Boolean {
            return (getStuff() % 4 >= 2);
        }
        
        private function setVisited(visited:Boolean) : void {
            var stuff:int = getStuff();
            stuff = (stuff % 4) + 8 * int(stuff / 8) + 4 * (visited ? 1 : 0); 
            setStuff(stuff);
        }
        private function getVisited() : Boolean {
            return (getStuff() % 8 >= 4);
        }

        private function setDescription (desc1:int, desc2:int, desc3:int) : void {
            var stuff:int = getStuff() % 8 + (desc3*100 + desc2*10 + desc1)* 8;
            setStuff(stuff);
        }
        
        
        private function restoreExits() : void {
            var exits:int = getRoomExits();
            north = (exits % 2 >= 1);
            south = (exits % 4 >= 2);
            west  = (exits % 8 >= 4);
            east  = (exits >= 8);
        }
        private function restoreDescription() : void {
            var stuff:int = getStuff() / 8;
            description1 = stuff % 10;
            stuff = int (stuff / 10);
            description2 = stuff % 10;
            stuff = int (stuff / 10);
            description3 = stuff % 10;
        }
        
        //}endregion
        
        public function goToRoom            (direction: int): void {
            
            // Return or not?
            if (mazePos > 0 && getDirectionFrom() == direction) {
                mazePos--;
                restoreExits();
                restoreDescription();
                return;
            }
            
            var maxPos:int = player.inte / 10 + 1;
            mazePos++;
            
            var firstTimeLoss:Boolean = false;
            if (mazePos > maxPos) {
                var deltaPos:int = mazePos - maxPos;
                for (var i:int = 0; i <= maxPos; i++) mazeMap[i] = mazeMap[i + deltaPos];
                if (!playerLost) firstTimeLoss = true;
                playerLost = true;
            }
            mazeMap[mazePos] = 0;
            setDirectionFrom(getRevertDirection(direction));
            
            // Room neighbors
            north = south = west = east = false;
            if ( rand(2) == 0  || direction == WEST)  east  = true;
            if ( rand(2) == 0  || direction == EAST)  west  = true;
            if ( rand(2) == 0  || direction == NORTH) south = true;
            if ( rand(2) == 0  || direction == SOUTH) north = true;
            setRoomExits(encodeCurrentExits());
            
            
            // Room type
            var roomType:int = ROOM_GENERIC;
            if ( (direction == NORTH || direction == SOUTH) && rand(4) == 0)  roomType = ROOM_HALL;
            
            var familiarity: int = 15 - flags[kFLAGS.MINOTOWN_MAZE_TIMES_PASSED] * 2;
            if (familiarity < 5) familiarity = 5;
            familiarity = 20;
            
            if (direction == EAST && rand(familiarity) == 0) roomType = ROOM_EXIT;
            if (direction == WEST && rand(familiarity) == 0) roomType = ROOM_ENTRANCE;
            setRoomType(roomType);
            
            // Minotaur
            setMinotaur(false);
            if (roomType == ROOM_GENERIC) {
                if (direction != WEST && rand(5) == 0) setMinotaur(true);
                if (direction == WEST && rand(3) == 0) setMinotaur(true);
            }
            
            // Description
            description1 = rand(4);                 // General layout of the room
            description2 = rand(3) == 0 ? 1 : 0;    // Comments on minotaur cum smell
            
            var choice:int = 0;
            if (direction == EAST) {
                choice = 1;
            }
            else {
                if (rand(4) == 0) choice = 2;
                else if (rand(6) == 0) choice = 1;
            }
            
            if  (choice == 1) {
                cumStench += 1;
                if (rand(2) == 0) choice = 0;
            }
            else if (choice == 2) { 
                cumStench  -= 1;
                if (cumStench < 0) cumStench = 0;
                if (rand(2) == 0) choice = 0;
            }
            if (roomType == ROOM_HALL) {
                choice = rand(5);
                if (choice < 3)  choice = 0;
                if (choice == 3) choice = 1;
                if (choice == 4) choice = 2;
                if (rand(10) == 0) choice = 3;
            }
            description3 = choice;  // Cum puddle && wind gust
            
            setFirstTimeLoss(firstTimeLoss);
            setDescription(description1, description2, description3);
            
        }
        
        public  function    roomMazeConfiguration() : void {
            var fnorth:Function = north == 0 ? null : enterRoomNorth;
            var fsouth:Function = south == 0 ? null : enterRoomSouth;
            var fwest:Function  = west  == 0 ? null : enterRoomWest;
            var feast:Function  = east  == 0 ? null : enterRoomEast;
            dungeons.setDungeonButtons(fnorth,fsouth,fwest,feast);
        }
        public function enterRoomNorth() : void {
            goToRoom(NORTH);
            enterRoom();
        }
        public function enterRoomSouth() : void {
            goToRoom(SOUTH);
            enterRoom();
        }
        public function enterRoomWest() : void {
            goToRoom(WEST);
            enterRoom();
        }
        public function enterRoomEast() : void {
            goToRoom(EAST);
            enterRoom();
        }
        public function enterRoom() : void {
            clearOutput();
            mazeStatusUpdate();
            var type:int = getRoomType();
            switch (type) {
                case ROOM_ENTRANCE: roomEntrance(); break;
                case ROOM_EXIT:     roomExit(); break;
                case ROOM_HALL:     roomHall(); break;
                case ROOM_GENERIC:  roomGeneric(); break;
            }
            
        }
        
        
        
        
        public function enterMaze(): void {
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE;
            mazePos = 0;
            setRoomType (ROOM_ENTRANCE);
            setRoomExits(encodeExits(false, false, false, true));
            playerLost = false;
            
            goToRoom(EAST);
            enterRoom();
        }
        
        public function roomGeneric(): void {
            roomMazeDescription();
            
            if (getMinotaur() || player.lust >= player.maxLust()) {
                mazeMinotaurEncounter();
                return;
            }
            
            roomMazeConfiguration();
            
        }
        public function roomHall() : void {
            outputText("You step into a large hall. You see the fountain in front of you. You may rest in alcove.");
            
            roomMazeConfiguration();
            
            addButton(0,  "Drink",  minoHallDrink);
            addButton(14, "Rest",   minoHallRest);
        }
        public function roomExit() : void {
            outputText("You are standing at the exit of the labirynth\n");
            cumStench = 0;
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_EXIT;
            doNext(playerMenu);
        }
        public function roomEntrance(): void {
            clearOutput();
            outputText("You are standing at the entrance of the labirynth\n");
            cumStench = 0;
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ENTRANCE;
            doNext(playerMenu);
        }
        
        
        
        public function     minoHallDrink():void {
            clearOutput();
            outputText("You drink from the fountain.\n\n");
            
            var choice : int =  description3;
            
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
                mutations.lactaid(player, false);
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
        
        public function     mazeStatusUpdate():void {
            outputText("<i>Your current position is " + mazePos + ", current map value is " + mazeMap[mazePos] + ". Cum stench level is " + cumStench + ".</i>\n\n");
            dynStats("lus", rand(cumStench));
            dynStats("lus", 10 * minoCumAddictionStrength() * cumStench);
            dynStats("lus", rand(player.cowScore() ) * cumStench * 0.5);
            if (flags[kFLAGS.HUNGER_ENABLED] > 0) {
                player.damageHunger(rand(10) / 10);
                if (player.hunger < 25) { 
                    outputText("<b>You have to eat something; your stomach is growling " + (player.hunger < 1 ? "painfully": "loudly") + ". </b>", false);
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
            dynStats("tou", -0.3 * rand(cumStench));
            dynStats("str", -0.3 * rand(cumStench));
            if (getFirstTimeLoss()) {
                outputText("<b>You realize that you are totally lost in the dungeons. You have no other hope but to press forward.</b>");
                setFirstTimeLoss(false);
            }
            
            getGame().mountain.minotaurScene.minoCumUpdate();
            

        }
        
        public  function    roomMazeDescription() : void {
            
            if (description1 == 0) {
                
                outputText("You follow a track of hooved markings on a ground and enter a cavern. The cavern is dimly lit by a flickering torch. The walls are crudely carved from a rock, the floor is uneven and the ceiling is very low. You feel the pressure of a mountain above you, hoping that soon you get out of the maze.");
                
            }
            else if (description1 == 1) {
                outputText("A cavern is lit by uneven light of a torch. You stand on a gravel floor of what looks like a large cavern. The ceiling is high above your head, hidden in the darkness. Some liquid is dripping from above, you are not sure if it is just water or something else. You see a rusty chain on the floor, and a couple of hooved tracks.");
            }
            else if (description1 == 2) {
                outputText("For a moment, you think you see a movement in the shadows, but it is just flickering light of a torch. Plain rocks gives way to a brick walls, gravel paths lit by dim lights. The maze looks the same in all directions, and you feel that you are completely lost here.");
            }
            else if (description1 == 3) {
                outputText("A strong feeling of deja vu raise in your head. The walls look too familiar. Have you already been here? You hear some distant cracking noises, and some moans. Or is it a wind? The brick walls are closing on you, the ceiling is too high to see in weak lights of a torch.");
            }
            

            if (description2 == 0) { 
                if (cumStench > 2 && minoCumAddictionStrength() > 0) {
                    if (cumStench < 4) outputText(" A thin smell of minotaurs cum permeates the air.");
                    else if (cumStench < 8) outputText(" You feel a smell of minotaurs cum in the air. You find it somewhat arousing."); 
                    else if (cumStench < 12) outputText(" You feel a strong smell of minotaurs cum. Your thoughts are constantly returning to the dwellers of the caverns. ");
                    else if (cumStench < 16) outputText("You feel a stench of minotaurs cum, the smell is so arousing that it becomes hard to thing anything but the cum. ");
                    else outputText("The incredibly strong smell of minotaurs cum make your head drum. With a great effort you try to focus yourself on walking. ");
                }
            }
            
            if (description3 == 1) {
                outputText("\n\nUnder you feet you see a puddle of something white. You turn in disgust.");
            }
            else if (description3 == 2) {
                outputText("\n\nYou feel a gust of fresh air. For a moment the smell of minotaurs cum becomes less strong, and you breathe with a relief.");
            }
            outputText("\n\n");
            

            
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
        
        public function     mazeMinotaurEncounter() : void {
            
            if (player.lust < player.maxLust()) {
                
                var choice:int = rand(3);
                if (choice == 0) {
                    outputText("The shadows from a torch move, but to your horror, you see a shadow that don't go away. A large beast is hiding in the darkness. It's a fight!\n\n");
                }
                else if (choice == 1) {
                    outputText("You look around you and pause, breathing heavily. You hear a light noise just behind you, as if someone is trying to hide. You turn back and your heart skips a bit - its a large minotaur!\n"); 
                }
                else if (choice == 2) {
                    outputText("Suddenly you hear a loud battlecry. This time you are ready for a fight!");
                }

            }
            if (rand(3) == 0) startCombat(new MinotaurLord(), false);
            else startCombat(new Minotaur(), false);
            monster.createStatusEffect(StatusEffects.MinoMazeFight, 0, 0, 0, 0);
            setMinotaur(false);
            doNext(playerMenu);            
            return;
            
            
        }
        private function    mazeMinotaurLossManyTimes() : void {
            dynStats("int", -20, "lib", 5, "sen", 15, "lus", 50, "cor", 10);
            player.refillHunger(50);
            player.minoCumAddiction(20);
        }
        public function     mazeMinotaurLoss() : void {
            if (!player.hasStatusEffect(StatusEffects.MinoMazeJustFought)) {
                player.createStatusEffect(StatusEffects.MinoMazeJustFought, 5, 0, 0, 0);
            }
            else player.changeStatusValue(StatusEffects.MinoMazeJustFought, 1, 5);
            // Text about stuff
            numLosses++;
            if (numLosses > 5) {
                mazeMinotaurLossManyTimes();
            }
            doNext(playerMenu);
        }
        public function     mazeMinotaurVictory() : void {
            if (!player.hasStatusEffect(StatusEffects.MinoMazeJustFought)) {
                player.createStatusEffect(StatusEffects.MinoMazeJustFought, 5, 0, 0, 0);
            }
            else player.changeStatusValue(StatusEffects.MinoMazeJustFought, 1, 5);
            // Text about winning 
            numLosses = 0;
            doNext(playerMenu);
        }
        
    }

}