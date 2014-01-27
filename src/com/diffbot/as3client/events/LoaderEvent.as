package com.diffbot.as3client.events
{
	import flash.events.Event;
	
	/**
	 * An event dispatched by the DiffbotAS3Client
	 * 
	 * @author Benjamin Durin
	 * 
	 */
	public class LoaderEvent extends Event
	{
		/**
		 * Creates a LoaderEvent instance.
		 * 
		 * @param type Type of event.
		 * @param response Contains the data returned by the API in case of a <code>complete</code> event. In case of an error event, it contains the error ID.
		 * @param bubbles Indicates whether an event is a bubbling event.
		 * @param cancelable Indicates whether the behavior associated with the event can be prevented.
		 * 
		 */
		public function LoaderEvent(type:String, response:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_response = response;
		}
		
		/** Dispatched when the the loader (or one of its children) encounters an IO_ERROR (typically when it cannot find the file at the specified <code>url</code>). */
		public static const IO_ERROR:String="ioError";
		/** Dispatched when the loader (or one of its children) encounters a SECURITY_ERROR (see Adobe's docs for details). */
		public static const SECURITY_ERROR:String="securityError";
		/** Dispatched when the loader finishes loading. */
		public static const COMPLETE:String="complete";
		
		private var _response:Object;

		/**
		 * The data returned by the API or the error ID in case of error.
		 */
		public function get response():Object
		{
			return _response;
		}
		
		/**
		 * Duplicates an instance of an Event subclass.
		 * 
		 * @return A <code>LoaderEvent</code> instance.
		 * 
		 */
		override public function clone():Event
		{
			return new LoaderEvent(type, response, bubbles, cancelable);
		}

	}
}