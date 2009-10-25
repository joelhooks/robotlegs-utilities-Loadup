package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.interfaces.IResourceList;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;
	
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
		protected var _loadStartTimeMilliseconds:Number;
		protected var eventDispatcher:IEventDispatcher;
		protected var timeoutTimer:Timer;
		protected var retryTimer:Timer;
		protected var loadingIsActive:Boolean;
		protected var resourceList:IResourceList;
		protected var resourceEventTypes:ResourceEventTypes;
		
		
		public function LoadupResource(resource:IResource, resourceList:IResourceList, resourceEventTypes:ResourceEventTypes, eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			this.resourceEventTypes = resourceEventTypes;
			_resource = resource;
			_required = [];
			_status = LoadupResourceStatus.INITIALIZED;
			_retryPolicy = new RetryPolicy(eventDispatcher);
			this.resourceList = resourceList;

			loadingIsActive = false;
			addListeners();
		}

		public function get loadStartTimeMilliseconds():Number
		{
			return _loadStartTimeMilliseconds;
		}

		public function get retryPolicy():IRetryPolicy
		{
			return _retryPolicy;
		}

		public function set retryPolicy(value:IRetryPolicy):void
		{
			if(!loadingIsActive)
				_retryPolicy = value;
		}

		public function set required(value:Array):void
		{
			_required = value;
		}
		
		public function get requiredLoadupResources():Array
		{
			var required:Array = [];
			
			for each(var resource:Object in _required)
			{
				var loadupResource:ILoadupResource = resource as ILoadupResource;
				if(resource is IResource)
				{
					loadupResource = resourceList.getLoadupResource(IResource(resource));
					if(!loadupResource)
						continue;
				}
				
				required.push(loadupResource)
			}            
			
			return required;
		}
		
		public function get status():int
		{
			return _status;
		}

		public function get resource():IResource
		{
			return _resource;
		}

		public function get resourceHasFailed():Boolean
		{
			return _status == LoadupResourceStatus.FAILED ||    _status == LoadupResourceStatus.TIMED_OUT;        
		}
			
		public function get canLoad():Boolean
		{
 			return status == LoadupResourceStatus.INITIALIZED;
		}
		
		protected function get requiredResourcesLoaded():Boolean
		{
			for each(var resource:ILoadupResource in requiredLoadupResources)
			{
				if(resource.status != LoadupResourceStatus.LOADED)
					return false;
			}
			
			return true;
		}	

		protected function get hasFailedRequiredResources():Boolean
		{
			for each(var resource:ILoadupResource in requiredLoadupResources)
			{
				if(resource.resourceHasFailed)
					return true;
			}
			return false;
		}
			
		public function startLoad():void
		{
			if(hasFailedRequiredResources)
				updateOnLoadFailed();
			if(!requiredResourcesLoaded)
				return;
			
			var now:Date = new Date()
			_loadStartTimeMilliseconds = now.time;
			_status = LoadupResourceStatus.LOADING;
			eventDispatcher.dispatchEvent(new ResourceEvent( resourceEventTypes.loading, this.resource ));
			resource.load();
			if(retryPolicy.retryParameters.timeoutInSeconds > 0)
				startTimeoutTimer();
		}
		
		protected function startReload():void
		{
			retryTimer = retryPolicy.getRetryTimer();
			if(retryTimer)
			{
				retryTimer.addEventListener(TimerEvent.TIMER, handleLoadOnTimer, false, 0, true);
				retryTimer.start();
			}
			else
			{
				startLoad();
			}		
		}
		
		protected function startTimeoutTimer():void
		{
			timeoutTimer = retryPolicy.getTimeoutTimer();
			timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimeout);
			timeoutTimer.start();
		}

		
		protected function updateOnLoadFailed():void
		{
			var now:Date = new Date()
			retryPolicy.addFailedLoad( now.time - loadStartTimeMilliseconds );
			
			if(retryPolicy.canAttemptReload)
			{
				startReload();
			}
			else
			{
				_status = LoadupResourceStatus.FAILED;
				eventDispatcher.dispatchEvent(new ResourceEvent( resourceEventTypes.loadingFailed, this.resource ));
				eventDispatcher.dispatchEvent(new LoadupResourceEvent(LoadupResourceEvent.LOADUP_RESOURCE_FAILED, this));
				removeListeners();					
			}
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
		
		protected function handleTimeout(event:TimerEvent):void
		{
			event.target.removeEventListener(TimerEvent.TIMER, handleTimeout);
			if(_status != LoadupResourceStatus.FAILED && _status != LoadupResourceStatus.LOADED)
			{
				_status = LoadupResourceStatus.TIMED_OUT;
				eventDispatcher.dispatchEvent(new ResourceEvent( resourceEventTypes.loadingTimedOut, this.resource ));
				eventDispatcher.dispatchEvent(new LoadupResourceEvent(LoadupResourceEvent.LOADUP_RESOURCE_TIMED_OUT, this));			
			}
		}
		
		protected function handleLoadOnTimer(event:TimerEvent):void
		{
			event.target.removeEventListener(TimerEvent.TIMER, handleLoadOnTimer);
			retryTimer.stop();
			retryTimer.reset();
			startLoad();
		}
		
		protected function handleLoadingStarted(event:LoadupMonitorEvent):void
		{
			loadingIsActive = true;
		}

		protected function handleLoadingFinishedIncomplete(event:LoadupMonitorEvent):void
		{
			loadingIsActive = false;
		}

		protected function handleLoadingComplete(event:LoadupMonitorEvent):void
		{
			loadingIsActive = false;
		}
		
		protected function handleResourceLoaded(event:ResourceEvent):void
		{
			if(event.resource == this.resource)
			{
				if(_status != LoadupResourceStatus.FAILED && _status != LoadupResourceStatus.TIMED_OUT)
				{
					_status = LoadupResourceStatus.LOADED;
					eventDispatcher.dispatchEvent(new ResourceEvent( resourceEventTypes.loaded, this.resource ));
					eventDispatcher.dispatchEvent(new LoadupResourceEvent(LoadupResourceEvent.LOADUP_RESOURCE_LOADED, this));
					removeListeners();					
				}
			}
		}
		
		protected function handleResourceLoadFailed(event:ResourceEvent):void
		{
			if(event.resource == this.resource)
			{
				updateOnLoadFailed();
			}			
		}
	}
}