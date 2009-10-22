package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.intefaces.IResource;
	import org.robotlegs.utilities.loadup.intefaces.IRetryPolicy;
	
	/**
	 * Decorator for <code>IResource</code>
	 * 
	 * @author joel
	 * 
	 */
	public class LoadupResource implements ILoadupResource
	{
		protected var _status:int;
		protected var _resource:IResource;
		protected var _required:Array;
		protected var _retryPolicy:IRetryPolicy;
		protected var eventDispatcher:IEventDispatcher;
		protected var timeoutTimer:Timer;
		
		public function LoadupResource(resource:IResource, eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			_resource = resource;
			_status = LoadupResourceStatus.INITIALIZED;
			addListeners();
		}

		public function get retryPolicy():IRetryPolicy
		{
			return _retryPolicy;
		}

		public function set retryPolicy(value:IRetryPolicy):void
		{
			_retryPolicy = value;
		}

		public function set required(value:Array):void
		{
			_required = value;
		}

		public function get status():int
		{
			return _status;
		}

		public function get resource():IResource
		{
			return _resource;
		}
		
		public function startLoad():void
		{
			if(!requiredResourcesLoaded)
				return;
			
			_status = LoadupResourceStatus.LOADING;
			resource.load();
		}
		
		protected function get requiredResourcesLoaded():Boolean
		{
			for each(var resource:ILoadupResource in _required)
			{
				if(resource.status != LoadupResourceStatus.LOADED)
					return false;
			}
			
			return true;
		}
		
		protected function addListeners():void
		{
			eventDispatcher.addEventListener( ResourceEvent.RESOURCE_LOADED, handleResourceLoaded )
			eventDispatcher.addEventListener( ResourceEvent.RESOURCE_LOAD_FAILED, handleResourceLoadFailed )
			eventDispatcher.addEventListener( LoadupMonitorEvent.LOADING_STARTED, handleLoadingStarted );
			eventDispatcher.addEventListener( LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleLoadingFinishedIncomplete );
			eventDispatcher.addEventListener( LoadupMonitorEvent.LOADING_COMPLETE, handleLoadingComplete );
		}
		
		protected function removeListeners():void
		{
			eventDispatcher.removeEventListener( ResourceEvent.RESOURCE_LOADED, handleResourceLoaded )
			eventDispatcher.removeEventListener( ResourceEvent.RESOURCE_LOAD_FAILED, handleResourceLoadFailed )
			eventDispatcher.removeEventListener( LoadupMonitorEvent.LOADING_STARTED, handleLoadingStarted );
			eventDispatcher.removeEventListener( LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleLoadingFinishedIncomplete );
			eventDispatcher.removeEventListener( LoadupMonitorEvent.LOADING_COMPLETE, handleLoadingComplete );
		}
		
		protected function handleLoadingStarted(event:LoadupMonitorEvent):void
		{
			trace("loading started!")
		}

		protected function handleLoadingFinishedIncomplete(event:LoadupMonitorEvent):void
		{
			trace("loading finished incomplete!")
		}

		protected function handleLoadingComplete(event:LoadupMonitorEvent):void
		{
			trace("loading complete!")
		}
		
		protected function handleResourceLoaded(event:ResourceEvent):void
		{
			if(event.resource == this.resource)
			{
				_status = LoadupResourceStatus.LOADED;
				eventDispatcher.dispatchEvent(new LoadupResourceEvent(LoadupResourceEvent.LOADUP_RESOURCE_LOADED, this));
				removeListeners();
			}
		}
		
		protected function handleResourceLoadFailed(event:ResourceEvent):void
		{
			if(event.resource == this.resource)
			{
				_status = LoadupResourceStatus.FAILED;
				eventDispatcher.dispatchEvent(new LoadupResourceEvent(LoadupResourceEvent.LOADUP_RESOURCE_FAILED, this));
				removeListeners();
			}			
		}
	}
}