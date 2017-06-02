package classes.Scenes.Dungeons.MinoTown 
{
    
    import classes.*;
	import classes.GlobalFlags.kGAMECLASS;
    import classes.GlobalFlags.kFLAGS;
    import classes.Scenes.Dungeons.DungeonCore;
    import classes.Scenes.Dungeons.DungeonAbstractContent;
    import classes.Scenes.Areas.Mountain.Minotaur;
    import classes.Scenes.Quests.UrtaQuest.MinotaurLord;
    import classes.Scenes.Areas.HighMountains.MinotaurMobScene;
    import classes.Scenes.Areas.Mountain.MinotaurScene;

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
                for (var i:int = 0; i < maxPos; i++) mazeMap[i] = mazeMap[i + deltaPos];
                if (!playerLost) firstTimeLoss = true;
                playerLost = true;
                mazePos = maxPos;
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
            //setMinotaur(false);
            
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
            roomHallDescription();
            //outputText("You step into a large hall. You see the fountain in front of you. You may rest in alcove.");
            
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
            if (description1 == 0) outputText("You drink from the sink.\n\n");
            else if (description1 == 1) outputText("You suppress your disgust and drink from the rusty sink.\n\n");
            else if (description1 == 2) outputText("You drink from the marble sink.\n\n");
            else if (description1 == 3) outputText("You bend and dring from the vat.\n\n");
            
            var choice : int =  description3;
            HPChange(20 + player.maxHP() * 0.1 + rand(player.maxHP() * 0.2), true);
            player.changeFatigue( -25);
            player.refillHunger(10);
            
            if (choice == 0) {
                outputText("Strangely enough, you feel nothing happened to you\n\n");
                dynStats("lus", -20);
            }
            else if (choice == 1) {
                var tainted:Boolean = (rand(2) == 0);
                var enchanced:Boolean = tainted && (rand(5) == 0);
                mutations.laBova(tainted, enchanced, player, false);
            }
            else if (choice == 2) {
                lactaidFountain();
            }
            else if (choice == 3) {
                mutations.minotaurCum(false,player,false);
            }
            else if (choice == 4) {
                // succubi milk - only after a factory catastrophe
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
            outputText("<i>Your current position is " + mazePos + ", current map value is " + mazeMap[mazePos] + ". Cum stench level is " + cumStench + ". You've lost to minotaurs " + numLosses + " times.</i>\n\n");
            dynStats("lus", rand(cumStench));
            dynStats("lus", 10 * minoCumAddictionStrength() * cumStench);
            dynStats("lus", rand(player.cowScore() ) * cumStench * 0.5);
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
            dynStats("tou", -0.3 * rand(cumStench));
            dynStats("str", -0.3 * rand(cumStench));
            if (getFirstTimeLoss()) {
                outputText("<b>You realize that you are totally lost in the dungeons. You have no other hope but to press forward. </b>");
                setFirstTimeLoss(false);
            }
            
            getGame().mountain.minotaurScene.minoCumUpdate();
            

        }
        
        public  function    roomHallDescription() : void {
            
            var clue:Boolean = player.inte > 50 && player.cor < 30;
            var liquid:int = description3; 
            // 0 : normal
            // 1 : la Bova
            // 2 : Lactaid
            // 3 : minoCum
            // 4 : succubi milk
            
            
            if (description1 == 0) {
                outputText("You enter a huge cave, much larger than tight passages than you’ve encountered before. The cavern is lit by flickering torches. Your steps echo menacingly in the chember, as you walk pass. You hear a muted rumbling in the distance, the sound became quieter and then dies away.\n\n");
                
                outputText("As you walk, you notice an alcove with a large sink, filled with a ");
                if (clue) {
                    if      (liquid == 0 || liquid == 4) outputText("strange "); 
                    else if (liquid == 1) outputText("white creamy ");
                    else if (liquid == 2) outputText("white milky ");
                    else if (liquid == 3) outputText("white smelly ");
                }
                else {
                    outputText("strange ");
                }
                outputText("liquid.  From time to time drops of the same liquid fall from the stone extension above into a sink. ");
                outputText("In the alcove upposite the sink you see a used bedroll. Probably, you can make a small camp here to regain your strength. You even think of tasting the milk from the sink – maybe it will help regain some of your strength.\n\n");
            }
            else if (description1 == 1) {
                outputText("You step into a large cavern. There is a large pile of trash in the corner. You see what looks like rusted axes, broken swords and knives, shackles. After a quick glance you are confident that there is nothing useful there. You carefully avoid glass shards and metal pieces scattered on the floor.\n\n");
                outputText("Near the wall you see the metal sink, touched by a small amount of rust. Just above it you see remains of an iron pipe, which you guess once served as a tap. The sink is filled with what looks like a dark brown liquid – the color is due to rust and all the trash that is floating inside. ");
                if (clue) {
                    if      (liquid == 1) { // la Bova
                        outputText("You can make out hooves imprints in front of the sink.");
                    }
                    else if (liquid == 2) { // lact aid
                        outputText("You can make out something slimy covering the walls around the sink.");
                    }
                    else if (liquid == 3) { // mino cum
                        outputText("You can make out numerous tracks of hooves around the liquid.");
                    }
                    else if (liquid == 4) { // succubi milk
                        outputText("You can make out marks of demonic claws on the sink.");
                    }
                    
                }
                outputText("\n\n");
                outputText("You notice relatively clean niche in the rocky wall. Probably, no one would disturb you here if you rest to regain your strength. Despite your disgust, you are considering drinking from sink – whatever was there may lose its transformative power and could satisfy your hunger.\n\n");
            }
            else if (description1 == 2) {
                outputText("Somewhat unexpectedly you enter a large hall. The floor is made of dark marble, and you see traces of mosaic, depicting batal and sexual scenes with minotaurs, lit by uneven light of torches on the walls.\n\n");
                outputText("Right in the middle of the hall you see a pedestal and a huge statue of minotaur with erect dick, with a cow girl with huge tits and ass beneath. Something slimy is ");
                if (clue && liquid != 3) outputText("covering minotaur' dick and balls. ");
                else                     outputText("leaking from the minotaur' dick, trickles down to his balls and down on the hips and pussy of the cowgirl. ");
                outputText("You look closer and see that girls tits ");
                if (clue && liquid == 3) outputText("are huge with big swallen nipples. "); 
                else {
                    outputText("are leaking too, and the milk is flowing down in ");
                    if (liquid == 2) outputText("a white stream. ");
                    else if (liquid == 1) outputText("a creamy stream. ");
                    else outputText("thin trickles. ");
                }
                outputText("The liquids are mixing ");
                if (liquid == 4) outputText("with girl juices leaking from pussy ");
                outputText("and dripping from the pussy of cowgirl to a sink made of white marble.\n\n");
                
                
                outputText("There are smaller chapels on the sides of the altar. You think you could use one of the smaller room as a small camping place, to recuperate and regain your wits. You even think of tasting the liquid under the statue – maybe it will help regain some of your strength.\n\n");
            }
            else if (description1 == 3) {
                outputText("You enter a large hall with a lot of compartments made of wood. You see metallic tubes around devices scattered everywhere on the floor, and a small heap of hay laying in near the wool. The place has a look and smell of an abandoned barn. In every compartment there are belst belts and straps, in and a strange looking device. You guess that it a milking station, but now it is eerily empty.\n\n");
                outputText("You notice that every fold has a vat, and some even are filled with liquid. Judging by ");
                if (clue && liquid == 0) outputText("lack of ");
                outputText("smell, it may be ");
                if (clue && liquid == 0) outputText("just a water.");
                else {
                    outputText("water contaminated with ");
                    if (clue) {
                        if (liquid == 1) outputText("sour milk.");
                        else if (liquid == 2) outputText("milk.");
                        else if (liquid == 3) outputText("cream.");
                        else if (liquid == 4) outputText("something spicy, but you cannot figure out what it is.");
                    }
                    else outputText("something, but you cannot figure out what it is.");
                }
                outputText("\n\n");
                outputText("Each compartment has a place where you can comfortably lay down for a rest, and if you have enough courage, you can even drink some of the contents of the vat.\n\n");

            }
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
            else {
                numLosses++;
                if (numLosses > 5) {
                    if (player.hasVagina() && flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] >= 1 && player.inte < 20) {
                        minoMazeGangBangEnd();
                    }
                    else {
                        var moreChoice:int = rand(3);
                        if (moreChoice == 0)        minoMazeSuck();
                        else if (moreChoice == 1)   minoSuckHard();
                        else                        minoMazeGangBang();
                        
                    }
                    return;
                }
                else {
                    
                    if (rand(2) == 0 && player.buttRating >= 15 && player.vaginalCapacity() < monster.biggestCockArea() && player.tone < 60) {
                        getGame().mountain.minotaurScene.getMinoHawtDawged();
			            return;
                    }
                    if (rand(2) == 0 && !player.isTaur()) {
                        getGame().mountain.minotaurScene.getOralRapedByMinotaur();
                        return;
                    }
                }
                
            }
            
            if (rand(3) == 0) startCombat(new MinotaurLord(), false);
            else startCombat(new Minotaur(), false);
            monster.createStatusEffect(StatusEffects.MinoMazeFight, 0, 0, 0, 0);
            setMinotaur(false);
            doNext(playerMenu);            
            return;
            
            
        }

        public function     mazeMinotaurLoss() : void {
            // Text about stuff
            numLosses++;
            doNext(playerMenu);
        }
        public function     mazeMinotaurVictory() : void {
            // Text about winning 
            numLosses = 0;
            doNext(playerMenu);
        }
        
        public function     minoMazeSuck() : void {
            
            
            outputText("A huge minotaur have appeared from behind the corner and gives you a predatory smile.  He puts down the axe he was sharpening and strides over, his loincloth nearly tearing itself from his groin as his member inflates to full size.  Amazingly, this minotaur bothers to speak, \"<i>New fuck-toy.  Suck.</i>\"\n\n");
	
	        outputText("His words are music to your ears.  Crawling forwards, you wallow in the dirt until you're prostrate before him.  Looking up with wide eyes, you grip him in your hands and give him a gentle squeeze.  You open wide, struggling to fit his girthy member into your eager mouth, but you manage.  A drop of pre-cum rewards your efforts, and you happily plunge forwards, opening wider as he slips into the back of your throat.  Miraculously, your powerful needs have overcome your gag reflex, and you're gurgling noisily as your tongue slides along the underside of his cock, massaging him.\n\n");
	
	        outputText("\"<i>Need... more!</i>\" grunts the beast, grabbing you around the neck and pulling you upwards, forcing himself further and further into your throat.   Normally being unable to breathe would incite panic, but the pre-cum dripping into your gullet blasts away the worry in your mind.   You're face-fucked hard and fast until you feel your master's cock swelling with pleasure inside your throat.  It unloads a thick batch of creamy minotaur jism directly into your stomach, rewarding you until your belly bulges out with the appearance of a mild pregnancy.\n\n");
            player.buttChange(60,true,true,false);
	
	        outputText("Your master pulls out and fastens a leather collar around your neck before dragging you through the cave.  Between the tugging of your collar and rough throat-fucking, you're breathless and gasping, but you couldn't be any happier.  Your new owner lifts you up by your " + player.assDescript() + " and forces himself inside your " + player.assholeDescript() + ", stuffing you full of thick minotaur cock.  Still heavily drugged by the load in your gut, you giggle happily as you're bounced up and down, totally relaxed in your master's presence.\n\n");
	
	        outputText("He grunts and cums inside you for the second time, somehow still able to flood your bowels with what feels like a gallon of cum.  Drooling brainlessly, happy gurgles trickle from your throat as you're pulled off and tossed to the side.  You don't feel the impact of your body landing in the mud, or even notice when you're passed around the cave, broken in as each of your new monstrous masters has his turn.");
            player.orgasm("Anal");
            dynStats("int", -20, "lib", 5, "sen", 15, "lus", 50, "cor", 10);
            player.refillHunger(50);
            player.minoCumAddiction(20);
            
            if (flags[kFLAGS.MINOTAUR_CUM_ADDICTION_STATE] >= 1 && player.inte < 20) { 
                doNext(minoMazeBadEnd);
            }
            else doNext(playerMenu);
        }
        public function     minoMazeBadEnd() : void {
            spriteSelect(44);
	        hideUpDown();
	        clearOutput();
	        outputText("Days and weeks pass in a half-remembered haze.  You're violated countless time, and after the first day they don't even bother to keep you on a leash.  Why would they need to restrain such an eager slave?  You're tossed to the side whenever you're not needed as a cum-dump, but as soon as you start to come out of your daze, you crawl back, gaping, dripping, and ready for another dose.  For their part, your new masters seem happy to take care of your needs.  The only time you aren't drugged is when the minotaurs are sleeping, but the minitaurs seem all too happy to let you suckle the pre from their tiny horse-cocks in the huddled slave-pile.\n\n");
	
	        outputText("You are no longer the Champion of your village.  The only thing you're a champion of is cum-guzzling.  You take immense pride in showing the other cum-sluts just how many thick loads you can coax from your horny masters every day.  Life couldn't be any better.");
	        getGame().gameOver();
	        dynStats("int", -1, "lib", 5, "sen", 30, "lus=", 100, "cor", 20);
        }
        
        public function     minoMazeGangBang() : void {
            spriteSelect(94);
            outputText("Three minotaurs have appeared from behind the rust-red rocks, arranged in a crude half-circle with you at the center.  Two of them are huge, powerfully-built bulls, stomping their hooved feet and snorting idly as they circle you.  Judging from the similar shapes and sizes of their muzzles and eyes, you'd guess they were brothers.\n\n");
	        outputText("The minotaurs step closer as they approach your prone body.  You lift your head, nose twitching, and breathe their scent deeply while casting a coy look at the closest of the mob.  He smiles and squeezes his fingers around your jaw, pulling your mouth into a pouty 'o'.  His other hand holds the heavy mass of his stiff maleness - a turgid, flared shaft over two feet long with three prominent ridges along its length.  You shiver and lick your lips unconsciously, tasting the sweet smell of his pre in the air as it inches closer.\n\n");
	
            if (player.isTaur()) {
                outputText("A sudden, forceful push rolls your equine body onto its flank, and a larger member is pressed against your clutching ");
                if (player.tailType == TAIL_TYPE_NONE) outputText("asshole");
                else outputText("tailhole");
                outputText(".  ");
            }
            else if (player.isNaga()) outputText("A sudden, forceful yank stretches out your tail, and a larger member presses between your " + player.buttDescript() + " to prod at your clutching asshole.  ");
            else if (player.isGoo()) {
                outputText("A sudden, forceful push rolls you to your side, and you feel shaggy fur rubbing through your gooey folds while a larger member is pressed against your clutching ");
                if (player.tailType == TAIL_TYPE_NONE) outputText("asshole");
                else outputText("tailhole");
                outputText(".  ");
            }
            else {
                outputText("A sudden, powerful yank lifts one of your legs high into the air, and you feel a larger member pressing against your clutching ");
                if (player.tailType == TAIL_TYPE_NONE) outputText("asshole");
                else outputText("tailhole");
                outputText(".  ");
            }
            outputText("The cruel, flared tip of the horse-like cock batters at the unyielding entrance for a moment, slowly stretching your rectal orifice wider and wider with each painful push.  Gasping in pain, you cry out in anguish before transitioning into a low moan.  The dripping member before you plunges into your open orifice, pre-cum lubricating its passage as the flare is pushed to the back of your throat.  Ordinarily your body might try to reject such an intrusion, but all you feel is a numb sort of acceptance as you relax your throat to let the pre-cum roll into your belly.");
            outputText("\n\n");
	
            outputText("The pressure on your " + player.assholeDescript() + " suddenly subsides, not because the minotaur is pulling back, but because part of the flare suddenly slipped through the ring of your tightly-stretched hole.  You swoon and try to relax, fighting with your sphincter's natural reaction to squeeze shut against the intruder.  A pleased rumble echoes behind you, and the minotaur penetrating your " + player.assholeDescript() + " pushes hard.  His flare slips inside with an audible, gut-stretching 'pop'.  ");
            player.buttChange(60,true,true,false);
	        outputText("  You can do naught but gurgle as the dual minotaur dicks each push deeper and completely, utterly spit-roasting you on their incestuous hardnesses.\n\n");
	
	        outputText("Inch by inch, the double dicks penetrate further, bulging your neck and gut around the growing flares.  You can actually feel their leaky, drug-like pre-cum burbling out to fill your belly and slip into your intestines.  It gives you a nice, pain-numbing high that makes it easy to handle the plus-sized members currently lifting you from the ground. Their hands move to grab at your midriff, helping to steady your aerial form between them.  As you're leveled at waist height, the last few inches of the throbbing, drug-leaking cocks push inside your holes.  Their two sweaty ballsacks clap against your " + player.buttDescript() + " and chin simultaneously.\n\n");
	            
            if (player.hasVagina()) {
	            outputText("Your bovine masters begin to saw their throbbing members back and forth with long, orifice-scraping strokes.  It should be painful, but it only stirs the coals of your aphrodisiac-fueled fire. Your pussy ");
                if (player.wetness() >= 5) outputText("gushes everywhere with each thrust, puddling your lubricants on the ground");
                else if (player.wetness() >= 3) outputText("drools a thick stream of lubricants to puddle on the ground with each thrust.");
                else outputText("drips lubricant with every thrust, leaving tiny blotches of wetness on the ground.");
                outputText("  Bouncing between them like a child's ball, your body is battered, abused, and used for nothing more than a few minute's pleasure.  Every time the throat-obstructing mass pulls from your mouth you take another deep breath, staying conscious, but becoming more aroused by the omnipresent stench of the horny beasts.\n\n");
            }
	
	        outputText("The minotaur occupying your mouth grabs hold of your ");
            if (player.horns > 0) outputText("horns ");
            else outputText("head ");
	        outputText("and roughly buries his cock in your mouth, all the way to the hilt.  His pre-cum stops, and the balls on your chin begin to bounce as the beast's animalistic, three-ribbed member starts to widen inside you.  Your jaw stretches slightly, and you feel a huge wad of cum distend the urethra along the bottom of his shaft.  Working towards your belly, the mass bursts from his tip explosively, making your gut gurgle audibly as it receives its first injection of minotaur spunk.\n\n");
	
	        outputText("Expanding in the moment of penultimate pleasure, the minotaur's tip flares wide, effectively sealing your esophagus shut.  The furry sack bobs on your chin, the heavy balls inside slowly shrinking as they empty their lust-inducing, thought-removing cargo into your deepest recesses");
	        if (player.cor >= 66) outputText(".  You couldn't be happier about it");
	        outputText(".   The bulges of cum squeezing past your thrashing, excited tongue slowly grow smaller and smaller as the spoogey goodness is inexorably emptied from the poor, pumped-up testes on your chin.  They give a tiny shudder and stop, and the minotaur pulls back at last, slowly softening to ease his passage from your abused throat hole.\n\n");
	
	        outputText("Once free, the beast wipes the mess from the tip of his fat cock on your lips. He pushes you back towards the one violating your " + player.assholeDescript() + ", allowing him to support you.  You groan at the rough treatment while licking at the delicious glaze on your lips.  The potent sperm in your throat and stomach have already shut down any thoughts more complex than 'find cum' and 'fuck'.\n\n");
            if (player.hasVagina()) {
    	        outputText("The rock-solid mass of muscle holding you aloft softens, and your body weight drags you down.  Your juicy twat and abused anus throb, impaled on your own offspring's penises.  ");
	            player.cuntChange(60,true,false,true);
	            outputText("They part your flesh with ease, sheathing themselves deeply in your body and rubbing against each other through the narrow divide inside you.  Your asshole tingles, actually finding more pleasure from the act than your suddenly-stretched vagina thanks to the more comfortable pole residing in its depths.  They go deeper and deeper, until the stud supporting you is pushing on your distended cervix while his sheath bunches up against your outer lips.\n\n");
	            outputText("A huge, bloated mass stretches past your pussy lips, forcing out a squirt of girlcum and feminine lube.  ");
	            player.cuntChange(60,true,false,true);
	            outputText("The head flares wide as it squirts into your womb; warmth blooms from the uterine cum-deposit, turning your muscles slack, and setting off an orgasm of your own.  Your pussy ripples and squeezes at the invader, matched in its orgasmic contractions by your cock-stuffed asshole.  The minitaur behind you whines and hilts himself as hard as his relatively lithe body will allow, slapping his balls into his brother's slowly emptying cum-sacks.");
                if (player.hasCock()) {
                    outputText("  " + player.SMultiCockDesc() + " explodes against the minotaur's belly, weakly spurting ");
                    if (player.cumQ() < 25) outputText("a few spots of cum into his sweat-matted fur.");
                    else if (player.cumQ() < 50) outputText("a steady trickle of cum into his fur.");
                    else if (player.cumQ() < 100) outputText("a steady stream of cum into his matted fur.");
                    else outputText("a constant flow of cum that utterly soaks the minotaur's fur and balls with your wasted, inferior seed.");
                }
                outputText("\n\n");
            }
	
	        outputText("Completely impaled, drugged out of your mind, and being packed with ever-higher levels of narcotics, you lose your mind mid-orgasm. As little more than an instinctual fuck-beast, you moan lewdly and lick the sweat from your son's hairy body, cooing in pleasure at the feel of your two studs flooding your [vagorass] with gooey love.  The heaving balls below you shake and squirm, visibly shrinking with each lurching, hole-stretching pump. Your body trembles from the orgasmic assault, the white-hot pleasure of your orgasm seeming to burn out your capacity for thought until nothing is left in its wake but satisfaction.\n\n");
	
	        outputText("Distracted by the high, you barely realize the shaft has been pulled from your pulverized [vagorass].  You're dropped to the dirt, and the still-cumming minotaur is pulled down by his flared rod to fall heavily atop you.  He kisses and licks you while he cums, gently bathing you in affection while he sates himself with your body.  For such a bestial, corrupt creature, he's truly a gentle lover.\n\n");
	
	        outputText("The minotaur stays inside you, reaching to rub your puffy, red nether-lips as he goes soft in your depths.  The hesitation gives his cum time to absorb through the lining of your intestine.  Once he pulls out, the world is spinning around you, but you try to crawl to ");
	        if (flags[kFLAGS.ADULT_MINOTAUR_OFFSPRINGS] <= 3) outputText(" the minotaur that gave you your first dose.  Maybe he's ready to give you more? He smirks and slaps you across the face with his soft shaft.  You giggle drunkenly and start to lick his balls - they HAVE to have more for you!  ");
	        else {
		        outputText(" a minotaur that hasn't had his chance to take you yet.  The beast laughs and smiles, pulling you to your knees.  ");
		        //(1-2 more end paragraph) 
                if (flags[kFLAGS.ADULT_MINOTAUR_OFFSPRINGS] <= 5) outputText("You open your mouth wide, licking your lips until they're shiny and inviting enough for the stud to fuck.  He does not disappoint.  The fat head pushes past your puckered cock-suckers and slides into your throat, the passage eased by the leavings of the one before him.  You sigh happily and begin to suck his cock like a lollipop, though all you want is his creamy center.  The others crowd around, touching themselves and waiting for another turn.  ");
                else outputText("You open your mouth wide, licking your lips until they're shiny and inviting enough for the stud to fuck.  He does not disappoint.  The fat head pushes past your puckered cock-suckers and slides into your throat, the passage eased by the leavings of the one before him.  You sigh happily and begin to suck his cock like a lollipop, though all you want is his creamy center.  Two more swollen fuck-sticks find their way to your waiting holes, and you giggle in dizzy bliss when you're packed full of your sons spunk once again.  ");
	        }
	        outputText("You black out at that point, but when you wake up soaked in cum with a bottle of it next to you.");
	        //Force cum bottle loot!
	        flags[kFLAGS.BONUS_ITEM_AFTER_COMBAT_ID] = consumables.MINOCUM.id;
	//Preggers chance!
	        if (player.hasVagina()) player.knockUp(PregnancyStore.PREGNANCY_MINOTAUR, PregnancyStore.INCUBATION_MINOTAUR, 75);
	        player.orgasm('VaginalAnal');
	        dynStats("spe", -.5, "int", -20, "lib", .5, "sen", -.5, "cor", 1);
	        player.slimeFeed();
	        player.minoCumAddiction(20);
            player.refillHunger(50);
            doNext(playerMenu);     
        }
        
        public function     minoMazeGangBangEnd() : void { // VAG
            clearOutput();
            outputText("Three minotaurs have appeared from behind the rust-red rocks, arranged in a crude half-circle with you at the center.  Two of them are huge, powerfully-built bulls, stomping their hooved feet and snorting idly as they circle you.  Judging from the similar shapes and sizes of their muzzles and eyes, you'd guess they were brothers.\n\n");
	        spriteSelect(94);
	        outputText("Slumping down to your knees, you look up at the crowd surrounding you.  There're dozens of horny, bestial figures, all of their bovine faces twisted into leering smiles at your state.   You can smell the thick musk in the air, hanging so heavily that it seems to fog your view.  Sniffing in great lungfuls of it, you slump back and let your " + player.legs() + " spread out of their own accord, utterly revealing the folds of your " + player.vaginaDescript() + " to the horny beast-men.  They cluster around you, their loincloths disappearing in a hurry in their rush to fuck their incestuous mother.  Images of all the other times you've been in a similar situation run through your head, the thoughts blurring together into a vision of one long, drug-fueled fuck.\n\n");
	
	        outputText("Giggling, you realize a scene much like that is about to happen to you all over again.  A dribble of fem-slime leaks out from your " + player.vaginaDescript() + " into the dry mountain dirt, showing your boys just how excited you are to be on the receiving end of their dripping horse-cocks.\n\n");
	
	        outputText("Sweat-slicked muscles wrap around your slack, delirious form and heft you onto a strong shoulder.  A gentle voice as deep as the rumble of a rockslide says, \"<i>Come on, there's no sense in you hiding from us anymore.</i>\"  They're taking you away out of the labirynth, back to a village.  Idly, you wonder if there's even more of the sexy... strong... handsome bulls there to violate you.  Maybe they've got even bigger cocks than their brothers!  You sink so deeply into your fantasies at that point that the only outward hint of your consciousness is the occasional whimper and accompanying squirt of slime down the brute's back.\n\n");
	
	        outputText("Suddenly, you're dropped from your perch into a pile of cushiony pillows, your body flopping like a ragdoll as it pomfs into pillowy softness.  Looking around, you realize you're inside a crude hut that's absolutely filled with pillows, and you aren't the only one there!  Other people are sprawling out in the mound of mattresses, all of them naked and most of them pregnant.  Offhand, you spy a goblin so gravid you doubt she can move, a wolf-morph with cum-matted fur, a centauress with massive, milky breasts, and a cow-girl who's as busy playing with her swollen clit as she is stroking the taut skin of her baby-filled belly.  There're a few others bodies half-buried in pillows and blankets, but they seem to be sleeping too deep in the fluff for you to get any details.\n\n");
	
	        outputText("This place seems quite pleasant, though the other girls seem to be looking at you with barely-concealed jealousy bordering on rage.  A svelte figure steps through the shade.  You recognize him as the smallest of your brood, the minitaur.   He's completely naked, and though his pheromones are weaker than his larger kin, his mere presence is enough to make your pussy sloppy-wet.  The other girls crawl towards him, pawing at his legs and promising him the velvet tightness of their pussies.  His dick goes rock hard and immediately sets to dripping all over them, his need painfully visible by the trembling of his balls and the blood pulsing through his swollen cock.\n\n");
	
	        outputText("The runt forces his way through the girls, ignoring their pouts of disappointment as he comes to you.  \"<i>Hey... the others are still celebrating adding you to the harem.  I thought maybe I could make sure you're adjusting, and... umm, if you're okay with it, I'm REALLY pent up.  They don't usually let me into the harem,</i>\" admits the minitaur, looking back at the door with a bit of worry in his eyes.\n\n");
	
	        outputText("You giggle.  Lazing around all day and getting to suck the cum from dozens of minotaurs all the time?  This is heaven.  Sure, you were supposed to be out there fighting the demons, but you kept letting the big, hairy beasts force themselves on you over and over, until you weren't even sure why you were resisting.  Now?  There's a dick with a drizzle of pre-cum leaking from the tip, just asking for you to slurp the cum out of it.  You'll stay anywhere if it means you get to suck it down and feel it exploding in your soaked nethers.\n\n");
	
	        outputText("Nodding, you give the poor boy a lick, gripping his swollen shaft in your hand as you reach down to undo your " + player.armorName + ".  You jump when the only thing your fingers bump into is your own " + player.skinFurScales() + ".  It seems that during the journey here all your gear was removed from your body.  You're as naked as any of the other sluts in here!  At least your nudity will make it even easier for you to get the poor guy off.  Clothing yourself seems a wasted effort at this point.\n\n");
	
	        outputText("Cupping the heavy, shuddering ball-sack in your hand, you stroke the small minotaur's trembling shaft, setting off shivers of pleasure each time your fingers rub over the sensitive skin of his dick's three medial ridges.  Teasingly, you circle your tongue around his flare a few times, catching the fresh drops of pre that roll from his urethral opening to funnel back into your mouth.  He gasps, clearly loving your touches and wanting to blow, but unable from a few licks and a handjob alone.  Sensing his need, you ram the flat, wide-spread tip of his dick through your lips and suck hard, fully engorging his flare while your spit soaks into his bestial skin.\n\n");
	
	        outputText("You give the tiny beast-man's heavy balls a loving squeeze and jerk back, letting the swollen dick pop out of your oral prison and hang there, wet with saliva.  Shaking with a need of your own, you rise and bend ");
            if (!player.isNaga()) outputText("over");
            else outputText("back, snake-like");
            outputText(" to present your " + player.vaginaDescript() + "'s needy opening to the smallest of your sons.  It's all the invitation he needs.  The rigid tool between his thighs shoots forward, lodging the animalistic head in your well-lubricated opening and giving your sloppy lips a burst of exquisite pleasure.  Sliding forward, the magnificent minotaur tool buries itself in your sopping cunt as if it was meant to be there, its passage made easy by spit, potent mino-spunk, and your own liquid need.\n\n");
            
            outputText("The minitaur looks down at you with a thankful expression on his monstrous muzzle.  The image is only broken by the lusty way he lets his tongue hang from his mouth as he mounts you, a few drops of saliva falling as he forgets himself in the passion of taking you.  A tiny rivulet of his constant, dripping pre-seed escapes from around his girth as he pushes in, finally butting his tip at your cervix, the slack skin of his sheath seeming to caress your labia and clitoris.  You squeal in happiness, feeling warmth spread outward from your pussy as more of his essence dribbles inside of you.\n\n");
            
            outputText("Already experiencing a pleasant buzz and tingle, you grab his hips and throw yourself against him, bouncing the both of you in the pillowy room, grunts and moans of passion teasing the other girls as you're fucked with wild abandon by one they crave.  Your " + player.vaginaDescript() + " is like a furnace of lust, the fires of need inside only growing hotter with every stroke of wonderful minotaur-cock.  Panting, the smallest of your beast-men does his best to fuck you, and though his member is nowhere near as large as his brother's swollen shafts, the thick, pent-up drugs he's dripping into your uterus are keeping you so close the edge.\n\n");
            
            outputText("You feel like you're floating, cushioned in a bed of clouds with every nerve firing off nothing but pleasure and happiness.  There's a wet, slap-slap-slap nagging at you, but you close your eyes and forget it, letting your fingers play across your " + player.chestDesc() + " to ");
            if (player.hasFuckableNipples()) outputText("slide inside your nipple-cunts and finger your chest pussies in a small approximation of what's happening below.");
            else if (player.biggestLactation() >= 1) outputText("tug and pull at your drippy nipples, releasing thick flows of creamy milk.");
            else outputText("tug at your achy nipples.");
            outputText("  Moaning like a whore, you gasp and pant under your bovine lover, lost to the world and nearly screaming in delight each time your " + player.vaginaDescript(0) + " contracts around its invader.  Your eyes roll back and you howl, finally obtaining the climax you've desired.  The knowledge that it's your son's rough fucking that's getting you off only makes the orgasm stronger.  Realizing you'll never leave this place, you accept your fate and let your body tell you what to do, and for now, what it wants to do is keep cumming.\n\n");
            
            outputText("The rhythmic contractions around his rod set off the minitaur.  His heavy balls bounce against your body as they churn and jiggle, pumping an obscene amount of cum through the thick cock lodged in your twat.  You can feel his flare straining at your cervix, the urethra pumping a torrent of spooge ");
            if (player.pregnancyIncubation == 0) outputText("inside your empty womb");
            else outputText("against the plugged entrance of your pregnant womb");
            outputText(", releasing so much that a squirt of it escapes to run down your " + player.leg() + ".  That was just the first spurt!  The second burst of semen fills every nook and cranny of your " + player.vaginaDescript() + ", your entrance turning to a frothy mess of white goo and slippery lady-spunk.  The pent-up pecker keeps flexing in orgasm, firing jet after jet of narcotic cream into your semen-spurting box, the pillows under you quickly soaking up the excess, addictive jizz.\n\n");
            
            outputText("Your son sighs and slumps down, his cock slowly slipping from your abused vulva, escaping with a wet 'pop'.  A river of white rolls out of your body to further stain the room's furnishings.  You shudder from the sensation as a it triggers a series of tiny, miniature climaxes.  While you're lost to the pleasure, the minitaur departs with noticeably less bulge in his loincloth.  At the same time, the other girls crowd around you, scooping up what they can save of your boy's liquid love and shoveling it into their greedy, whorish maws.  The cow-girl industriously sets to work, using her massive tongue on your " + player.vaginaDescript() + " to scoop out every drop she can get.  You cum on her face, splattering her with spooge and your feminine moisture.  She smiles and kisses your still-sensitive clit, throwing you into a black-out inducing orgasm.");
            player.orgasm('Vaginal');
            dynStats("int", -10, "lib", 10, "sen", 10);
            doNext(getGame().highMountains.minotaurMobScene.minotaurGangBadEnd2);
        }
        
        public function     minoSuckHard() : void {
            clearOutput();
	        player.minoCumAddiction(10);
	        player.slimeFeed();
	        outputText("As you turn around the corner, a familiar, heavenly scent catches your nose and wicks into your brain, flooding you with need and molten-hot lust. Your sigh dreamily while your pupils slowly dilate from the familiar chemicals pounding through your bloodstream");
	        if (player.hasVagina()) outputText(" and puffing up your twat with liquid arousal.\n\n");
	        else if (player.hasCock()) outputText(" and turning " + player.sMultiCockDesc() + " into a turgid, pulsating mass.\n\n");
	        else outputText("\n\n");
	
	        outputText("You push your way, tearing off your " + player.armorName + " as you go.  The animal part of your brain recognizes that such needless trapping would just get in the way of all the thick, dripping, minotaur spunk just waiting to pump inside you.  You drool spittle down your neck while you lose yourself in the memory of that taste on your tongue, letting your body seek it out on autopilot.");
            if (player.hasVagina() || player.hasCock()) {
                outputText("  A trail of ");
                if (player.hasVagina()) {
                    outputText("female slime ");
                    if (player.hasCock()) outputText("and ");
                }
                if (player.hasCock()) {
                    if (player.cumQ() < 100) outputText("pre-cum ");
                    else if (player.cumQ() < 500) outputText("pre-cum a few inches wide ");
                    else outputText("pre-cum over a foot wide ");
                }
                outputText("winds over the rough-hewn floor behind you, clearly marking your passage to the overpowering musk.");
            }
	        outputText("\n\n");
	
	        outputText("You saunter forwards, hips swaying sensually as the drug-like desire of potent minotaur musk pulls you ever closer.  Mewling happily, you take minotaur cock in hand and stroke along its length, giggling as it pulses and leaks a stream of heavenly goo down your arm.   You lick it from your arm in one long, languid motion before pursing your lips around the minotaur's flared tip and sucking it hard as you quest for more of its heady ambrosia.\n\n"); 
	
	        outputText("You hear a deep, strangled sigh as more and more delicious pre floods your mouth, lighting your senses up with a fireworks show of pleasure");
	        if (player.gender > 0) outputText(" and increasing the size of the puddle you're leaving on the floor");
	        outputText(".  In between gulps of the fragrant fluid, you suck the swollen rod deeper and deeper into your mouth, gleefully suppressing your gag reflex as it pushes aside your uvula.  You work your throat, feverishly swallowing to suck it down.  A flare briefly distends your neck as it's taken deeper and deeper inside your form until your lips are puckered through the hole and you're sniffing the minotaur's pheromone-laced crotch.\n\n");
	
	        outputText("The beast pulls back and starts pounding, letting out deep, rumbling sighs of pleasure with each throat abusing fuck.  If it weren't for his constant, bubbling preseed turning your throat to a slippery rut-hole you'd be rubbed raw, but instead you continue to lean forward, sniffing at his matted pubes every time he crushes them against your dick-stretched lips.  The other horny studs grunt with displeasure, but you reach out with your hands and grab hold two eager brutes' throbbing horsecocks.  Three out-of-sync heartbeats hammer through your hands and throat while you do your best to get them all off.\n\n"); 
	
	        outputText("You let your eyes drift closed and lash your tongue back and forth across the minotaur's lowest medial ring, feeling his flare bulge larger inside you in response.  The beast-man batters at the wall, grunting in equal measures of passion and pent-up desire as his cock's tip stretches wide and locks itself inside you.  His urethra bulges in rhythmic contractions, stretching your lips around the already swollen shaft and signaling to your musk-addled mind that you're about to get what you desire.  You hum with blissful delight as your belly begins to gurgle, accepting long bursts of sticky minotaur drug.\n\n");
	
	        outputText("Tied down by the cum-spurting flare locked in your gullet, you pump on the other two dicks with feverish speed and sway on your " + player.feet() + " as the narcotic spooge intoxicates your already-addled mind.  You can feel each muscular contraction pulsing through the bestial shaft while it finishes depositing the heavy, sticky load, and your eyes cross from the viscous inebriation that's pooling in your belly.  Drizzles of pre-cum soak into your arms and palms, drawn out from the frenzied pumping of your fists.  They won't come from just a hand though.  They need something... tighter.\n\n");
	
	        outputText("You start moaning in drug-induced bliss, but your vocalized pleasure is interrupted by the squelching slurp of the softening shaft being pulled from your dick-puckered lips.  It drips a rope of cum over your mouth and chin as it pulls free from the wall, leaving behind one vacancy among the swarm of ready minotaur dicks.  You lick up your stud's leavings and purr in bliss, reaching through the hole to cup the departing minotaur's balls teasingly.  He grunts and walks out of your grip – sated for now.\n\n");
	
	        outputText("The beast who kept your left hand so busy repositions himself at the now-vacant opening, and you decide to reward him for moving so quickly.  You lick the last of the salty cream from your lips and muse that he isn't the only one getting a reward, but the monstrous cow-man doesn't need to know that.");
	        if (player.biggestTitSize() >= 2) {
		        outputText("  You wrap the pillowy flesh of your " + player.allBreastsDescript() + " around the new member, pleasantly surprised by its girth and wide, already-flared tip.  Maybe you could have gotten him off with your hands after all?  ");
		        if (player.biggestTitSize() < 6) outputText("Even so, you can't quite get your breasts the entire way around him, so you make up for it by pressing it harder into you with your busy hands.  ");
		    outputText("Runnels of pre cover the shaft and squish wetly between your tits, turning your body into a slip-n-slide that reeks of hot, sticky minotaur sex.");
	        }
	        else {
		        outputText("You crush the member tightly against your chest, smearing your torso with the copious pre until you're like a hot, wet slip-n-slide of minotaur sex.  You make up for it by wrapping your arms around his prodigious thickness and squeeze him tightly with your hands, stroking him off with your whole body with enough tightness to make the poor mino' think he's in some poor adventurer's asshole.");
	        }
	        outputText("\n\n");
	
            outputText("You lower and raise yourself, bouncing up and down on your " + player.legs() + " to enhance the ");
            if (player.biggestTitSize() >= 2) outputText("tit-fucking ");
            else outputText("full-body handjob ");
            outputText("you're giving out.  In such a position, you're given the perfect view to watch as your strokes draw forth large bubbles of pre, and before you can lose your high, you latch onto the minotaur's vulnerable urethra and suck, tonguing in wide circles around it since you can't open wide enough to accommodate his flare.  Of course, all the attention just makes him flare wider, not just at the tip, but through the whole shaft.  ");
            if (player.biggestTitSize() >= 2) outputText("The sudden girth change sends an enticing ripple through your " + player.allBreastsDescript() + " that's pleasurable enough to make you moan into his steadily-widening urethra.  ");
            outputText("You pull off and bounce faster, lost to your lust and the haze of sex-musk permeating the air, intent on seeing just how much this huge stud can spray onto you.\n\n");

	        outputText("The minotaur does not disappoint.  His hole dilates from the size of the approaching cum-blast, and you sink down his shaft slowly until it's aimed directly at your face.  You close your eyes and feel the first explosion splatter over your " + player.hairDescript() + " and forehead.  The next takes you full in the face, making it difficult to breathe through the mask of drug-like goo, but a few quick licks gives you a fix and makes it easy to breathe again.  On and on, the minotaur pumps fat ropes of spooge over your body until you're a syrupy, sticky mess that reeks of minotaur pheromones so strongly that dizziness overwhelms you and you fall free of the still-orgasming mino-cock, taking a few final blasts of seed on your " + player.chestDesc() + " and crotch.  Your hands instinctively shovel a few loads into your " + player.assholeOrPussy());
	if (player.hasVagina()) outputText(" while the animal part of your brain hopes it makes you pregnant with an equally girthy son");
	        outputText(".\n\n");
            //ADD PREG CHECK
            //Preggers chance!
            player.knockUp(PregnancyStore.PREGNANCY_MINOTAUR, PregnancyStore.INCUBATION_MINOTAUR, 70);

	        outputText("Giggling, you stagger over to the next cock in line and turn around, possessed with the idea of taking its spooge in the most direct way possible – anally.   You pull your butt-cheeks apart and lean back, surprising one of the horny beasts with the warmth of your " + player.assholeDescript() + " as you slowly relax, spreading over his flare.  He actually squirts ropes of something inside of you, but you've been around minotaurs enough to know that it can't be cum, at least not yet.  The slippery gouts of preseed make it nice and easy to rock back and spear yourself on the first few inches, ");
            if (player.analCapacity() < 80) {
                outputText("delighting in the drug-numbed pain of stretching yourself beyond your normal capacity.");
            }
            else if (player.analCapacity() < 140) outputText("delighting in the feeling of perfect fullness.");
            else outputText("delighting in realizing that you could take far larger than even this virile specimen!");
            //(buttchange here: 90)
            player.buttChange(90,true,false);

            outputText("\n\nYou slide down the twitching bull-shaft until your " + player.buttDescript() + " slaps the wall, and you draw slowly away, but you push back harder, turned into a lewd, wanting whore by the massive quantity of minotaur seed in your belly, on your skin, and fogging up the air.  The beast pulls out and you whine plaintively, feeling empty and useless until he plunges back inside and reminds you of your purpose.  He starts to fuck you hard, not caring for your pleasure at all, slamming his horse-cock deep and fast.  Each of his three rings of prepuce ");
            if (!player.hasCock()) outputText("drags through your body, touching sensitive nerves you didn't even know you had until you cum, shuddering and shaking like a wanton whore.");
            else outputText("presses on your prostate as it squeezes by, making " + player.sMultiCockDesc() + " drip and spurt freely until you can bear it no longer and cum, shaking and shuddering like a wanton whore.  Jizz drips and pours from " + player.sMultiCockDesc() + " in a steady stream that pools on the floor, slowly rolling towards a drain that doubtless empties into a tank or greedy goblin cunt.");
            outputText("\n\n");
	
            outputText("The strength goes completely out of your " + player.legs() + ", but you manage to hold yourself up long enough for your stud to flex his cock inside you and fill up your backdoor with more potent addiction.  You slide off, nerveless and still orgasming as jizz rains on your back from the abandoned cock, rolling off you to add to the ever-widening puddle of fluids on the floor.");
            //[NEXT]
            player.orgasm('Lips',false);
            player.orgasm('Anal');
            dynStats("int", -10, "lib", 10, "sen", 10);
            //dynStats("lib", 2, "sen", 2, "cor", 2);
            //doNext(minotaurSalonFollowUp);
            player.refillHunger(30);
            doNext(playerMenu);
        }
        
        private function    lactaidFountain() : void {
            		
			player.slimeFeed();
			var i:Number = 0;
			outputText("You gulp down creamy liquid.");
			//Bump up size!
			if (player.averageBreastSize() < 8) {
				outputText("\n\n");
				if (player.breastRows.length === 1) player.growTits((1 + rand(5)), 1, true, 1);
				else player.growTits(1 + rand(2), player.breastRows.length, true, 1);
			}
			//Player doesn't lactate
			if (player.biggestLactation() < 1) {
				outputText("\n\n");
				outputText("You feel your " + player.nippleDescript(0) + "s become tight and engorged.  A single droplet of milk escapes each, rolling down the curves of your breasts.  <b>You are now lactating!</b>");
				for (i = 0; i < player.breastRows.length; i++) {
					player.breastRows[i].lactationMultiplier += 2;
				}
			}
			//Boost lactation
			else {
				outputText("\n\n");
				outputText("Milk leaks from your " + player.nippleDescript(0) + "s in thick streams.  You're lactating even more!");
				for (i = 0; i < player.breastRows.length; i++) {
					player.breastRows[i].lactationMultiplier += 1 + rand(10) / 10;
				}
			}
			dynStats("lus", 10);
			if (rand(3) === 0) {
				outputText(player.modFem(95, 1));
			}
            
        }
    }
    

}