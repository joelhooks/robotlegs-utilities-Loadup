package org.robotlegs.utilities.loadup.model
{
	import org.robotlegs.utilities.loadup.interfaces.IRetryParameters;
	
	public class RetryParameters implements IRetryParameters
	{
		protected var _maxRetries:int;
		protected var _retryInterval:Number;
		protected var _timeout:Number;
		protected var _exponentialBackoff:Boolean;
		
		public function RetryParameters( maxRetries:int = 0, retryInterval:Number = 0, timeout:Number = 0, exponentialBackoff:Boolean 	= false )
		{
			_maxRetries = maxRetries >= 0 ? maxRetries : 0;
			_retryInterval = retryInterval >= 0 ? retryInterval : 0;
			_timeout = timeout >= 0 ? timeout : 0;
			_exponentialBackoff = exponentialBackoff;
		}

		public function get exponentialBackoff():Boolean
		{
			return _exponentialBackoff;
		}

		public function get timeout():Number
		{
			return _timeout;
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