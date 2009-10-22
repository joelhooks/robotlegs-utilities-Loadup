package org.robotlegs.utilities.loadup.intefaces
{
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
	}
}