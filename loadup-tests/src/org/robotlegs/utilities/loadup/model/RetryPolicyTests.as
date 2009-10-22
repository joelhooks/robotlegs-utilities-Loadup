package org.robotlegs.utilities.loadup.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.robotlegs.utilities.loadup.events.LoadupResourceEvent;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResource;
	import org.robotlegs.utilities.loadup.interfaces.ILoadupResourceFactory;
	import org.robotlegs.utilities.loadup.interfaces.IRetryPolicy;

	public class RetryPolicyTests
	{
		protected var eventDispatcher:IEventDispatcher;
		protected var retryPolicy:IRetryPolicy;
		protected var resourceFactory:ILoadupResourceFactory;
		
		[Before]
		public function setup():void
		{
			eventDispatcher = new EventDispatcher();
			retryPolicy = new RetryPolicy(eventDispatcher);
			resourceFactory = new LoadupResourceFactory(eventDispatcher);
		}
		
		[Test]
		public function addingFailureIncrementsFailedCountByOne():void
		{
			Assert.assertEquals("failed load count should be 0", 0, retryPolicy.failedLoadCount);
			
			retryPolicy.addFailedLoad();
			
			Assert.assertEquals("failed load count should be 1", 1, retryPolicy.failedLoadCount);
		}
		
		[Test]
		public function totalTimeForFailureIsUpdatedOnFailure():void
		{
			retryPolicy.addFailedLoad(2000);
			Assert.assertEquals("total fail time should be 2 seconds", 2, retryPolicy.totalFailureTimeInSeconds);
		}
		
	}
}