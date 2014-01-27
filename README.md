# Diffbot API AS3 client

## Introduction

This client is written in pure AS3 with no dependencies from external libraries.

The following products can be called from this client:

* Article
* Frontpage
* Product
* Image
* Classifier

## Installation

Link your project to the `bin/DiffbotAS3Client.swc` file and you're done. The process to link a libray file depends on your IDE. Please check the documentation of your IDE.

## Configuration

First make sure to import the classes of the library in your code, as below:
```as3
import com.diffbot.as3client.DiffbotAS3Client;
import com.diffbot.as3client.events.LoaderEvent;
```
Then create an instance of the client, passing your developer token:
You can obtain a developer token at http://diffbot.com/pricing

```as3
var diffbot:DiffbotAS3Client = new DiffbotAS3Client("DIFFBOT_TOKEN");
```
Then, we can move on to making actual requests.


## Usage

### Article API

With your client instance, call the `getArticle` method, passing the URL you want to process:

```as3
diffbot.getArticle("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/");
```
Listen for the `complete` event:

```as3
diffbot.addEventListener(LoaderEvent.COMPLETE, diffbotCompleteHandler);
```
And listen for errors:
```as3
diffbot.addEventListener(LoaderEvent.IO_ERROR, diffbotErrorHandler);
diffbot.addEventListener(LoaderEvent.SECURITY_ERROR, diffbotErrorHandler);
```

When the request completes, you can access the results in `event.response`:
```as3
protected function diffbotCompleteHandler(event:LoaderEvent):void
{
	if (event.response.error)
		trace("Error " + event.response.errorCode + ": " + event.response.error);
	else
		trace(event.response.title);
}
```

And the handler for network and security errors:
```as3
protected function diffbotErrorHandler(event:LoaderEvent):void
{
	trace("Error N." + event.response);
}
```
####Filtering Fields
You can filter the fields returned by the API by passing a `Vector` of `String`:

```as3
diffbot.getImage("http://www.overstock.com/Home-Garden/iRobot-650-Roomba-Vacuuming-Robot/7886009/product.html", new <String>["title", "images(mime,pixelWidth,pixelHeight)"]);
```
Please see [Diffbot documentation] for available fields.
[Diffbot documentation]:http://www.diffbot.com/products/automatic/

####Timeout
You can specify a timeout in milliseconds (by default, there is no timeout):
```as3
diffbot.getArticle("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/",  null, 10000);
```
####Version
The last parameter let you specify the API version, by default it is 2:
```as3
diffbot.getArticle("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/",  null, 0, 1);
```
### Frontpage API

It is similar to the Article API but it doesn't take a `fields` parameter:

```as3
diffbot.getFrontpage("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/");
```
### Product API

It is similar to the Article API:

```as3
diffbot.getProduct("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/");
```
### Image API

It is similar to the Article API:

```as3
diffbot.getImage("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/");
```
### Classifier API

It is similar to the Article API but it doesn't take a `timeout` parameter:

```as3
diffbot.getClassifier("http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/");
```

-Initial commit by Benjamin Durin-
