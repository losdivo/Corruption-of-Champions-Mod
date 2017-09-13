package classes
{
	import classes.GlobalFlags.kFLAGS;

	/**
	 * This contains some of the helper methods for the player-object I've written
	 * @since June 29, 2016
	 * @author Stadler76
	 */
	public class PlayerHelper extends Character 
	{
		public function PlayerHelper() {}

		public function hasDifferentUnderBody():Boolean
		{
			if ([UNDER_BODY_TYPE_NONE, UNDER_BODY_TYPE_NAGA].indexOf(underBody.type) != -1)
				return false;

			/* // Example for later use
			if ([UNDER_BODY_TYPE_MERMAID, UNDER_BODY_TYPE_WHATEVER].indexOf(underBody.type) != -1)
				return false; // The underBody is (mis)used for secondary skin, not for the underBody itself
			*/

			return underBody.skin.type != skin.type || underBody.skin.tone != skin.tone ||
			       underBody.skin.adj  != skin.adj  || underBody.skin.desc != skin.desc ||
			       (underBody.skin.hasFur() && hasFur() && underBody.skin.furColor != skin.furColor);
		}

		public function hasUnderBody(noSnakes:Boolean = false):Boolean
		{
			var normalUnderBodies:Array = [UNDER_BODY_TYPE_NONE];

			if (noSnakes) {
				normalUnderBodies.push(UNDER_BODY_TYPE_NAGA);
			}

			return normalUnderBodies.indexOf(underBody.type) == -1;
		}

		public function hasFurryUnderBody(noSnakes:Boolean = false):Boolean
		{
			return hasUnderBody(noSnakes) && underBody.skin.hasFur();
		}

		public function hasFeatheredUnderBody(noSnakes:Boolean = false):Boolean
		{
			return hasUnderBody(noSnakes) && underBody.skin.hasFeathers();
		}

		public function hasDragonHorns(fourHorns:Boolean = false):Boolean
		{
			return (!fourHorns && horns > 0 && hornType == HORNS_DRACONIC_X2) || hornType == HORNS_DRACONIC_X4_12_INCH_LONG;
		}

		public function hasReptileEyes():Boolean
		{
			return [EYES_LIZARD, EYES_DRAGON, EYES_BASILISK].indexOf(eyeType) != -1;
		}

		public function hasLizardEyes():Boolean
		{
			return [EYES_LIZARD, EYES_BASILISK].indexOf(eyeType) != -1;
		}

		public function hasReptileFace():Boolean
		{
			return [FACE_SNAKE_FANGS, FACE_LIZARD, FACE_DRAGON].indexOf(faceType) != -1;
		}

		public function hasReptileUnderBody(withSnakes:Boolean = false):Boolean
		{
			var underBodies:Array = [
				UNDER_BODY_TYPE_REPTILE,
			];

			if (withSnakes) {
				underBodies.push(UNDER_BODY_TYPE_NAGA);
			}

			return underBodies.indexOf(underBody.type) != -1;
		}

		public function hasCockatriceSkin():Boolean
		{
			return skinType == SKIN_TYPE_LIZARD_SCALES && underBody.type == UNDER_BODY_TYPE_COCKATRICE;
		}

		public function hasNonCockatriceAntennae():Boolean
		{
			return [ANTENNAE_NONE, ANTENNAE_COCKATRICE].indexOf(antennae) == -1
		}

		public function hasDragonWings(large:Boolean = false):Boolean
		{
			if (large)
				return wingType == WING_TYPE_DRACONIC_LARGE;
			else
				return [WING_TYPE_DRACONIC_SMALL, WING_TYPE_DRACONIC_LARGE].indexOf(wingType) != -1;
		}

		public function hasBatLikeWings(large:Boolean = false):Boolean
		{
			if (large)
				return wingType == WING_TYPE_BAT_LIKE_LARGE;
			else
				return [WING_TYPE_BAT_LIKE_TINY, WING_TYPE_BAT_LIKE_LARGE].indexOf(wingType) != -1;
		}

		public function hasLeatheryWings(large:Boolean = false):Boolean
		{
			return hasDragonWings(large) || hasBatLikeWings(large);
		}

		// To be honest: I seriously considered naming it drDragonCox() :D
		public function dragonCocks():int
		{
			return countCocksOfType(CockTypesEnum.DRAGON);
		}

		public function lizardCocks():int
		{
			return countCocksOfType(CockTypesEnum.LIZARD);
		}

		public function hasDragonfire():Boolean
		{
			return findPerk(PerkLib.Dragonfire) >= 0;
		}

		public function hasDragonWingsAndFire(largeWings:Boolean = true):Boolean
		{
			return hasDragonWings(largeWings) && hasDragonfire();
		}

		public function isBasilisk():Boolean
		{
			return game.bazaar.benoit.benoitBigFamily() && eyeType == EYES_BASILISK;
		}

		public function hasReptileTail():Boolean
		{
			return [TAIL_TYPE_LIZARD, TAIL_TYPE_DRACONIC, TAIL_TYPE_SALAMANDER].indexOf(tailType) != -1;
		}

		// For reptiles with predator arms I recommend to require hasReptileScales() before doing the armType TF to ARM_TYPE_PREDATOR
		public function hasReptileArms():Boolean
		{
			return armType == ARM_TYPE_SALAMANDER || (armType == ARM_TYPE_PREDATOR && hasReptileScales());
		}

		public function hasReptileLegs():Boolean
		{
			return [LOWER_BODY_TYPE_LIZARD, LOWER_BODY_TYPE_DRAGON, LOWER_BODY_TYPE_SALAMANDER].indexOf(lowerBody) != -1;
		}

		public function hasDraconicBackSide():Boolean
		{
			return hasDragonWings(true) && hasDragonScales() && hasReptileTail() && hasReptileArms() && hasReptileLegs();
		}

		public function hasDragonNeck():Boolean
		{
			return neck.type == NECK_TYPE_DRACONIC && neck.isFullyGrown();
		}

		public function hasNormalNeck():Boolean
		{
			return neck.len <= 2;
		}

		public function hasDragonRearBody():Boolean
		{
			return [REAR_BODY_DRACONIC_MANE, REAR_BODY_DRACONIC_SPIKES].indexOf(rearBody.type) != -1;
		}

		public function hasNonSharkRearBody():Boolean
		{
			return [REAR_BODY_NONE, REAR_BODY_SHARK_FIN].indexOf(rearBody.type) == -1;
		}

		public function fetchEmberRearBody():Number
		{
			return flags[kFLAGS.EMBER_HAIR] == 2 ? REAR_BODY_DRACONIC_MANE : REAR_BODY_DRACONIC_SPIKES;
		}

		public function featheryHairPinEquipped():Boolean
		{
			return hasKeyItem("Feathery hair-pin") >= 0 && keyItemv1("Feathery hair-pin") == 1;
		}
	}
}
