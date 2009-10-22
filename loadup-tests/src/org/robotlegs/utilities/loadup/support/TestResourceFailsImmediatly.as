package org.robotlegs.utilities.loadup.support
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	
	public class TestResourceFailsImmediatly implements IResource
	{
		protected var eventDispatcher:IEventDispatcher;
		
		public function TestResourceFailsImmediatly(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
		}
		
		public function load():void
		{
			eventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOAD_FAILED, this));
		}
	}
}