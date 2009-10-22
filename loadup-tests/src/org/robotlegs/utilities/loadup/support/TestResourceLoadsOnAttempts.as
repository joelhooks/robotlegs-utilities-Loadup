package org.robotlegs.utilities.loadup.support
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	
	public class TestResourceLoadsOnAttempts implements IResource
	{
		protected var eventDispatcher:IEventDispatcher; 
		protected var loadAttempts:int;
		protected var attemptsUntilSuccess:int;
		
		public function TestResourceLoadsOnAttempts(eventDispatcher:IEventDispatcher, attempts:int=4)
		{
			this.eventDispatcher = eventDispatcher;
			loadAttempts = 0;
			attemptsUntilSuccess = attempts;
		}
		
		public function load():void
		{
			loadAttempts++;
			if(loadAttempts<attemptsUntilSuccess)
				eventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOAD_FAILED, this));
			else
				eventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOADED, this));
		}
	}
}