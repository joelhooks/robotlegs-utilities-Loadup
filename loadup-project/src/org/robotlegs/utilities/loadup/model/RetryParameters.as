package org.robotlegs.utilities.loadup.model
{
	import org.robotlegs.utilities.loadup.interfaces.IRetryParameters;
	
	public class RetryParameters implements IRetryParameters
	{
		protected var _maxRetries:int;
		protected var _retryInterval:Number;
		protected var _timeoutInSeconds:Number;
		protected var _exponentialBackoff:Boolean;
		
		public function RetryParameters( maxRetries:int = 0, retryInterval:Number = 0, timeoutInSeconds:Number = 0, exponentialBackoff:Boolean 	= false )
		{
			_maxRetries = maxRetries >= 0 ? maxRetries : 0;
			_retryInterval = retryInterval >= 0.0 ? retryInterval : 0.0;
			_timeoutInSeconds = timeoutInSeconds >= 0.0 ? timeoutInSeconds : 0.0;
			_exponentialBackoff = exponentialBackoff;
		}

		public function get exponentialBackoff():Boolean
		{
			return _exponentialBackoff;
		}

		public function get timeoutInSeconds():Number
		{
			return _timeoutInSeconds;
		}

		public function get retryInterval():Number
		{
			return _retryInterval;
		}

		public function get maxRetries():int
		{
			return _maxRetries;
		}

	}
}