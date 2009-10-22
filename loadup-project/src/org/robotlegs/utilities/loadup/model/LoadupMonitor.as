package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.intefaces.IResource;
	import org.robotlegs.utilities.loadup.intefaces.IResourceList;
	import org.robotlegs.utilities.loadup.intefaces.IRetryPolicy;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupMonitor;

	public class LoadupMonitor implements ILoadupMonitor
	{
		protected var eventDispatcher:IEventDispatcher;
		
		private var _resourceList:IResourceList;
		private var _retryPolicy:IRetryPolicy;
		
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
			_retryPolicy = new RetryPolicy( new RetryParameters(0,0,300));
			addEventListeners();
		}
		
		public function get retryPolicy():IRetryPolicy
		{
			return _retryPolicy;
		}

		public function set retryPolicy(value:IRetryPolicy):void
		{
			_retryPolicy = value;
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
			for each(var resource:ILoadupResource in resourceList.resources)
			{
				resource.startLoad();
			}
		}

		protected function addEventListeners():void
		{
			eventDispatcher.addEventListener( LoadupResourceEvent.LOADUP_RESOURCE_LOADED, handleResourceLoaded );
		}
		
		protected function removeEventListeners():void
		{
			eventDispatcher.removeEventListener( LoadupResourceEvent.LOADUP_RESOURCE_LOADED, handleResourceLoaded );
		}
		
		protected function handleResourceLoaded(event:LoadupResourceEvent):void
		{
			if(_resourceList.loadedResourceCount == _resourceList.count)
				eventDispatcher.dispatchEvent( new LoadupMonitorEvent( LoadupMonitorEvent.LOADING_COMPLETE, this ) );
			else
				eventDispatcher.dispatchEvent( new LoadupMonitorEvent( LoadupMonitorEvent.LOADING_PROGRESS, this, event.resource, _resourceList.percentLoaded ) );
		}
		
	}
}