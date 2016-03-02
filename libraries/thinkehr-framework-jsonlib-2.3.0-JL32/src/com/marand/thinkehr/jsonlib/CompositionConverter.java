package com.marand.thinkehr.jsonlib;

import org.openehr.jaxb.am.Template;
import org.openehr.jaxb.rm.Composition;

import java.io.InputStream;
import java.util.Map;

/**
 * A converter that is capable of translating between a map of web template paths (usually generated from FLAT JSON composition format)
 * into org.openehr.jaxb.rm.Composition objects and vice-versa.
 *
 * <p>An example of conversion from Map to Composition:</p>
 *
 * <pre><code> // Convert from map to composition
 // The  map of web template - value pairs
 Map&lt;String, Object&gt; values = new LinkedHashMap&lt;&gt;();
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
 * </code></pre>
 *
 * <p>An example of conversion from Composition to Map:</p>
 * <pre><code> // Convert from composition to map
 Map&lt;String, Object&gt; valueMap;
 try (InputStream operationalTemplate = ConversionExample.class.getResourceAsStream("/Demo Vitals.opt")) {
 valueMap = converter.fromComposition(operationalTemplate, composition);
 }

 // ... Do something with the map, such as convert it to JSON
 </code></pre>
 *
 * <p>This two methods have counterparts that take an org.openehr.jaxb.am.Template object instead of an
 * InputStream. To produce a Template object from an .opt, use the JAXB library with the following
 * Unmarshaller:
 * </p>
 *
 * <pre><code> JAXBContext context = JAXBContext.newInstance("org.openehr.jaxb.rm:org.openehr.jaxb.am");
 Unmarshaller unmarshaller = context.createUnmarshaller();
 unmarshaller.setSchema(null); // disable schema validation</code></pre>
 *
 *
 * @author matijak
 * @since 09.02.2016
 */
public interface CompositionConverter {

    /**
     * Converts the specified map of web template path - value pairs into a Composition object.
     *
     * The following context parameters are required and MUST be supplied in the pathValueMap:
     * <ul>
     * <li>{@code ctx/language} - The language to use to resolve the terminology strings against.</li>
     * <li>{@code ctx/territory} - The territory (country).</li>
     * <li>{@code ctx/composer_name} - The name of the composer of the composition.</li>
     * </ul>
     * <p>Additional context parameters are also supported.</p>
     *
     * @param operationalTemplate An input stream (such as a class path resource or a file) pointing to an .opt (Operational Template).
     * @param pathValueMap        The map of web template paths mapped to their respective values, such as that generated from a FLAT JSON composition.
     * @return A Composition generated from the map.
     * @throws CompositionConversionException If an exception occurs for any reason during the conversion process.
     */
    Composition toComposition(InputStream operationalTemplate, Map<String, Object> pathValueMap);

    /**
     * Converts the specified map of web template path - value pairs into a Composition object.
     * <p>
     * Equivalent to {@link CompositionConverter#toComposition(InputStream, Map)}, except that it takes a Template object as an argument.
     * </p>
     * The following context parameters are required and MUST be supplied in the pathValueMap:
     * <ul>
     * <li>{@code ctx/language} - The language to use to resolve the terminology strings against.</li>
     * <li>{@code ctx/territory} - The territory (country).</li>
     * <li>{@code ctx/composer_name} - The name of the composer of the composition.</li>
     * </ul>
     * <p>Additional context parameters are also supported.</p>
     *
     * @param template     The  org.openehr.jaxb.am.Template representation of an .opt (Operational Template).
     * @param pathValueMap The map of web template paths mapped to their respective values, such as that generated from a FLAT JSON composition.
     * @return A Composition generated from the map.
     * @throws CompositionConversionException If an exception occurs for any reason during the conversion process.
     */
    Composition toComposition(Template template, Map<String, Object> pathValueMap);


    /**
     * Converts the specified Composition to a map of web template path - value pairs.
     *
     * @param operationalTemplate An input stream (such as a class path resource or a file) pointing to an .opt (Operational Template).
     * @param composition         The Composition to convert to a map of values.
     * @return A Map of web template path - value pairs, suitable for conversion into a FLAT JSON composition format.
     * @throws CompositionConversionException If an exception occurs for any reason during the conversion process.
     */
    Map<String, Object> fromComposition(InputStream operationalTemplate, Composition composition);

    /**
     * Converts the specified Composition to a map of web template path - value pairs.
     * <p>
     * Equivalent to {@link CompositionConverter#fromComposition(InputStream, Composition)}, except that it takes a Template object as an argument.
     * </p>
     *
     * @param template    The  org.openehr.jaxb.am.Template representation of an .opt (Operational Template).
     * @param composition The Composition to convert to a map of values.
     * @return A Map of web template path - value pairs, suitable for conversion into a FLAT JSON composition format.
     * @throws CompositionConversionException If an exception occurs for any reason during the conversion process.
     */
    Map<String, Object> fromComposition(Template template, Composition composition);

}
