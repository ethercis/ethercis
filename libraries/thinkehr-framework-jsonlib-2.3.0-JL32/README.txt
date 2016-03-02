What is thinkehr-framework-jsonlib?
-----------------------------------

The thinkehr-framework-jsonlib is library for converting Map-based ThinkEhr compositions (usually
generated from the FLAT JSON composition format) into org.openehr.jaxb.rm.Composition objects and
vice-versa.


Requirements
------------

It requires JRE 1.7 or greater and has one external dependency - the Joda-Time temporal library, as
the composition Maps can contain types from this library for temporal values.

In order to avoid joda-time version conflicts, the users of this library must provide their own
joda-time jar. Any reasonably recent version should do, such as this:

<dependency>
  <groupId>joda-time</groupId>
  <artifactId>joda-time</artifactId>
  <version>2.9.2</version>
</dependency>

If you're transforming the composition java.util.Maps into JSON output, you will need to configure
your parsers/mappers to handle joda-time objects. Here's an example for the Jackson JSON library:

ObjectMapper mapper = new ObjectMapper();
mapper.registerModule(new JodaModule());

The Jackson Joda module can be found in the com.fasterxml.jackson.datatype:jackson-datatype-joda
library.


Distribution zip structure
--------------------------

root:
    javadoc/        - contains the generated API documentation for the library
    lib/            - contains the library jar thinkehr-framework-jsonlib-{version}.jar
    src/            - contains the publicly available source code of the library
    README.txt      - this file containing instructions
    CHANGELOG.txt   - a list of recent changes


Usage
-----

Just include the thinkehr-framework-jsonlib-{version}.jar into the classpath of your application.

The com.marand.thinkehr.jsonlib.CompositionConverter is an interface to the conversion methods and
com.marand.thinkehr.jsonlib.impl.CompositionConverterImpl its default implementation. Below are
examples for converting between the two representations.

I. Map -> Composition

// Convert from map to composition
// The  map of web template - value pairs
Map<String, Object> values = new LinkedHashMap<>;();
// Required context information
values.put("ctx/language", "en");
values.put("ctx/territory", "UK");
values.put("ctx/composer_name", "John Gibson");
// The medical data
values.put("vitals/vitals/body_temperature:0/any_event:0/temperature|magnitude", 37.9d);
values.put("vitals/vitals/body_temperature:0/any_event:0/temperature|unit", "°C");

// Conversion
CompositionConverter converter = new CompositionConverterImpl();
final Composition composition;
// The .opt operational template is located in the classpath
try (InputStream operationalTemplate = ConversionExample.class.getResourceAsStream("/Demo Vitals.opt")) {
    composition = converter.toComposition(operationalTemplate, values);
}

// ... Do something with the composition


II. Composition -> Map

// Convert from composition to map
CompositionConverter converter = new CompositionConverterImpl();
Map<String, Object> valueMap;
try (InputStream operationalTemplate = ConversionExample.class.getResourceAsStream("/Demo Vitals.opt")) {
    valueMap = converter.fromComposition(operationalTemplate, composition);
}

// ... Do something with the map, such as convert it to JSON


Please refer to the supplied source code and javadoc documentation for more information.

III. Using org.openehr.jaxb.am.Template

The two conversion methods have counterparts that take an org.openehr.jaxb.am.Template object instead of an
InputStream. To produce a Template object from an .opt, use the JAXB library with the following
Unmarshaller:

JAXBContext context = JAXBContext.newInstance("org.openehr.jaxb.rm:org.openehr.jaxb.am");
Unmarshaller unmarshaller = context.createUnmarshaller();
unmarshaller.setSchema(null); // disable schema validation