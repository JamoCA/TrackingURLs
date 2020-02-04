# TrackingURLs
A ColdFusion CFC to parse &amp; identify ship tracking numbers.

```
<cfscript>
TrackingURLs = new TrackingURLs();

cfparam(name="Form.TrackingNumber", default="");

result = TrackingURLs.getTrackingInfo(Form.TrackingNumber);

if (request.isURL(result.url)){
	//location(result.url);
	writedump(result);
} else {
	writeoutput("<p>Sorry. Tracking number "#EncodeForHTML(Form.TrackingNumber)#" seems invalid.</p>");
}

writeOutput("<p>isFedex = #TrackingURLs.isFedex(Form.TrackingNumber)#</p>");

writeOutput("<p>isUSPS = #TrackingURLs.isUSPS(Form.TrackingNumber)#</p>");

writeOutput("<p>isDHL = #TrackingURLs.isDHL(Form.TrackingNumber)#</p>");

writeOutput("<p>isS10 = #TrackingURLs.isS10(Form.TrackingNumber)#</p>");

writeOutput("<p>isOnTrac = #TrackingURLs.isOnTrac(Form.TrackingNumber)#</p>");
</cfscript>
```
