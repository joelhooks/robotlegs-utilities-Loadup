package org.robotlegs.utilities.loadup.interfaces
{
	public interface ILoadupResource
	{
		function get status():int;
		function get resource():IResource;
		function set required(value:Array):void;
		function get loadStartTimeMilliseconds():Number;
		function get canLoad():Boolean;
		
		function startLoad():void;
		
		function get retryPolicy():IRetryPolicy;
		function set retryPolicy(value:IRetryPolicy):void;
	}
}