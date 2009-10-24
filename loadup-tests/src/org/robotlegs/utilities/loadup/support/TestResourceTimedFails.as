package org.robotlegs.utilities.loadup.support
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.model.ResourceEventTypes;
	
	public class TestResourceTimedFails implements IResource
	{
		protected var eventDispatcher:IEventDispatcher; 
		protected var timer:Timer;
		protected var loadAttempts:int;
		
		public function TestResourceTimedFails(eventDispatcher:IEventDispatcher, loadTimeMilliseconds:int = 1000)
		{
			this.eventDispatcher = eventDispatcher;
			timer = new Timer(loadTimeMilliseconds, 1);
			loadAttempts = 0;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
		}
		
		public function load():void
		{
			timer.reset();
			timer.start();
		}
		
		protected function handleTimer(event:Event):void
		{
			loadAttempts++;
			timer.stop();
			timer.reset();
			eventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOAD_FAILED, this));
		}
		
		public function getResourceEventTypes(value:ResourceEventTypes):ResourceEventTypes
		{
			return value;
		}
	}
}