package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.interfaces.IRetryParameters;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;
	import org.robotlegs.utilities.loadup.support.TestResourceFailsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceLoadsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceNeverLoads;
	import org.robotlegs.utilities.loadup.support.TestResourceTimedLoads;
	
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
			loadupMonitor.addResourceArray( resourceArray );
			loadupMonitor.startResourceLoading();
			Assert.assertEquals("resourcesToLoad count should be 4", resourceArray.length, loadupMonitor.resourcesToLoadCount);
		}
		
		[Test(async)]
		public function allResourcesAreSuccessfullyLoaded():void
		{
			var loadupResource1:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource2:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource3:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource4:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var resourceArray:Array = [loadupResource1, loadupResource2, loadupResource3, loadupResource4]
			loadupMonitor.addResourceArray( resourceArray );
			
			Async.handleEvent(this, eventDispatcher, LoadupMonitorEvent.LOADING_COMPLETE, handleAllResourcesAreSuccessfullyLoaded, 1000)
			
			loadupMonitor.startResourceLoading();
			
		}
		
		protected function handleAllResourcesAreSuccessfullyLoaded(event:LoadupMonitorEvent, data:Object):void
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
		
		[Test(async)]
		public function allResourcesAreLoadedButIncompleteWithOneFailure():void
		{
			var loadupResource1:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource2:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource3:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource4:IResource = new TestResourceFailsImmediatly(eventDispatcher);
			var resourceArray:Array = [loadupResource1, loadupResource2, loadupResource3, loadupResource4]
			this.loadupMonitor.addResourceArray( resourceArray );
			
			Async.handleEvent(this, eventDispatcher, LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleAllResourcesLoadedButIncompleteWithOneFailure, 1000)
			
			loadupMonitor.startResourceLoading();
			
		}
		
		protected function handleAllResourcesLoadedButIncompleteWithOneFailure(event:LoadupMonitorEvent, data:Object):void
		{
			Assert.assertEquals("Loaded resource count should be 3", 3, loadupMonitor.resourceList.loadedResourceCount);
			Assert.assertEquals("failed resource count should be 1", 1, event.data.length);
		}

		[Test(async)]
		public function allResourcesAreLoadedButIncompleteWithOneFailureAndOneTimeout():void
		{
			var loadupResource1:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource2:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource3:IResource = new TestResourceNeverLoads(eventDispatcher);
			var loadupResource4:IResource = new TestResourceFailsImmediatly(eventDispatcher);
			
			var resourceArray:Array = [loadupResource1, loadupResource2, loadupResource3, loadupResource4]
			
			//custom retry policy so we aren't waiting...
			var retryPolicy:IRetryPolicy = new RetryPolicy(eventDispatcher);
			var retryParameters:IRetryParameters = new RetryParameters(0,0,.5);
			retryPolicy.retryParameters = retryParameters;
			loadupMonitor.defaultRetryPolicy = retryPolicy;
			
			loadupMonitor.addResourceArray( resourceArray );
			
			Async.handleEvent(this, eventDispatcher, LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleAllResourcesLoadedButIncompleteWithOneFailureAndOneTimeout, 1000)
			loadupMonitor.startResourceLoading();
			
		}
		
		protected function handleAllResourcesLoadedButIncompleteWithOneFailureAndOneTimeout(event:LoadupMonitorEvent, data:Object):void
		{
			Assert.assertEquals("Loaded resource count should be 2", 2, loadupMonitor.resourceList.loadedResourceCount);
			Assert.assertEquals("failed resource count should be 2", 2, event.data.length);
		}

		[Test(async)]
		public function loadFinishesAsOrderedWithLongDelayFromFirstWithDefaultRetry():void
		{
			var resource1:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var resource2:IResource = new TestResourceTimedLoads(eventDispatcher, 2500);
			
			
			var loadupResource1:ILoadupResource = loadupMonitor.addResource( resource1 );
			var loadupResource2:ILoadupResource = loadupMonitor.addResource( resource2 );
			
			loadupResource1.required = [loadupResource2]
			
			Async.handleEvent(this, eventDispatcher, LoadupMonitorEvent.LOADING_COMPLETE, handleLoadFinishesAsOrderedWithLongDelayFromFirstWithDefaultRetry, 6000)
			loadupMonitor.startResourceLoading();
			
		}
		
		protected function handleLoadFinishesAsOrderedWithLongDelayFromFirstWithDefaultRetry(event:LoadupMonitorEvent, data:Object):void
		{
			Assert.assertEquals("Loaded resource count should be 2", 2, loadupMonitor.resourceList.loadedResourceCount);
		}

		[Test(async)]
		public function chained_Requires_With_Failure_Dispatches_Loading_Finished_Incomplete():void
		{
			var loadupResource1:ILoadupResource = loadupMonitor.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var loadupResource2:ILoadupResource = loadupMonitor.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var loadupResource3:ILoadupResource = loadupMonitor.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var loadupResource4:ILoadupResource = loadupMonitor.addResource(new TestResourceFailsImmediatly(eventDispatcher));
			
			loadupResource1.required = [loadupResource2, loadupResource4];
			loadupResource3.required = [loadupResource1]
				
			Async.handleEvent(this, eventDispatcher, LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE, handleChainedRequiresWithFailureDispatchesLoadingFinishedIncomplete, 1000)
			loadupMonitor.startResourceLoading();
		}
		
		protected function handleChainedRequiresWithFailureDispatchesLoadingFinishedIncomplete(event:LoadupMonitorEvent, data:Object):void
		{
			Assert.assertEquals("Loaded resource count should be 1", 1, loadupMonitor.resourceList.loadedResourceCount);
			Assert.assertEquals("failed resource count should be 3", 3, event.data.length);
		}
	}
}