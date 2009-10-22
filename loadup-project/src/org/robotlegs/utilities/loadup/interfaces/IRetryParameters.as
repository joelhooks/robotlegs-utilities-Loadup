package org.robotlegs.utilities.loadup.interfaces
{
	public interface IRetryParameters
	{
		function get exponentialBackoff():Boolean;
		function get timeout():Number;
		function get retryInterval():Number;
		function get maxRetries():int;
	}
}