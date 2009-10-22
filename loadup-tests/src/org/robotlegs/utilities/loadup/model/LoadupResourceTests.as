package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.robotlegs.utilities.loadup.events.LoadupMonitorEvent;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.interfaces.IResource;
	import org.robotlegs.utilities.loadup.support.TestResourceFailsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceLoadsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceLoadsOnAttempts;
	import org.robotlegs.utilities.loadup.support.TestResourceNeverLoads;
	import org.robotlegs.utilities.loadup.support.TestResourceTimedFails;

	public class LoadupResourceTests
	{
		private var loadupResource:LoadupResource;
		private var eventDispatcher:IEventDispatcher;
		private var resourceFactory:ILoadupResourceFactory;
		
		[Before]
		public function setup():void
		{
			this.eventDispatcher = new EventDispatcher();
			resourceFactory = new LoadupResourceFactory(eventDispatcher);
		}
		
		[After]
		public function teardown():void
		{
			eventDispatcher = null;
			loadupResource = null;
		}

		[Test(async)]
		public function load_loadsImmediatly_dispatchesLoadedEvent():void
		{
			var resource:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			loadupResource = new LoadupResource(resource, eventDispatcher);
			Async.handleEvent(this, eventDispatcher, ResourceEvent.RESOURCE_LOADED, handleResourceImmediatlyLoaded);
			
			resource.load();
		}
		
		private function handleResourceImmediatlyLoaded(event:ResourceEvent, data:Object):void
		{
			Assert.assertEquals("event type should be RESOURCE_LOADED", ResourceEvent.RESOURCE_LOADED, event.type);
			Assert.assertEquals("status should be loaded", LoadupResourceStatus.LOADED, loadupResource.status);
		}

		[Test(async)]
		public function load_loadFailsImmediatly_dispatchesLoadFailedEvent():void
		{
			var resource:IResource = new TestResourceFailsImmediatly(eventDispatcher);
			loadupResource = new LoadupResource(resource, eventDispatcher);
			Async.handleEvent(this, eventDispatcher, ResourceEvent.RESOURCE_LOAD_FAILED, handleResourceFailedImmediatly);
			
			resource.load();			
		}
		
		private function handleResourceFailedImmediatly(event:ResourceEvent, data:Object):void
		{
			Assert.assertEquals("event type should be RESOURCE_LOAD_FAILED", ResourceEvent.RESOURCE_LOAD_FAILED, event.type);
			Assert.assertEquals("status should be failed", LoadupResourceStatus.FAILED, loadupResource.status);			
		}

		[Test]
		public function requiredResourceNotLoadedPreventsLoading():void
		{
			var resource1:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var resource2:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceNeverLoads(eventDispatcher));
			
			resource1.required = [resource2];
			
			resource2.startLoad();
			resource1.startLoad();
			
			Assert.assertEquals("resource 1 should not be loaded", LoadupResourceStatus.INITIALIZED, resource1.status);
		}

		[Test]
		public function resourceNotLoadedAfterRequiredFails():void
		{
			var resource1:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var resource2:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceFailsImmediatly(eventDispatcher));
			
			resource1.required = [resource2];
			
			resource2.startLoad();
			resource1.startLoad();
			
			Assert.assertEquals("resource 1 should not be loaded", LoadupResourceStatus.INITIALIZED, resource1.status);
		}

		[Test]
		public function requiredResourceLoadsAfterRequiredIsLoaded():void
		{
			var resource1:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var resource2:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			
			resource1.required = [resource2];
			
			resource1.startLoad();
			
			Assert.assertEquals("resource 1 should not be loaded", LoadupResourceStatus.INITIALIZED, resource1.status);			
			
			resource2.startLoad();
			resource1.startLoad();
			
			Assert.assertEquals("resource 1 should be loaded", LoadupResourceStatus.LOADED, resource1.status);
		}
		
		[Test]
		public function cannotSetRetryPolicyWhileActivelyLoading():void
		{
			var resource1:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var retryPolicy1:RetryPolicy = new RetryPolicy(eventDispatcher);
			var retryPolicy2:RetryPolicy = new RetryPolicy(eventDispatcher);
			
			resource1.retryPolicy = retryPolicy1;
			Assert.assertEquals("resource retryPolicy should be retryPolicy1", retryPolicy1, resource1.retryPolicy);
			
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_STARTED));
			
			resource1.retryPolicy = retryPolicy2;
			Assert.assertEquals("resource retryPolicy should be retryPolicy1", retryPolicy1, resource1.retryPolicy);
		}
		
		[Test]
		public function canSetRetryPolicyAfterLoadingComplete():void
		{
			var resource1:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var retryPolicy1:RetryPolicy = new RetryPolicy(eventDispatcher);
			var retryPolicy2:RetryPolicy = new RetryPolicy(eventDispatcher);
			
			resource1.retryPolicy = retryPolicy1;
			Assert.assertEquals("resource retryPolicy should be retryPolicy1", retryPolicy1, resource1.retryPolicy);
			
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_STARTED));
			
			resource1.retryPolicy = retryPolicy2;
			Assert.assertEquals("resource retryPolicy should be retryPolicy1", retryPolicy1, resource1.retryPolicy);
			
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_COMPLETE));
			
			resource1.retryPolicy = retryPolicy2;
			Assert.assertEquals("resource retryPolicy should be retryPolicy2", retryPolicy2, resource1.retryPolicy);			
		}
		
		[Test]
		public function canSetRetryPolicyAfterLoadingFinishedIncomplete():void
		{
			var resource1:ILoadupResource = resourceFactory.createLoadupResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var retryPolicy1:RetryPolicy = new RetryPolicy(eventDispatcher);
			var retryPolicy2:RetryPolicy = new RetryPolicy(eventDispatcher);
			
			resource1.retryPolicy = retryPolicy1;
			Assert.assertEquals("resource retryPolicy should be retryPolicy1", retryPolicy1, resource1.retryPolicy);
			
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_STARTED));
			
			resource1.retryPolicy = retryPolicy2;
			Assert.assertEquals("resource retryPolicy should be retryPolicy1", retryPolicy1, resource1.retryPolicy);
			
			eventDispatcher.dispatchEvent(new LoadupMonitorEvent(LoadupMonitorEvent.LOADING_FINISHED_INCOMPLETE));
			
			resource1.retryPolicy = retryPolicy2;
			Assert.assertEquals("resource retryPolicy should be retryPolicy2", retryPolicy2, resource1.retryPolicy);			
		}
		
		[Test]
		public function resourceRetryIsAttemptedAccordingToPolicy_threeRetries():void
		{
			var resource:ILoadupResource = resourceFactory.createLoadupResource( new TestResourceLoadsOnAttempts(eventDispatcher));
			var retryParams:RetryParameters = new RetryParameters(4);
			resource.retryPolicy = new RetryPolicy(eventDispatcher);
			resource.retryPolicy.retryParameters = retryParams;
			resource.startLoad();
			Assert.assertEquals("resource should be loaded after three tries", LoadupResourceStatus.LOADED, resource.status);
			Assert.assertEquals("resource should be loaded after three tries", 3, resource.retryPolicy.failedLoadCount);
		}
		
		[Test(async)]
		public function resourceTimesOutAccordingToPolicy_500ms():void
		{
			var resource:ILoadupResource = resourceFactory.createLoadupResource( new TestResourceTimedFails(eventDispatcher, 3500));
			var retryParams:RetryParameters = new RetryParameters(0, 0, .5);
			resource.retryPolicy = new RetryPolicy(eventDispatcher);
			resource.retryPolicy.retryParameters = retryParams;
			resource.startLoad();
			
			Async.handleEvent(this, eventDispatcher, LoadupResourceEvent.LOADUP_RESOURCE_TIMED_OUT, handleTimeOutAccordingToPolicy500ms, 1000, resource);
		}
		
		protected function handleTimeOutAccordingToPolicy500ms(event:LoadupResourceEvent, data:ILoadupResource):void
		{
			Assert.assertEquals("resource status should be TIMED_OUT", LoadupResourceStatus.TIMED_OUT, data.status);
		}

		[Test(async)]
		public function resourceTimesOutAccordingToPolicy_2000ms_4Retries_500msInterval():void
		{
			var resource:ILoadupResource = resourceFactory.createLoadupResource( new TestResourceTimedFails(eventDispatcher, 100));
			var retryParams:RetryParameters = new RetryParameters(4, .5, 2);
			resource.retryPolicy = new RetryPolicy(eventDispatcher);
			resource.retryPolicy.retryParameters = retryParams;
			resource.startLoad();
			
			Async.handleEvent(this, eventDispatcher, LoadupResourceEvent.LOADUP_RESOURCE_TIMED_OUT, handleTimeOutAccordingToPolicy500ms4Retries500msInterval, 4000, resource);
		}
		
		protected function handleTimeOutAccordingToPolicy500ms4Retries500msInterval(event:LoadupResourceEvent, data:ILoadupResource):void
		{
			Assert.assertEquals("resource status should be TIMED_OUT", LoadupResourceStatus.TIMED_OUT, data.status);
		}
	}
}