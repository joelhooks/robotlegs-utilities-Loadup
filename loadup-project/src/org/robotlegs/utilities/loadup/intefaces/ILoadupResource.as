package org.robotlegs.utilities.loadup.intefaces
{
	public interface ILoadupResource
	{
		function get status():int;
		function get resource():IResource;
		function set required(value:Array):void;
		function startLoad():void;
	}
}