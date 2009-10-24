package org.robotlegs.utilities.loadup.interfaces
{
	import org.robotlegs.utilities.loadup.model.ResourceEventTypes;

	/**
	 * Objects in the Loadup Queue (typically <code>Service</code> objects
	 * must implment this interface.
	 *  
	 * @author joelhooks
	 * 
	 */	
	public interface IResource
	{
		function load() :void;
		function getResourceEventTypes(value:ResourceEventTypes):ResourceEventTypes;
	}
}