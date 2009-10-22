/*
	PureMVC Utility - Loadup - Manage loading of resources
	Copyright (c) 2008-, collaborative, as follows
	2008-2009 Philip Sexton <philip.sexton@puremvc.org>
	Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.robotlegs.utilities.loadup
{
	/**
	*  The Loadup utility (LU) offers a solution to the problem of how to manage the 
	*  loading of data resources, be that at application startup or at some other time in the 
	*  duration of the application.  By resources, we mean data resources or resources that conform
	*  to the resource model adopted by LU.  This is the essential LU facility, the kernel, implemented 
	*  by the classes in the controller, interfaces and model packages.  These are independent of the
	*  assetloader package, which is an optional sub-system.  This kernel is based around the 
	*  LoadupMonitorProxy class.  See that class for the primary documentation of the LU kernel.
	*  <p>
	*  The assetloader sub-system offers a solution to the loading of external assets, for example
	*  display assets.  It uses the LU kernel just as a client application would.  The general idea is
	*  <ul><li>
	*  there is a group of assets i.e. a set of urls</li>
	*  <li>the group is to be loaded as one loadup task, using a LoadupMonitorProxy instance</li>
	*  <li>each url implies a particular asset type</li>
	*  <li>each asset type maps to a particular asset class and asset loader class</li>
	*  <li>each asset is fronted by an AssetProxy; this proxy implements the LU kernel interface 
	*  ILoadupProxy and has the asset loader class in a delegate role</li>
	*  <li>the group of assets is fronted by an AssetGroupProxy.</li></ul>
	*  <p>
	*  One way to become familiar with this sub-system is as follows
	*  <ul><li>
	*  see the AssetTypeMap, AssetFactory and AssetLoaderFactory classes</li>
	*  <li>see the AssetGroupProxy and AssetProxy classes</li>
	*  <li>see the LoadupForAssets demo, as an example use.</li>
	*  </ul></p>
	*/
	public class Loadup {

        /**
         *  Loadup core: Notifications to Client App
         */
		public static const LOADING_PROGRESS :String = "luLoadingProgress";
		public static const LOADING_COMPLETE :String = "luLoadingComplete";
		public static const LOADING_FINISHED_INCOMPLETE :String = "luLoadingFinishedIncomplete";
		public static const RETRYING_LOAD_RESOURCE :String = "luRetryingLoadResource";
		public static const LOAD_RESOURCE_TIMED_OUT :String = "luLoadResourceTimedOut";
		public static const CALL_OUT_OF_SYNC_IGNORED :String = "luCallOutOfSyncIgnored";
		public static const WAITING_FOR_MORE_RESOURCES :String = "luWaitingForMoreResources";

        /**
         *  Loadup asset loader: Notifications to LU Core and available to Client App
         */
		public static const ASSET_LOADED :String = "luAssetLoaded";
		public static const ASSET_LOAD_FAILED :String = "luAssetLoadFailed";

        /**
         *  Loadup asset loader: Notifications to Client App
         */
		public static const ASSET_GROUP_LOAD_PROGRESS :String = "luAssetGroupLoadProgress";
		public static const ASSET_LOAD_FAILED_IOERROR :String = "luAsetLoadFailedIOError";
		public static const ASSET_LOAD_FAILED_SECURITY :String = "luAsetLoadFailedSecurity";
		public static const NEW_ASSET_AVAILABLE :String = "luNewAssetAvailable";
		public static const URL_REFUSED_PROXY_NAME_ALREADY_EXISTS :String =
		    "luUrlRefusedProxyNameAlreadyExists";

        /**
         *  Loadup asset loader: Asset Type constants
         */
        public static const IMAGE_ASSET_TYPE :String = "luImageAssetType";
        public static const TEXT_ASSET_TYPE :String = "luTextAssetType";
        public static const SWF_ASSET_TYPE :String = "luSwfAssetType";

        /**
         *  See LoadupMonitorProxy class
         */
        public static const PREFIX_IF_AUTO_LRP_NAME :String = "luLR_";
	}

}
