/**
 * Created by aimozg on 31.01.14.
 */
package classes
{
	import flash.utils.Dictionary;

	public class StatusEffectType
	{
			private static var STATUSAFFECT_LIBRARY:Dictionary = new Dictionary();

			public static function lookupStatusEffect(id:String):StatusEffectType{
				return STATUSAFFECT_LIBRARY[id];
			}

			public static function getStatusEffectLibrary():Dictionary
			{
				return STATUSAFFECT_LIBRARY;
			}

			private var _id:String;

			/**
			 * Unique perk id, should be kept in future game versions
			 */
			public function get id():String
			{
				return _id;
			}

		private var _secClazz:Class;

			public function StatusEffectType(id:String,clazz:Class)
			{
				this._id = id;
				_secClazz = clazz;
				if (STATUSAFFECT_LIBRARY[id] != null) {
					CoC_Settings.error("Duplicate status affect "+id);
				}
				STATUSAFFECT_LIBRARY[id] = this;
			}

		public function create(host:Creature,value1:Number, value2:Number, value3:Number, value4:Number):StatusEffectClass {
			var sec:StatusEffectClass = _secClazz.length == 2 ? new _secClazz(this,host) : new _secClazz(this);
			sec.value1 = value1;
			sec.value2 = value2;
			sec.value3 = value3;
			sec.value4 = value4;
			return sec;
		}


			public function toString():String
			{
				return "\""+_id+"\"";
			}
		}
}
