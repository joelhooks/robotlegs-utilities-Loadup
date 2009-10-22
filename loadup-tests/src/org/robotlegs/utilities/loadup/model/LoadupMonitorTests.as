package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.support.TestResourceLoadsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceNeverLoads;
	
	public class LoadupMonitorTests
	{
		// Reference declaration for class to test
		private var classToTestRef : org.robotlegs.utilities.loadup.model.LoadupMonitor;
		
		protected var loadupMonitor:LoadupMonitor;
		protected var eventDispatcher:IEventDispatcher;
		
		[Before]
		public function setup():void
		{
			this.eventDispatcher = new EventDispatcher()
			this.loadupMonitor = new LoadupMonitor(eventDispatcher);
		}
		
		[Test]
		public function loadupMonitorShouldHaveDefaultResourceList():void
		{
			Assert.assertNotNull("LoadupMonitor instance should have ResourceList by default", loadupMonitor.resourceList);
		}
		
		[Test]
		public function testAddResource_resourceAdded():void
		{
			var loadupResource:IResource = new TestResourceNeverLoads(eventDispatcher);
			this.loadupMonitor.addResource( loadupResource );
			Assert.assertEquals("resourcesToLoad count should be 1", 1, loadupMonitor.resourcesToLoadCount);
		}

		[Test]
		public function testAddResourceArray_resourceArrayAdded():void
		{
			var loadupResource1:IResource = new TestResourceNeverLoads(eventDispatcher);
			var loadupResource2:IResource = new TestResourceNeverLoads(eventDispatcher);
			var loadupResource3:IResource = new TestResourceNeverLoads(eventDispatcher);
			var loadupResource4:IResource = new TestResourceNeverLoads(eventDispatcher);
			var resourceArray:Array = [loadupResource1, loadupResource2, loadupResource3, loadupResource4]
			this.loadupMonitor.addResourceArray( resourceArray );
			loadupMonitor.startResourceLoading();
			Assert.assertEquals("resourcesToLoad count should be 4", resourceArray.length, loadupMonitor.resourcesToLoadCount);
		}

		[Test(async)]
		public function allResourcesAreLoaded():void
		{
			var loadupResource1:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource2:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource3:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource4:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var resourceArray:Array = [loadupResource1, loadupResource2, loadupResource3, loadupResource4]
			this.loadupMonitor.addResourceArray( resourceArray );
			
			Async.handleEvent(this, eventDispatcher, LoadupMonitorEvent.LOADING_COMPLETE, handleAllResourcesLoadedComplete, 1000)
			
			loadupMonitor.startResourceLoading();
			
		}
		
		protected function handleAllResourcesLoadedComplete(event:LoadupMonitorEvent, data:Object):void
		{
			Assert.assertEquals("Loaded resource count should be 4", 4, loadupMonitor.resourceList.loadedResourceCount);
		}
		
		[Test]
		public function addResourceReturnsILoadupResource():void
		{
			var resource:IResource = new TestResourceNeverLoads(eventDispatcher);
			var loadupResource:ILoadupResource = loadupMonitor.addResource( resource );
			Assert.assertTrue("add resource returns ILoadupResource", loadupResource is ILoadupResource);
		}
	}
}