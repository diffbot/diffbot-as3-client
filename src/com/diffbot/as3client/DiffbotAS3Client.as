package com.diffbot.as3client
{
	import com.diffbot.as3client.events.LoaderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/** Dispatched when the loader completes. */
	[Event(name="complete", type="com.diffbot.as3client.events.LoaderEvent")]
	/** Dispatched when the loader encounters an IO_ERROR. */
	[Event(name="ioError", type="com.diffbot.as3client.events.LoaderEvent")]
	/** Dispatched when the loader encounters an SECURITY_ERROR. */
	[Event(name="securityError", type="com.diffbot.as3client.events.LoaderEvent")]

	/**
	 * The Diffbot AS3 client library
	 * 
	 * @author Benjamin Durin
	 * 
	 */
	public class DiffbotAS3Client extends EventDispatcher
	{
		/**
		 * Creates a DiffbotAS3Client instance to call Diffbot automatic API
		 * 
		 * @param developerToken The developer token.
		 * 
		 */
		public function DiffbotAS3Client(developerToken:String)
		{
			token = developerToken;
		}
		
		/** The Diffbot API URL */
		protected const DIFFBOT_API_URL:String = "http://api.diffbot.com/";
		/** The Article API names*/
		protected const ARTICLE_API_NAME:String = "article";
		/** The Frontpage API names*/
		protected const FRONTPAGE_API_NAME:String = "frontpage";
		/** The Product API names*/
		protected const PRODUCT_API_NAME:String = "product";
		/** The Image API names*/
		protected const IMAGE_API_NAME:String = "image";
		/** The Analyze API names*/
		protected const CLASSIFIER_API_NAME:String = "analyze";
		
		/** The loader used to call Diffbot API */
		protected var loader:URLLoader;
		/** The developer token */
		protected var token:String;		
		
		/**
		 * Extracts clean article text from the article at the specified URL.
		 * 
		 * @param url The URL of the article to process.
		 * @param fields Used to control which fields are returned by the API. Each field is a <code>String</code>. For nested arrays, use parentheses to retrieve specific fields, or * to return all sub-fields. Example: <code>["icon", "author", "images(url)"]</code>
		 * @param timeout A value in milliseconds to terminate the response. <code>0</code> means there is no timeout.
		 * @param version The version of the API.
		 * 
		 */
		public function getArticle(url:String, fields:Vector.<String> = null, timeout:Number = 0, version:uint = 2):void
		{
			JSONCall(url, ARTICLE_API_NAME, fields, timeout, version);
		}
		
		/**
		 * Analyzes a shopping or e-commerce product page and returns information on the product at the specified URL.
		 * 
		 * @param url The URL of the product page to process.
		 * @param fields Used to control which fields are returned by the API. Each field is a <code>String</code>. For nested arrays, use parentheses to retrieve specific fields, or * to return all sub-fields. Example: <code>["url", "products(title)"]</code>
		 * @param timeout A value in milliseconds to terminate the response. <code>0</code> means there is no timeout.
		 * @param version The version of the API.
		 * 
		 */
		public function getProduct(url:String, fields:Vector.<String> = null, timeout:Number = 0, version:uint = 2):void
		{
			JSONCall(url, PRODUCT_API_NAME, fields, timeout, version);
		}
		
		/**
		 * Analyzes a web page at the specified URL and returns its primary image(s).
		 * 
		 * @param url The URL to process
		 * @param fields Used to control which fields are returned by the API. Each field is a <code>String</code>. For nested arrays, use parentheses to retrieve specific fields, or * to return all sub-fields. Example: <code>["url", "images(url)"]</code>
		 * @param timeout A value in milliseconds to terminate the response. <code>0</code> means there is no timeout.
		 * @param version The version of the API.
		 * 
		 */
		public function getImage(url:String, fields:Vector.<String> = null, timeout:Number = 0, version:uint = 2):void
		{
			JSONCall(url, IMAGE_API_NAME, fields, timeout, version);
		}
		
		/**
		 * Takes in a multifaceted “homepage” and returns individual page elements.
		 * @param url Frontpage URL from which to extract items.
		 * @param timeout A value in milliseconds to terminate the response. <code>0</code> means there is no timeout.
		 * @param version The version of the API.
		 * 
		 */
		public function getFrontpage(url:String, timeout:Number = 0, version:uint = 2):void
		{
			JSONCall(url, FRONTPAGE_API_NAME, null, timeout, version);
		}
		
		/**
		 * Takes any web link and automatically determines what type of page it is.
		 * 
		 * @param url The URL to process
		 * @param fields Used to control which fields are returned by the API. Each field is a <code>String</code>. For nested arrays, use parentheses to retrieve specific fields, or * to return all sub-fields. Example: <code>["url", "images(url)"]</code>
		 * @param version The version of the API.
		 * 
		 */
		public function getClassifier(url:String, fields:Vector.<String> = null, version:uint = 2):void
		{
			JSONCall(url, CLASSIFIER_API_NAME, fields, 0, version);
		}
		
		/**
		 * The method that makes the call to the API.
		 *  
		 * @param url The URL to be processed.
		 * @param api The API name.
		 * @param fields Used to control which fields are returned by the API. Each field is a <code>String</code>. For nested arrays, use parentheses to retrieve specific fields, or * to return all sub-fields. Example: <code>["url", "images(url)"]</code>
		 * @param timeout A value in milliseconds to terminate the response. <code>0</code> means there is no timeout.
		 * @param version The version of the API.
		 * 
		 */
		protected function JSONCall(url:String, api:String,  fields:Vector.<String> = null, timeout:Number = 0, version:uint = 2):void
		{
			var request:URLRequest = new URLRequest(getCompleteAPIURL(version, api));
			var variables:URLVariables = new URLVariables;
			variables.token = token;
			variables.url = url;
			variables.format = "json";
			if (fields && fields.length > 0)
				variables.fields = fields.join();
			if (timeout > 0)
				variables.timeout = timeout;
			request.data = variables;
			loader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, JSONLoadedHandler, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			/** Dispatch a security error event with the error ID */
			dispatchEvent(new LoaderEvent(LoaderEvent.SECURITY_ERROR, event.errorID));
		}
		
		protected function IOErrorHandler(event:IOErrorEvent):void
		{
			/** Dispatch a IO error event with the error ID */
			dispatchEvent(new LoaderEvent(LoaderEvent.IO_ERROR, event.errorID));
		}
		
		protected function JSONLoadedHandler(event:Event):void
		{
			var result:Object;
			if (loader.data)
			{
				result = JSON.parse(loader.data);
			}
			/** Dispatch a complete event with the result object */
			dispatchEvent(new LoaderEvent(LoaderEvent.COMPLETE, result));
		}
		
		/**
		 * Builds the API URL with the version number and the API name
		 * 
		 * @param version The version of the API.
		 * @param api The name of the API.
		 * @return The constructed API URL
		 * 
		 */
		protected function getCompleteAPIURL(version:uint, api:String):String
		{
			return DIFFBOT_API_URL + "v" + version + "/" + api;
		}
	}
}