package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.robotlegs.utilities.loadup.intefaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.intefaces.IResource;
	import org.robotlegs.utilities.loadup.intefaces.IResourceList;
	import org.robotlegs.utilities.loadup.support.TestResourceLoadsImmediatly;
	import org.robotlegs.utilities.loadup.support.TestResourceNeverLoads;

	public class ResourceListTests
	{
		private var resourceList:IResourceList;
		private var eventDispatcher:IEventDispatcher;
		
		[Before]
		public function setup():void
		{
			eventDispatcher = new EventDispatcher()
			resourceList = new ResourceList(eventDispatcher);
		}
		
		[Test]
		public function resourceListHasDefaultLoadupResourceFactory():void
		{
			Assert.assertTrue("should be LoadupResourceFactory class", resourceList.resourceFactory is LoadupResourceFactory);
		}
		
		[Test]
		public function addResourceAddsAResource():void
		{
			var resource:IResource = new TestResourceNeverLoads(eventDispatcher);
			resourceList.addResource(resource);
			
			Assert.assertEquals("resource list should have 1 LoadupResource", 1, resourceList.count);
		}
		
		[Test]
		public function loadedResourceCountCountsLoadedResources():void
		{
			var resource:IResource = new TestResourceLoadsImmediatly(eventDispatcher);
			var loadupResource:ILoadupResource = resourceList.addResource(resource);
			loadupResource.startLoad();
			
			Assert.assertEquals("loaded resource count should be 1", 1, resourceList.loadedResourceCount);
		}
		
		[Test]
		public function closingResourceListShouldPreventAddingResources():void
		{
			var resource1:IResource = new TestResourceNeverLoads(eventDispatcher);
			var resource2:IResource = new TestResourceNeverLoads(eventDispatcher);
			resourceList.addResource(resource1);
			resourceList.closeResourceList();
			resourceList.addResource(resource2);
			Assert.assertEquals("resource list should have 1 LoadupResource", 1, resourceList.count);			
		}
		
		[Test]
		public function resourceListTracksProperPercenntLoaded():void
		{
			var resource1:ILoadupResource = resourceList.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var resource2:ILoadupResource = resourceList.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var resource3:ILoadupResource  = resourceList.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			var resource4:ILoadupResource = resourceList.addResource(new TestResourceLoadsImmediatly(eventDispatcher));
			
			resource1.startLoad();
			Assert.assertEquals("percent loaded should be 25.0", 25.0, resourceList.percentLoaded);	

			resource2.startLoad();
			Assert.assertEquals("percent loaded should be 50.0", 50.0, resourceList.percentLoaded);	

			resource3.startLoad();
			Assert.assertEquals("percent loaded should be 75.0", 75.0, resourceList.percentLoaded);
			
			resource4.startLoad();
			Assert.assertEquals("percent loaded should be 100.0", 100.0, resourceList.percentLoaded);	
		}
	}
}