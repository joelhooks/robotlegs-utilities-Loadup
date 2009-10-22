package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;

	public class LoadupResourceFactory implements ILoadupResourceFactory
	{
		protected var eventDispatcher:IEventDispatcher;
		protected var _defaultRetryPolicy:IRetryPolicy;
		
		public function LoadupResourceFactory(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			_defaultRetryPolicy = new RetryPolicy(eventDispatcher);
		}

		public function get defaultRetryPolicy():IRetryPolicy
		{
			return _defaultRetryPolicy;
		}
		
		public function set defaultRetryPolicy(value:IRetryPolicy):void
		{
			_defaultRetryPolicy = value;
		}
		
		public function createLoadupResource(fromResource:IResource):ILoadupResource
		{
			var loadupResource:ILoadupResource = new LoadupResource(fromResource, eventDispatcher);
			loadupResource.retryPolicy = _defaultRetryPolicy.copy();
			return loadupResource;
		}
	}
}