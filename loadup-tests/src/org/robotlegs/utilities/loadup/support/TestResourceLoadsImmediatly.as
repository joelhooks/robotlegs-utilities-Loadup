package org.robotlegs.utilities.loadup.support
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.model.ResourceEventTypes;
	
	public class TestResourceLoadsImmediatly implements IResource
	{
		protected var eventDispatcher:IEventDispatcher;
		
		public function TestResourceLoadsImmediatly(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
		}
		
		public function load():void
		{
			eventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOADED, this));
		}
		
		public function getResourceEventTypes(value:ResourceEventTypes):ResourceEventTypes
		{
			return value;
		}
	}
}