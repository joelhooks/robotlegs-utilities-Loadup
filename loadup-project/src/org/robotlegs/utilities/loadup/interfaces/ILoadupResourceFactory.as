package org.robotlegs.utilities.loadup.interfaces
{
	public interface ILoadupResourceFactory
	{
		function createLoadupResource(fromResource:IResource):ILoadupResource

		function get defaultRetryPolicy():IRetryPolicy;
		function set defaultRetryPolicy(value:IRetryPolicy):void;
	}
}