package classes.BodyParts 
{
	/**
	 * Container class for the players skin
	 * @since December 27, 2016
	 * @author Stadler76
	 */
	public class Skin 
	{
		include "../../../includes/appearanceDefs.as";

		public var type:Number = SKIN_TYPE_PLAIN;
		public var tone:String = "albino";
		public var desc:String = "skin";
		public var adj:String = "";
		public var furColor:String = "no";

		public function Skin() {}

		public function skinFurScales():String
		{
			var skinzilla:String = "";
			//Adjectives first!
			if (adj != "")
				skinzilla += adj + ", ";

			//Fur handled a little differently since it uses haircolor
			skinzilla += isFluffy() ? furColor : tone;

			return skinzilla + " " + desc;
		}

		public function description(noAdj:Boolean = false, noTone:Boolean = false):String
		{
			var skinzilla:String = "";

			//Adjectives first!
			if (!noAdj && adj != "" && !noTone && tone != "rough gray")
				skinzilla += adj + ", ";
			if (!noTone)
				skinzilla += tone + " ";

			//Fur handled a little differently since it uses haircolor
			skinzilla += isFluffy() ? "skin" : desc;

			return skinzilla;
		}

		public function hasFur():Boolean
		{
			return type == SKIN_TYPE_FUR;
		}

		public function hasWool():Boolean
		{
			return type == SKIN_TYPE_WOOL;
		}

		public function hasFeathers():Boolean
		{
			return  type == SKIN_TYPE_FEATHERED;
		}

		public function isFurry():Boolean
		{
			return [SKIN_TYPE_FUR, SKIN_TYPE_WOOL].indexOf(type) != -1;
		}

		public function isFluffy():Boolean
		{
			return [SKIN_TYPE_FUR, SKIN_TYPE_WOOL, SKIN_TYPE_FEATHERED].indexOf(type) != -1;
		}

		public function restore(keepTone:Boolean = true):void
		{
			type = SKIN_TYPE_PLAIN;
			if (!keepTone) tone = "albino";
			desc = "skin";
			adj  = "";
			furColor = "no";
		}

		public function setProps(p:Object):void
		{
			if (p.hasOwnProperty('type')) type = p.type;
			if (p.hasOwnProperty('tone')) tone = p.tone;
			if (p.hasOwnProperty('desc')) desc = p.desc;
			if (p.hasOwnProperty('adj'))  adj  = p.adj;
			if (p.hasOwnProperty('furColor')) furColor = p.furColor;
		}

		public function setAllProps(p:Object, keepTone:Boolean = true):void
		{
			restore(keepTone);
			setProps(p);
		}

		public function toObject():Object
		{
			return {
				type:     type,
				tone:     tone,
				desc:     desc,
				adj:      adj,
				furColor: furColor
			};
		}
	}
}
