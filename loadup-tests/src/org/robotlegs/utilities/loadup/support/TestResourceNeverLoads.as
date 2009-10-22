package org.robotlegs.utilities.loadup.support
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	
	public class TestResourceNeverLoads implements IResource
	{
		protected var eventDispatcher:IEventDispatcher;

		public function TestResourceNeverLoads(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
		}
		
		public function load():void
		{
			//this resource just won't load!
		}
	}
}