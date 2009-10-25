package org.robotlegs.utilities.loadup.events
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	
	public class ResourceEvent extends Event
	{
		public static const RESOURCE_LOADED:String = "resourceLoaded";
		public static const RESOURCE_LOADING_STARTED:String = "resourceLoadingStarted";
		public static const RESOURCE_LOAD_FAILED:String = "resourceLoadFailed";
		
		public var resource:IResource;
		
		public function ResourceEvent(type:String, resource:IResource)
		{
			this.resource = resource;
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			return new ResourceEvent(type, resource);
		}
	}
}