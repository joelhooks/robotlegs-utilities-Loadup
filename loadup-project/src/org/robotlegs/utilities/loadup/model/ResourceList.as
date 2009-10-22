package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.intefaces.IResource;
	import org.robotlegs.utilities.loadup.intefaces.IResourceList;
	
	public class ResourceList implements IResourceList
	{
		private var _resources:Array;
		private var _resourceFactory:ILoadupResourceFactory;
		
		protected var eventDispatcher:IEventDispatcher;
		
		protected var canAddResources:Boolean;
		
		public function ResourceList(eventDispatcher:IEventDispatcher)
		{
			_resources = [];
			this.eventDispatcher = eventDispatcher;
			this.resourceFactory = new LoadupResourceFactory(eventDispatcher);
			canAddResources = true;
		}
		
		/**
		 * returns a COPY of the resources. You cannot directly change the resource
		 * array externally.
		 * 
		 * @return 
		 * 
		 */		
		public function get resources():Array
		{
			return _resources.concat();
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