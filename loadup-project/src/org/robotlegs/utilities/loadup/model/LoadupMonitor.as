package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupMonitor;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.interfaces.IResourceList;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;

	public class LoadupMonitor implements ILoadupMonitor
	{
		protected var eventDispatcher:IEventDispatcher;
		
		protected var _resourceList:IResourceList;
		protected var _defaultRetryPolicy:IRetryPolicy;
		
		protected var loadedResources:Array;
		protected var failedResourced:Array;
		/**
		 * Constructor
		 * 
		 * @param eventDispatcher Required <code>IEventDispatcher</code> used
		 * to communicate with outside interests.
		 * 
		 */		
		public function LoadupMonitor(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			_resourceList = new ResourceList(eventDispatcher);
			defaultRetryPolicy = new RetryPolicy(eventDispatcher);
			loadedResources = [];
			failedResourced = [];
			addEventListeners();
		}
		
		public function get defaultRetryPolicy():IRetryPolicy
		{
			return _defaultRetryPolicy;
		}

		public function set defaultRetryPolicy(value:IRetryPolicy):void
		{
			_defaultRetryPolicy = value;
			_resourceList.defaultRetryPolicy = value;
		}

		public function get resourceList():IResourceList
		{
			return _resourceList;
		}

		public function set resourceList(value:IResourceList):void
		{
			_resourceList = value;
		}

		/**
		 * Current number of items in the <code>ResourceList</code>
		 * @return 
		 * 
		 */
		public function get resourcesToLoadCount():int
		{
			return _resourceList.count;
		}
		
		/**
		 * Add a single <code>IResource</code> to load
		 * 
		 * @param resource
		 * 
		 */		
		public function addResource(resource:IResource):ILoadupResource
		{
			return _resourceList.addResource(resource);
		}
		
		/**
		 * Add an array of <code>IResource</code> items to load
		 *  
		 * @param resourceArray
		 * 
		 */		
		public function addResourceArray(resourceArray:Array):void
		{
			for each(var resource:IResource in resourceArray)
			{
				addResource(resource);
			}
		}
		
		public function startResourceLoading():void
		{
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_STARTED, this));
			
			for each(var resource:ILoadupResource in resourceList.resources)
			{
				resource.startLoad();
			}
		}
		
		public function get allResourcesAreLoaded():Boolean
		{
			return _resourceList.loadedResourceCount == _resourceList.count
		}

		public function get loadingIsFinished():Boolean 
		{
			
			for each(var resource:ILoadupResource in _resourceList.resources)
			{
				var finishedLoading:Boolean = resource.status == LoadupResourceStatus.FAILED;
				finishedLoading = finishedLoading || resource.status == LoadupResourceStatus.TIMED_OUT;
				finishedLoading = finishedLoading || resource.status == LoadupResourceStatus.LOADED;
				
				if(!finishedLoading)
					return false;
			}
			
			return true;
		}
		
		protected function checkLoadingStatus():void
		{
			if(allResourcesAreLoaded)
				eventDispatcher.dispatchEvent( new LoadupMonitorEvent( LoadupMonitorEvent.LOADING_COMPLETE, this ) );

			if(loadingIsFinished && !allResourcesAreLoaded)
				eventDispatcher.dispatchEvent( new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, this, null, failedResourced) );
		}

		protected function addEventListeners():void
		{
			eventDispatcher.addEventListener( LoadupResourceEvent.LOADUP_RESOURCE_LOADED, handleResourceLoaded );
			eventDispatcher.addEventListener( LoadupResourceEvent.LOADUP_RESOURCE_FAILED, handleResourceFailed );
			eventDispatcher.addEventListener( LoadupResourceEvent.LOADUP_RESOURCE_TIMED_OUT, handleResourceFailed );
		}
		
		protected function removeEventListeners():void
		{
			eventDispatcher.removeEventListener( LoadupResourceEvent.LOADUP_RESOURCE_LOADED, handleResourceLoaded );
		}
		
		protected function handleResourceFailed(event:LoadupResourceEvent):void
		{
			failedResourced.push(event.resource);
			checkLoadingStatus();

		}
		
		protected function handleResourceLoaded(event:LoadupResourceEvent):void
		{
			loadedResources.push( event.resource );
			checkLoadingStatus();
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_PROGRESS, this, event.resource, _resourceList.percentLoaded));
		}
		
	}
}