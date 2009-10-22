package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.interfaces.IResource;

	public class LoadupResourceFactory implements ILoadupResourceFactory
	{
		protected var eventDispatcher:IEventDispatcher;
		
		public function LoadupResourceFactory(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
		}
		
		public function createLoadupResource(fromResource:IResource):ILoadupResource
		{
			var loadupResource:ILoadupResource = new LoadupResource(fromResource, eventDispatcher);
			return loadupResource;
		}
	}
}