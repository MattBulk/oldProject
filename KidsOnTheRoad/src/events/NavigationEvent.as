package events
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public static const CHANGE_STATE:String = "changeState";
		public static const GAME_STATE:String = "gameState";
        public static const BACKGROUND_CHANGE:String = "backgroundChange";
        public static const LOADED_EVENT:String = "loaded";
		
		public var params:Object;
		
		public function NavigationEvent(type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.params = _params;
		}
	}
}