package org.robotlegs.utilities.loadup.intefaces
{
	public interface IRetryParameters
	{
		function get exponentialBackoff():Boolean;
		function get timeout():Number;
		function get retryInterval():Number;
		function get maxRetries():int;
	}
}