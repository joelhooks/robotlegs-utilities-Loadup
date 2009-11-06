package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	import flash.net.getClassByAlias;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.interfaces.IResourceList;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;

	public class LoadupResourceFactory implements ILoadupResourceFactory
	{
		protected var eventDispatcher:IEventDispatcher;
		protected var _defaultRetryPolicy:IRetryPolicy;
		protected var resourceList:IResourceList;
		
		public function LoadupResourceFactory(resourceList:IResourceList, eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			this.resourceList = resourceList;
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
			var resourceEventTypes:ResourceEventTypes = fromResource.getResourceEventTypes( new ResourceEventTypes() )
			var loadupResource:ILoadupResource = new LoadupResource(fromResource, resourceList, resourceEventTypes, eventDispatcher);
			loadupResource.retryPolicy = _defaultRetryPolicy.copy();
			return loadupResource;
		}
		
		public function destroy():void
		{
			resourceList = null;
			_defaultRetryPolicy = null;
		}
	}
}