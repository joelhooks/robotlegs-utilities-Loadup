package org.robotlegs.utilities.loadup.interfaces
{
	import flash.utils.Timer;

	public interface IRetryPolicy
	{
		function get failedLoadCount():int;
		function get totalFailureTimeInSeconds():Number
		function addFailedLoad(timeToFailureMilliseconds:Number=0):void;
		function copy():IRetryPolicy;
		function get canAttemptReload():Boolean
		function getTimeoutTimer() :Timer;
		function getRetryTimer() :Timer;
		
		function get retryParameters():IRetryParameters;
		function set retryParameters(value:IRetryParameters):void;
	}
}