package org.robotlegs.utilities.loadup.events
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.loadup.intefaces.ILoadupMonitor;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	
	public class LoadupMonitorEvent extends Event
	{
		public static const LOADING_STARTED :String = "loadingStarted";
		public static const LOADING_PROGRESS :String = "loadingProgress";
		public static const LOADING_COMPLETE :String = "loadingComplete";
		public static const LOADING_FINISHED_INCOMPLETE :String = "loadingFinishedIncomplete";
		public static const RETRYING_LOAD_RESOURCE :String = "retryingLoadResource";
		public static const LOAD_RESOURCE_TIMED_OUT :String = "loadResourceTimedOut";
		public static const CALL_OUT_OF_SYNC_IGNORED :String = "callOutOfSyncIgnored";
		public static const WAITING_FOR_MORE_RESOURCES :String = "waitingForMoreResources";
		
		public var monitor:ILoadupMonitor;
		public var resource:ILoadupResource;
		public var data:Object;
		
		public function LoadupMonitorEvent(type:String, monitor:ILoadupMonitor = null, resource:ILoadupResource = null, data:Object = null)
		{
			this.monitor = monitor;
			this.resource = resource;
			this.data = data;
			
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			return new LoadupMonitorEvent(type, monitor, resource, data);
		}
	}
}