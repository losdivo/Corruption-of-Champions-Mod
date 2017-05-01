package classes.Scenes.Dungeons.MinoTown 
{
    
    import classes.*;
	import classes.GlobalFlags.kGAMECLASS;
    import classes.GlobalFlags.kFLAGS;
    import classes.Scenes.Dungeons.DungeonCore;
    import classes.Scenes.Dungeons.DungeonAbstractContent;
    import classes.Scenes.Areas.Mountain.Minotaur;

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
         *    +1000*B,  where B encodes additional stuff:
         *          B  = visited? + 
         */
        private var mazeMap:Array;
        public  var WEST:   int;
        public  var EAST:   int;
        public  var NORTH:  int;
        public  var SOUTH:  int;
        public  var CENTER: int;
        
        public static const ROOM_UNDEFINED:int      = 0;
        public static const ROOM_GENERIC:int        = 1;
        public static const ROOM_HALL:int           = 2;
        public static const ROOM_ENTRANCE:int       = 3;
        public static const ROOM_EXIT:int           = 4;
        
        
        private var north:  int;
        private var south:  int;
        private var east:   int;
        private var west:   int;
        
        public function MinoMazeScene() {
            mazeMap = [0,0,0,0,0,  0,0,0,0,0,  0,0,0,0,0,  0,0,0,0,0,  0,0,0,0,0];
            WEST   = getRoomIndex( -1, 0);
            EAST   = getRoomIndex(  1, 0);
            NORTH  = getRoomIndex(  0, 1);
            SOUTH  = getRoomIndex(  0, -1);
            CENTER = getRoomIndex(  0, 0);
        }
        
        //{region Access to Rooms
        private function getRoomIndex   (x:int, y:int) : int {
            return 5 * (y + 2) + x + 2;
        }
        private function ndxWest        () : int {
            return getRoomIndex ( -1, 0);
        }
        private function ndxEast        () : int {
            return getRoomIndex (  1, 0);
        }
        private function ndxSouth       () : int {
            return getRoomIndex (  0, -1);
        }
        private function ndxNorth       () : int {
            return getRoomIndex (  0, 1);
        }        
        private function getRoomXY      (x:int, y:int) : int {
            if (x < -2 || x > 2 || y < -2 || y > 2) return 0;
            return mazeMap[ getRoomIndex(x,y) ]; 
        }
        private function getRoom        (ndx:int) : int {
            return mazeMap[ndx];
        }
        private function setRoomXY      (x:int, y:int, newRoom:int) : void {
            if (x < -2 || x > 2 || y < -2 || y > 2) { 
                trace("incorrect room index " + x + " - " + y);
                return;
            }
            mazeMap[ getRoomIndex(x,y) ] = newRoom; 
        }
        private function setRoom        (ndx:int, newRoom:int) : void {
            mazeMap[ndx] = newRoom;
        }
        private function getRoomTypeXY  (x:int, y:int) : int {
            if (x < -2 || x > 2 || y < -2 || y > 2) return 0;
            return mazeMap[ getRoomIndex(x,y) ] % 10;
        }
        private function getRoomType    (ndx : int) : int { 
            return mazeMap[ndx] % 10;
        }
        private function setRoomTypeXY  (x:int, y:int, newType:int) : void {
            if (x < -2 || x > 2 || y < -2 || y > 2) { 
                trace("incorrect room index " + x + " - " + y);
                return;
            }
            var ndx:int = getRoomIndex(x,y);
            mazeMap[ndx] = int(mazeMap[ndx] / 10) * 10 + newType;
        }
        private function setRoomType    (ndx : int, newType: int) : void {
            mazeMap[ndx] = int(mazeMap[ndx] / 10) * 10 + newType;
        }
        private function getRoomExitsXY (x:int, y:int) : int {
            if (x < -2 || x > 2 || y < -2 || y > 2) return 0;
            var ndx:int = getRoomIndex(x,y);
            return (mazeMap[ndx] / 10) % 100; 
        }
        private function getRoomExits   (ndx : int) : int {
            return (mazeMap[ndx] / 10) % 100; 
        }
        private function setRoomExitsXY (x:int, y:int, newExits:int) : void {
            if (x < -2 || x > 2 || y < -2 || y > 2) { 
                trace("incorrect room index " + x + " - " + y);
                return;
            }
            var ndx:int = getRoomIndex(x, y);
            mazeMap[ndx] = int (mazeMap[ndx] / 1000) * 1000 + 10 * newExits + mazeMap[ndx] % 10;
        }
        private function setRoomExits   (ndx:int, newExits:int) : void {
            mazeMap[ndx] = int (mazeMap[ndx] / 1000) * 1000 + 10 * newExits + mazeMap[ndx] % 10;
        }
        private function getRoomStuff   (x:int, y:int) : int {
            if (x < -2 || x > 2 || y < -2 || y > 2) return 0;
            return mazeMap[ getRoomIndex(x, y) ] / 1000;
        }
        private function setRoomStuff   (x:int, y:int, newStuff:int) : void {
            if (x < -2 || x > 2 || y < -2 || y > 2) { 
                trace("incorrect room index " + x + " - " + y);
            }
            var ndx:int = getRoomIndex(x, y);
            mazeMap[ndx] = newStuff * 1000 + mazeMap[ndx] % 1000;
        }
        private function hasPath        (ndx:int, direction:int) : Boolean {
            var exits:int = getRoomExits(ndx);
            if (direction == NORTH) return (exits % 2 >= 1);
            if (direction == SOUTH) return (exits % 4 >= 2);
            if (direction == WEST)  return (exits % 8 >= 4);
            if (direction == EAST)  return (exits >= 8);
            return false;
        }
        private function encodeExits    (inorth:Boolean, isouth:Boolean, iwest:Boolean, ieast:Boolean) : int {
            var exits:int = 0; 
            if (inorth) exits += 1;
            if (isouth) exits += 2;
            if (iwest)  exits += 4;
            if (ieast)  exits += 8;
            return exits;
        }
        //}endregion
        
        public function goToRoom            (direction: int): void {
            var y: int;
            var x: int;
            
            // scroll map
            switch (direction) {
                case NORTH:
                    for (y = -2; y <= 2; y++) for (x = -2; x <= 2; x++) setRoomXY(x, y, getRoomXY(x, y + 1));
                    break;   
                case SOUTH:
                    for (y =  2; y >=-2; y--) for (x = -2; x <= 2; x++) setRoomXY(x, y, getRoomXY(x, y - 1));
                    break;
                case EAST:
                    for (x = -2; x <= 2; x++) for (y = -2; y <= 2; y++) setRoomXY(x, y, getRoomXY(x + 1, y));
                    break;
                case WEST:
                    for (x =  2; x >=-2; x--) for (y = -2; y <= 2; y++) setRoomXY(x, y, getRoomXY(x - 1, y));
                    break;
            }

            north = getRoomType(NORTH);
            south = getRoomType(SOUTH);
            west  = getRoomType(WEST);
            east  = getRoomType(EAST);
            
            if (getRoomType (CENTER) == 0) setRoomType(CENTER, 1);
            if (getRoomExits(CENTER) == 0) {
                
                if ( east == 0 && (rand(2) == 0  || direction == WEST))  east = 1;
                if ( west == 0 && (rand(2) == 0  || direction == EAST))  west = 1;
                if ( south== 0 && (rand(3) == 0  || direction == NORTH)) south = 1;
                if ( north== 0 && (rand(3) == 0  || direction == SOUTH)) north = 1;
                
                if (rand(4) == 0 && south == 0) south = 2;
                if (rand(4) == 0 && north == 0) north = 2;
                
                if (north == 0 && south == 0 && west == 0 && east == 0) {
                    east = 1;
                    west = 1;
                }
                
                var familiarity: int = 15 - flags[kFLAGS.MINOTOWN_MAZE_TIMES_PASSED] * 2;
                if (familiarity < 5) familiarity = 5;
                familiarity = 20;
                
                if (direction == EAST && rand(familiarity) == 0 && east == 0) east = 4;
                if (direction == WEST && rand(familiarity) == 0 && west == 0) west = 3;
                
                setRoomType(WEST,  west);
                setRoomType(EAST,  east);
                setRoomType(NORTH, north);
                setRoomType(SOUTH, south);
                
                // Decoupling rooms from accessible rooms
                
                if (west  > 0 && getRoomExits(WEST) > 0   && !hasPath(WEST, EAST)) west = 0;
                if (east  > 0 && getRoomExits(EAST) > 0   && !hasPath(EAST, WEST)) east = 0;
                if (north > 0 && getRoomExits(NORTH) > 0  && !hasPath(NORTH, SOUTH)) north = 0;
                if (south > 0 && getRoomExits(SOUTH) > 0  && !hasPath(SOUTH, NORTH)) south = 0;
                
                // north? + 2*south? + 4*west? + 8*east?
                var paths:int = 0;
                if (north > 0) paths += 1;
                if (south > 0) paths += 2;
                if (west  > 0) paths += 4;
                if (east  > 0) paths += 8;
                setRoomExits(CENTER, paths);
            }
            
            north = hasPath(CENTER, NORTH) ? getRoomType(NORTH) : 0;
            south = hasPath(CENTER, SOUTH) ? getRoomType(SOUTH) : 0; 
            west  = hasPath(CENTER, WEST)  ? getRoomType(WEST)  : 0;
            east  = hasPath(CENTER, EAST)  ? getRoomType(EAST)  : 0;

            var eff:Array = [north, south, west, east];
            var eff2:Array = [DungeonCore.DUNGEON_MINO_MAZE_ROOM_NORTH, DungeonCore.DUNGEON_MINO_MAZE_ROOM_SOUTH, DungeonCore.DUNGEON_MINO_MAZE_ROOM_WEST, DungeonCore.DUNGEON_MINO_MAZE_ROOM_EAST];
            for (var i:int = 0; i < 4; i++) {
                if (eff[i] == 1) eff[i] = eff2[i];
                else if (eff[i] == 2) eff[i] = DungeonCore.DUNGEON_MINO_MAZE_HALL;
                else if (eff[i] == 3) eff[i] = DungeonCore.DUNGEON_MINO_MAZE_ENTRANCE;
                else if (eff[i] == 4) eff[i] = DungeonCore.DUNGEON_MINO_MAZE_EXIT;
                player.changeStatusValue(StatusEffects.MinoMazeConfiguration, i+1, eff[i]);
            }
            
            
            // Description
            if (!player.hasStatusEffect(StatusEffects.MinoMazeDescription)) {
                player.createStatusEffect(StatusEffects.MinoMazeDescription,0,0,0,0);
            }
            player.changeStatusValue(StatusEffects.MinoMazeDescription, 1, rand(4)); // General layout of the room
            player.changeStatusValue(StatusEffects.MinoMazeDescription, 2, rand(3) == 0 ? 1 : 0); // Comments on minotaur cum smell
            
            var choice:int = 0;
            if (kGAMECLASS.dungeonLoc == DungeonCore.DUNGEON_MINO_MAZE_ROOM_EAST) {
                choice = 1;
            }
            else {
                if (rand(4) == 0) choice = 2;
                else if (rand(6) == 0) choice = 1;
            }
            if  (choice == 1) {
                flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] += 1;
                if (rand(2) == 0) choice = 0;
            }
            else if (choice == 2) { 
                flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] -= 1;
                if (flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] < 0) flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] = 0;
                if (rand(2) == 0) choice = 0;
            }
            if (kGAMECLASS.dungeonLoc == DungeonCore.DUNGEON_MINO_MAZE_HALL) {
                choice = rand(5);
                if (choice < 3)  choice = 0;
                if (choice == 3) choice = 1;
                if (choice == 4) choice = 2;
                if (rand(10) == 0) choice = 3;
            }
            player.changeStatusValue(StatusEffects.MinoMazeDescription, 3, choice); // Cum puddle && wind gust
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
            roomMazeConfiguration();
            var type:int = getRoomType(CENTER);
            switch (type) {
                case ROOM_ENTRANCE: roomEntrance(); break;
                case ROOM_EXIT:     roomExit(); break;
                case ROOM_HALL:     roomHall(); break;
                
            }
            
        }
        public function enterMaze(): void {
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE;
            
            setRoomExits(CENTER, encodeExits(false, false, false, true));
            setRoomType (CENTER, ROOM_ENTRANCE);
            goToRoom(EAST);
            enterRoom();
        }
        
        public function roomHall() : void {
            clearOutput();
            outputText("You step into a large hall. You see the fountain in front of you. You may rest in alcove.");
            addButton(0,  "Drink",  minoHallDrink);
            addButton(14, "Rest",   minoHallRest);
        }
        public function roomExit() : void {
            
        }
        public function roomEntrance(): void {
            clearOutput();
            outputText("You are standing at the entrance of the labirynth\n");
            kGAMECLASS.dungeonLoc = DungeonCore.DUNGEON_MINO_MAZE_ENTRANCE;
            doNext(playerMenu);
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
            dynStats("lus", rand(flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]));
            dynStats("lus", 10 * minoCumAddictionStrength() * flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]);
            dynStats("lus", rand(player.cowScore() ) * flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH] * 0.5);
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
            dynStats("tou", -0.3 * rand(flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]));
            dynStats("str", -0.3 * rand(flags[kFLAGS.MINOTOWN_MAZE_CUMSTENCH]));
            getGame().mountain.minotaurScene.minoCumUpdate();
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