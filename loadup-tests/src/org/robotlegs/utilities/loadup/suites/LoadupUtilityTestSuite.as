package org.robotlegs.utilities.loadup.suites
{
	import org.robotlegs.utilities.loadup.model.LoadupMonitorTests;
	import org.robotlegs.utilities.loadup.model.LoadupResourceFactoryTests;
	import org.robotlegs.utilities.loadup.model.LoadupResourceTests;
	import org.robotlegs.utilities.loadup.model.ResourceListTests;
	import org.robotlegs.utilities.loadup.model.RetryPolicyTests;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class LoadupUtilityTestSuite
	{
		public var loadupMonitorTest:LoadupMonitorTests;
		public var loadupResourceFactoryTests:LoadupResourceFactoryTests;
		public var loadupResourceTests:LoadupResourceTests;
		public var resourceListTests:ResourceListTests;
		public var retryPolicyTests:RetryPolicyTests;
	}
}