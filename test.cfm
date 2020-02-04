<!--- Generate a row-delimited data set of various tracking numbers listed on StackOverflow --->
<cfsavecontent variable="TestNumbers">
--USPS
70160910000108310009   (USPS certified)
23153630000057728970   (USPS signature confirmation)
RE360192014US          (USPS registered mail)
EL595811950US          (USPS priority express)
9374889692090270407075 (USPS regular)
EK225651436US          (USPS Express mail)
--FEDEX
810132562702  (FEDEX: all seem to follow same pattern regardless)
795223646324  (FEDEX: all seem to follow same pattern regardless)
785037759224  (FEDEX: all seem to follow same pattern regardless)
--UPS
K2479825491         (UPS ground)
J4603636537         (UPS next day express)
1Z87585E4391018698  (UPSregular)
--DHL
D10011565726183
C11229059490623
--S10 International Standard
RB123456785GB
</cfsavecontent>
<cfset TestNumbers = ListToArray(TestNumbers, chr(10))>


<!--- Initialize libary --->
<cfset TrackingURLs = new TrackingURLs()>

<!--- loop over IDs and display results --->
<cfloop Array="#TestNumbers#" INDEX="thisNum">
	<cfif Left(trim(thisNum),2) IS "--">
		<cfoutput>
			<h2>#trim(ListLast(ThisNum,"-"))#</h2>
		</cfoutput>
	<cfelseif LEN(trim(thisNum))>
		<cfset testID = trim(ListFirst(thisNum,"("))>
		<cfset result = TrackingURLs.getTrackingInfo(testID)>
		<cfoutput>
			<fieldset><legend>Test: #testID#</legend>
				<cfif LEN(result.service)>
					<div>
						<b>Service:</b> #Result.Service#<br>
						<b>URL:</b> <a href="#result.url#">#result.url#</a>
					</div>
					<div><b>isUPS:</b> #TrackingURLs.isUPS(testID)#
						<b>isFedex:</b> #TrackingURLs.isFedex(testID)#
						<b>isUSPS:</b> #TrackingURLs.isUSPS(testID)#
						<b>isDHL:</b> #TrackingURLs.isDHL(testID)#
						<b>isS10:</b> #TrackingURLs.isS10(testID)#
						<b>isOnTrac:</b> #TrackingURLs.isOnTrac(testID)#
					</div>
				<cfelse>
					<i>Unknown</i>
				</cfif>
			</fieldset>
		</cfoutput>
	</cfif>
</cfloop>
