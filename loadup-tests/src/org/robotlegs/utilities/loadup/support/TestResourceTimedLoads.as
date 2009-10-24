package org.robotlegs.utilities.loadup.support
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	
	public class TestResourceTimedLoads implements IResource
	{
		protected var eventDispatcher:IEventDispatcher; 
		protected var timer:Timer;
		
		public function TestResourceTimedLoads(eventDispatcher:IEventDispatcher, loadTimeMilliseconds:int=1000)
		{
			this.eventDispatcher = eventDispatcher;
			timer = new Timer(loadTimeMilliseconds, 1);
			timer.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		public function load():void
		{
			this.timer.start();
		}
		
		
		protected function handleTimer(event:Event):void
		{
			timer.stop();
			eventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.RESOURCE_LOADED, this));
		}
	}
}