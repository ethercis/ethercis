Useful Technical Stuff
======================

This is a list of cool stuff used in the current implementation.

- [PostgreSQL](http://www.postgresql.org/): we use version 9.4 and above, in particular for its support of JSON datatypes.
- [jOOQ](http://www.jooq.org/): java object oriented queries. Accesses to the DB are done using this library.
- [Shiro](http://shiro.apache.org/): a flexible access security framework from Apache
- [XmlBeans](https://xmlbeans.apache.org/): obsoleted (well...) but still in use for Canonical XML exchanges
- [Gson](https://code.google.com/p/google-gson/): library for JSON serialization.
- [Jetty](https://eclipse.org/jetty/): supports HTTP/TCP and WebSockets communication layers
- [Spring](http://projects.spring.io/spring-framework/): is used parsimoniously (!) to ease the handling of specific annotations. The overall service management is done by our own implementation.
- [XmlBlaster](http://xmlblaster.org): The service framework is essentially based on this work
- [FST 2.40](https://ruedigermoeller.github.io/fast-serialization/) fast serialization used to perform cloning of tree structure branch with good performance 
- [dom4j](https://dom4j.github.io/) to encode XML response