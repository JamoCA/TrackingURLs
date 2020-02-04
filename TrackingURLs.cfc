component
	displayname="trackingURLs"
	output = false
	hint = "I parse strings and attempt to identify ship tracking numbers."
	accessors=false {

	/*
		* Version 1.0 - January 31, 2020
		* Author: James Moberg - SunStar Media https://www.sunstarmedia.com/
		* Inspired by https://github.com/darkain/php-tracking-urls/blob/master/php-tracking-urls.php
	*/

	public component function init() output=false hint="initialize library" {
		variables.providers = [{
				"name"= "S10 - International Standard",
				"url" = "https://pkge.net/parcel/detect-courier/",
				"reg" = "^[A-Z]{2}[0-9]{9}(AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BA|BW|BV|BR|IO|BN|BG|BF|BI|KH|CM|CA|CV|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CY|CZ|DK|DJ|DM|DO|TP|EC|EG|SV|GQ|ER|EE|ET|FK|FO|FJ|FI|FR|FX|GB|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MK|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|AN|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|RE|RO|RU|RW|SH|KN|LC|PM|VC|WS|SM|ST|SA|SN|CS|SC|SL|SG|SK|SI|SB|SO|ZA|GS|ES|LK|SD|SR|SJ|SZ|SE|CH|SY|TW|TJ|TZ|TH|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|UK|UM|UY|UZ|VU|VA|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$"
			},{
				"name"= "UPS - UNITED PARCEL SERVICE",
				"url" = "https://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&InquiryNumber1=",
				"reg" = "^(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|T\d{3} ?\d{4} ?\d{3})$"
			},{
				"name"= "UPS - UNITED PARCEL SERVICE - GROUND",
				"url" = "https://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&InquiryNumber1=",
				"reg" = "^(K\d{10})$"
			},{
				"name"= "UPS - UNITED PARCEL SERVICE - NEXT DAY EXPRESS",
				"url" = "https://wwwapps.ups.com/WebTracking/processInputRequest?TypeOfInquiryNumber=T&InquiryNumber1=",
				"reg" = "^(J\d{10})$"
			},{
				"name"= "USPS - UNITED STATES POSTAL SERVICE - FORMAT 1",
				"url" = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=",
				"reg" = "^((420 ?\d{5} ?)?(91|92|93|94|01|03|04|70|23|13)\d{2} ?\d{4} ?\d{4} ?\d{4} ?\d{4}( ?\d{2,6})?)$"
			},{
				"name"= "USPS - UNITED STATES POSTAL SERVICE - FORMAT 2",
				"url" = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=",
				"reg" = "^((M|P[A-Z]?|D[C-Z]|LK|E[A-C]|V[A-Z]|R[A-Z]|CP|EK|EL|CJ|LC|LJ) ?\d{3} ?\d{3} ?\d{3} ?[A-Z]?[A-Z]?)$"
			},{
				"name"= "USPS - UNITED STATES POSTAL SERVICE - FORMAT 3",
				"url" = "https://tools.usps.com/go/TrackConfirmAction?qtc_tLabels1=",
				"reg" = "^(82 ?\d{3} ?\d{3} ?\d{2})$"
			},{
				"name"= "FEDEX - FEDERAL EXPRESS",
				"url" = "https://www.fedex.com/Tracking?language=english&cntry_code=us&tracknumbers=",
				"reg" = "^(((96\d\d|6\d)\d{3} ?\d{4}|96\d{2}|\d{4}) ?\d{4} ?\d{4}( ?\d{3})?)$"
			},{
				"name"= "ONTRAC",
				"url" = "https://www.ontrac.com/trackres.asp?tracking_number=",
				"reg" = "^((C|D)\d{14})$"
			},{
				"name"= "DHL",
				"url" = "https://www.dhl.com/content/g0/en/express/tracking.shtml?brand=DHL&AWB=",
				"reg" = "^\d{4}[- ]?\d{4}[- ]?\d{2}|\d{3}[- ]?\d{8}|[A-Z]{3}\d{7}$"
			}
		];
		return this;
	}

	public struct function getTrackingInfo(string trackingNumber="") hint="I return a struct based on the matched regex" {
		var response = {service="", url=""};
		var temp = {};
		var testNumber = ucase(javacast("string", arguments.trackingNumber).replaceAll("\s+", ""));
		for (temp.provider in variables.providers) {
			var temp.test = rematch(temp.provider.reg, testNumber);
			if (arrayLen(temp.test)){
				response.url = temp.provider.url & URLEncodedFormat(arguments.trackingNumber);
				response.service = temp.provider.name;
				break;
			}
		}
		return response;
	}

	public boolean function isUPS(required string trackingNumber){
		var lookup = getTrackingInfo(arguments.trackingNumber);
		return javacast("boolean", trim(listfirst(lookup.service," - ")) IS "UPS");
	}

	public boolean function isUSPS(required string trackingNumber){
		var lookup = getTrackingInfo(arguments.trackingNumber);
		return javacast("boolean", trim(listfirst(lookup.service," - ")) IS "USPS");
	}

	public boolean function isFedex(required string trackingNumber){
		var lookup = getTrackingInfo(arguments.trackingNumber);
		return javacast("boolean", trim(listfirst(lookup.service," - ")) IS "FEDEX");
	}

	public boolean function isDHL(required string trackingNumber){
		var lookup = getTrackingInfo(arguments.trackingNumber);
		return javacast("boolean", trim(listfirst(lookup.service," - ")) IS "DHL");
	}

	public boolean function isS10(required string trackingNumber){
		var lookup = getTrackingInfo(arguments.trackingNumber);
		return javacast("boolean", trim(listfirst(lookup.service," - ")) IS "S10");
	}

	public boolean function isOnTrac(required string trackingNumber){
		var lookup = getTrackingInfo(arguments.trackingNumber);
		return javacast("boolean", trim(listfirst(lookup.service," - ")) IS "ONTRAC");
	}

}
