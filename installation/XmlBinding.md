How to generate XML bindings with XMLBeans and IntelliJ
=====================================================

Since I found the generation of POJOs bindings with the current schemas can be confusing, here is a brief synopsis
explaining how to generate the java XML bindings using XMLBeans.

Environment
===========

- JetBrains IntelliJ 14.
- XmlBeans 2.6.0

(if Java EE facet is set, the java code generation from XSD is normally enabled)

Code Generation:
================

- Create a directory holding the correct XSD for Template and OperationalTemplate (schemas/.)
- Create a module defined with Web and WebService facets. It enables the contextual menu: `WebServices`
- Select WebServices (two options: JAXB, XmlBeans)
- Generate java code from XML Schema using XMLBeans

OET Generation:
---------------

- Point to CompositionTemplate.xsd
- Use menu WebServices->Generate java code... using XMLBeans

The classes are generated in package: openEHR.v1.template

OPT Generation:
---------------

- Point to Template.xsd
- Use menu WebServices->Generate java code... using XMLBeans

The classes are generated in package: org.openehr.schemas.v1