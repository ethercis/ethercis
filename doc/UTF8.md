UTF-8 Support in XML document
---

This is a quick explanation on how to support special characters into XML document. This is useful for example to pass units in a canonical XML data set.

The header of the XML document should specify the encoding:

	<?xml version="1.0" encoding="UTF-8"?>
	<composition>
		....
	<\composition>

The character is encoded using the <code>&#...;</code> syntax.

For example, the degree (°) character is encoded with:

	&#176;

Example for a temperature measurement:

    <ns2:value xsi:type="ns2:DV_QUANTITY">
        <ns2:magnitude>36.5</ns2:magnitude>
        <ns2:units>&#176;C</ns2:units>
        <ns2:precision>1</ns2:precision>
    </ns2:value>