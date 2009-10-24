package org.robotlegs.utilities.loadup.events
{
	import flash.events.Event;
	
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;
	
	public class LoadupEvent extends Event
	{
		public static const LOAD_RESOURCES:String = "loadResources";
		
		public var retryPolicy:IRetryPolicy
		
		public function LoadupEvent(type:String, retryPolicy:IRetryPolicy = null)
		{
			this.retryPolicy = retryPolicy;
			
			super(type, false, false);
		}
		
		override public function clone() : Event
		{
			return new LoadupEvent(type, retryPolicy);
		}
	}
}