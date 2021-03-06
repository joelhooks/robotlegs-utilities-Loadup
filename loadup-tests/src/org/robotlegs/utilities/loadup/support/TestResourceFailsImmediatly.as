package org.robotlegs.utilities.loadup.support
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.model.ResourceEventTypes;
	
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
		
		public function getResourceEventTypes(value:ResourceEventTypes):ResourceEventTypes
		{
			return value;
		}
	}
}