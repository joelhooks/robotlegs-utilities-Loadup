package org.robotlegs.utilities.loadup.model
{
	import org.robotlegs.utilities.loadup.interfaces.IRetryParameters;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;

	public class RetryPolicy implements IRetryPolicy
	{
		private var _retryParameters:IRetryParameters;
		
		public function RetryPolicy(retryParameters:IRetryParameters)
		{
			_retryParameters = retryParameters;
		}

		public function get retryParameters():IRetryParameters
		{
			return _retryParameters;
		}

		public function set retryParameters(value:IRetryParameters):void
		{
			_retryParameters = value;
		}

	}
}