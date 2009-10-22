package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.robotlegs.utilities.loadup.events.ResourceEvent;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.intefaces.IResource;
	import org.robotlegs.utilities.loadup.support.TestResourceFailsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceLoadsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceNeverLoads;

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
	}
}