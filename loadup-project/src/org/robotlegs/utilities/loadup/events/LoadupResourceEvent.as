package org.robotlegs.utilities.loadup.events
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	
	public class LoadupResourceEvent extends Event
	{
		public static const LOADUP_RESOURCE_EMPTY:String = "loadupResourceEmpty";
		public static const LOADUP_RESOURCE_LOADING:String = "loadupResourceLoading";
		public static const LOADUP_RESOURCE_TIMED_OUT:String = "loadupResourceTimedOut";
		public static const LOADUP_RESOURCE_FAILED:String = "loadupResourceFailed";
		public static const LOADUP_RESOURCE_LOADED:String = "loadupResourceLoaded";
		
		public var resource:ILoadupResource;
		public var data:Object;
		
		public function LoadupResourceEvent(type:String, resource:ILoadupResource=null, data:Object=null)
		{
			this.resource = resource;
			this.data = data;
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			return new LoadupResourceEvent(type, resource, data);
		}
	}
}