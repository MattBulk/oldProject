package mutation.events
{
	import flash.events.Event;
	
	public class MEvent extends Event
	{
		public static const TRIGGERED:String = "M_TRIGGERED";
        public static const ACTION_TRIGGERED:String = "M_ACTION";
		public static const CHANGE_SCREEN:String = "M_CHANGE_SCREEN";
        public static const COMPLETE:String = "M_COMPLETE";
        public static const FUNCTION:String = "M_FUNCTION";
		
		public var params:Object;
		
		public function MEvent(type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.params = _params;
		}
	}
}