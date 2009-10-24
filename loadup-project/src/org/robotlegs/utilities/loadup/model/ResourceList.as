package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.interfaces.IResourceList;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;
	
	public class ResourceList implements IResourceList
	{
		protected var _resources:Array;
		protected var _resourceFactory:ILoadupResourceFactory;
		protected var _defaultRetryPolicy:IRetryPolicy;
		protected var eventDispatcher:IEventDispatcher;
		
		protected var canAddResources:Boolean;
		
		public function ResourceList(eventDispatcher:IEventDispatcher)
		{
			_resources = [];
			this.eventDispatcher = eventDispatcher;
			this.resourceFactory = new LoadupResourceFactory(this,eventDispatcher);
			canAddResources = true;
		}
		
		/**
		 * returns a COPY of the resources. You cannot directly change the resource
		 * array externally.
		 * 
		 * @return 
		 * 
		 */		

		public function get defaultRetryPolicy():IRetryPolicy
		{
			return _defaultRetryPolicy;
		}

		public function set defaultRetryPolicy(value:IRetryPolicy):void
		{
			_defaultRetryPolicy = value;
			_resourceFactory.defaultRetryPolicy = value;
		}

		public function get resources():Array
		{
			return _resources.concat();
		}
		
		/**
		 * Count of resources in the list that have a current status of
		 * <code>LoadupResourceStatus.FAILED</code> or <code>LoadupResourceStatus.TIMED_OUT</code>.
		 * 
		 * @return the count 
		 * 
		 */        
		public function get failedResourceCount():int
		{
			var count:int = 0;
			
			for each(var resource:ILoadupResource in _resources)
			{
				if(resource.status == LoadupResourceStatus.FAILED || resource.status == LoadupResourceStatus.TIMED_OUT)
					count
			}
			
			return count;
		}	
		
		/**
		 * Current number of resources in the list
		 * @return 
		 * 
		 */
		public function get count():int
		{
			return _resources.length;
		}

		public function get resourceFactory():ILoadupResourceFactory
		{
			return _resourceFactory;
		}

		public function set resourceFactory(value:ILoadupResourceFactory):void
		{
			_resourceFactory = value;
		}
		
		/**
		 * Count of resources in the list that have a current status of
		 * <code>LoadupResourceStatus.LOADED</code>.
		 * 
		 * @return the count 
		 * 
		 */		
		public function get loadedResourceCount():int
		{
			var count:int = 0;
			
			for each(var resource:ILoadupResource in _resources)
			{
				if(resource.status == LoadupResourceStatus.LOADED)
					count++
			}
			
			return count;
		}
		
		public function get percentLoaded():Number
		{
			return (loadedResourceCount*100)/_resources.length;
		}
		
		public function hasLoadupResource(resource:ILoadupResource):Boolean
		{
			for each(var loadupResource:ILoadupResource in _resources)
			{
				if(loadupResource == resource)
					return true;
			}
			return false;
		}
		
		public function getLoadupResource(fromResource:IResource):ILoadupResource
		{
			for each(var resource:ILoadupResource in _resources)
			{
				if(resource.resource == fromResource)
					return resource;
			}
			return null;
		}
		
		/**
		 * Add a single <code>IResource</code>
		 * 
		 * @param resource
		 * 
		 */		
		public function addResource(resource:IResource):ILoadupResource
		{
			if(!canAddResources)
				return null;
			var loadupResource:ILoadupResource = resourceFactory.createLoadupResource(resource);
			_resources.push( loadupResource );
			return loadupResource;
		}
		
		public function closeResourceList():void
		{
			canAddResources = false;
		}
	}
}