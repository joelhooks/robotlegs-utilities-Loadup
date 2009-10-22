package org.robotlegs.utilities.loadup.interfaces
{
	public interface ILoadupMonitor
	{
		function get retryPolicy():IRetryPolicy;
		function set retryPolicy(value:IRetryPolicy):void;
		
		function get resourceList():IResourceList;
		function set resourceList(value:IResourceList):void;
		
		function get resourcesToLoadCount():int;
		
		function addResource(resource:IResource):ILoadupResource;
		function addResourceArray(resourceArray:Array):void;
	}
}