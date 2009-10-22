package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.intefaces.IResource;
	import org.robotlegs.utilities.loadup.support.TestResourceNeverLoads;

	public class LoadupResourceFactoryTests
	{
		private var eventDispatcher:IEventDispatcher;
		
		[Before]
		public function setup():void
		{
			this.eventDispatcher = new EventDispatcher();
		}
		
		[Test]
		public function createLoadupResource_returnsLoadupResource():void
		{
			var loadupResourceFactory:ILoadupResourceFactory = new LoadupResourceFactory(eventDispatcher);
			var resource:IResource = new TestResourceNeverLoads(eventDispatcher)
			var loadupResource:ILoadupResource = loadupResourceFactory.createLoadupResource(resource);
			Assert.assertTrue("loadupResource should be of type LoadupResource", loadupResource is LoadupResource);
		}
	}
}