package org.robotlegs.utilities.loadup.model
{
	import flash.events.IEventDispatcher;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.IRetryParameters;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;

	/**
	 * Retry policy for LoadupResource objects. Each LoadupResource should have
	 * its own RetryPolicy.
	 *  
	 * @author joel
	 * 
	 */	
	public class RetryPolicy implements IRetryPolicy
	{
		protected var _retryParameters:IRetryParameters;
		protected var eventDispatcher:IEventDispatcher;
		
		protected var timedOut:Boolean;
		protected var _failedLoadCount:int;
		protected var loadingIsActive:Boolean;
		protected var _totalFailureTimeInSeconds:Number;
		protected var lastRetryInterval:Number;
		
		public var expBackoffFactor1 :int = 2;
		
		public function RetryPolicy(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
			loadingIsActive = false;
			_totalFailureTimeInSeconds = 0;
			timedOut = false;
			_retryParameters = new RetryParameters(0,0,30);
			timedOut = false;
			_failedLoadCount = 0;
		}

		public function get totalFailureTimeInSeconds():Number
		{
			return _totalFailureTimeInSeconds;
		}

		public function get retryParameters():IRetryParameters
		{
			return _retryParameters;
		}

		public function set retryParameters(value:IRetryParameters):void
		{
			_retryParameters = value;
		}
		
		public function copy():IRetryPolicy
		{
			var retryPolicy:IRetryPolicy = new RetryPolicy(eventDispatcher);
			retryPolicy.retryParameters = this.retryParameters;
			return retryPolicy
		}
		
		public function get failedLoadCount():int
		{
			return _failedLoadCount;
		}
		
		public function get canAttemptReload():Boolean
		{
			return !timedOut && _failedLoadCount > 0 && ( _failedLoadCount <= retryParameters.maxRetries );
		}
		
		public function addFailedLoad(timeToFailureMilliseconds:Number=0):void
		{
			_failedLoadCount++;
			_totalFailureTimeInSeconds += timeToFailureMilliseconds / 1000;
			if( retryParameters.timeoutInSeconds > 0 && totalFailureTimeInSeconds >= retryParameters.timeoutInSeconds )
				timedOut = true;
		}

		public function getTimeoutTimer() :Timer {
			if ( retryParameters.timeoutInSeconds <= 0 || timedOut )
				return null;
			var timerInterval:Number = ( retryParameters.timeoutInSeconds - totalFailureTimeInSeconds ) * 1000
			return new Timer( timerInterval, 1 );
		}
		
		public function getRetryTimer() :Timer {
			if ( retryParameters.retryInterval > 0 ) 
			{
				var rti :Number = ( retryParameters.exponentialBackoff ? getNextRetryInterval() : retryParameters.retryInterval );
				return new Timer( rti *1000, 1 );
			}

			return null;
		}

		protected function getNextRetryInterval() :Number {
			if ( lastRetryInterval == 0 )
				return ( lastRetryInterval = retryParameters.retryInterval );
			else
				return ( lastRetryInterval = lastRetryInterval * expBackoffFactor1 );
		}
		
		protected function addListeners():void
		{
			eventDispatcher.addEventListener( LoadupMonitorEvent.LOADING_STARTED, handleLoadingStarted );
			eventDispatcher.addEventListener( LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleLoadingFinishedIncomplete );
			eventDispatcher.addEventListener( LoadupMonitorEvent.LOADING_COMPLETE, handleLoadingComplete );
		}
		
		protected function removeListeners():void
		{
			eventDispatcher.removeEventListener( LoadupMonitorEvent.LOADING_STARTED, handleLoadingStarted );
			eventDispatcher.removeEventListener( LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleLoadingFinishedIncomplete );
			eventDispatcher.removeEventListener( LoadupMonitorEvent.LOADING_COMPLETE, handleLoadingComplete );
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
	}
}