package org.robotlegs.utilities.loadup.interfaces
{
	public interface IResourceList
	{
		function get count():int;
		function get resources():Array;
			
		function get resourceFactory():ILoadupResourceFactory;
		function set resourceFactory(value:ILoadupResourceFactory):void;
		
		function get loadedResourceCount():int
		function get percentLoaded():Number
			
		function get defaultRetryPolicy():IRetryPolicy;
		function set defaultRetryPolicy(value:IRetryPolicy):void;
		
		function addResource(resource:IResource):ILoadupResource;
		function closeResourceList():void;
			
	}
}