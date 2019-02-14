# EtherCIS MKII Roadmap

Below is the EtherCIS MKII development roadmap following the successful EtherCIS camp in December 2018.   
If you would like to contribute to these open source efforts, please get in touch at either  
https://gitter.im/Ripple-Foundation or info@ripple.foundation
  
##  Release 2.0.0   



| **Summary**                                                                 | **Issue key** | **Priority** | **Component/s** |  
|:----------------------------------------------------------------------------------------|:---------------|:----------|:---------------|        
| Agree coding practices / design patterns                                     | ETH-45        | Medium   | General                      | 
| Cucumber - test data sets                                                    | ETH-4         | High     | CI - Automated testing       | 
| Cucumber: Define test scenarios                                              | ETH-44        | Medium   | CI - Automated testing       | 
| Cucumber - AQL queries                                                       | ETH-6         | Medium   | CI - Automated testing       | 
| Cucumber - templates                                                         | ETH-5         | Medium   | CI - Automated testing       | 
| Cucumber - Test scripts                                                      | ETH-3         | Medium   | CI - Automated testing       | 
| Agree EtherCIS2 Git repo / CI environment                                    | ETH-46        | Medium   | CI - Tooling                 | 
| services.properties                                                          | ETH-2         | Medium   | CI - Tooling                 | 
| Initial code base refactor (ins Spring/Maven)                                | ETH-1         | Medium   | Software frameworks          | 
| Agree coding practices / design patterns                                     | ETH-45        | Medium   | General                      | 
___
##  Release 2.1.0

| **Summary**                                                                  | **Issue key** | **Priority** | **Component/s**| 
|:------------------------------------------------------------------------------|:---------------|:----------|:---------------|
| Conformance to openEHR standard                                              | ETH-22    | Medium   | Core - AQL                       | 
| Check support for non-primitive object return e.g. whole Entry as AQL result | ETH-21    | Medium   | Core - AQL                       | 
| Check java-libs merge history                                                | ETH-20    | Medium   | Core - RM Library                | 
| BMMs/XSDs/JSON schema (openEHR)                                              | ETH-19    | Medium   | Core - RM Library                | 
| Check XSDs, ?JSON schema to 1.0.4                                            | ETH-18    | Medium   | Core - RM Library                | 
| Upgrade Java_libs 2 RM to latest RM                                          | ETH-17    | Medium   | Core - RM Library                | 
| Implement folder structure - Java_libs 2 openEHR                             | ETH-16    | Medium   | Core - RM Library                | 
| Early showcase for onboarding new participants                               | ETH-23    | Medium   | DevOps                           | 
| Document User guide                                                          | ETH-8     | Medium   | Documentation                    | 
| Document Admin guide                                                         | ETH-7     | Medium   | Documentation                    | 
| Fix gaps between latest Marand spec and EtherCIS implementation              | ETH-12    | Medium   | Services - API Development       | 
| EhrScape API development fixes                                               | ETH-11    | Medium   | Services - API Development       | 
| openEHR REST API - JSON                                                      | ETH-10    | Medium   | Services - API Development       | 
| openEHR REST API  - XML                                                      | ETH-9     | Medium   | Services - API Development       | 
| Auth Basic auth                                                              | ETH-15    | Medium   | Services - Authentication        | 
| Springify SHIO                                                               | ETH-14    | Medium   | Services - Authentication        | 

___
##  Release 2.2.0

| **Summary**                                                                  | **Issue key** | **Priority** | **Component/s**|
|:------------------------------------------------------------------------------|:---------------|:----------|:---------------| 
| Support for post-commit event processing with JavaScript                     | ETH-35    | Medium   | Core - AQL                       | 
| Support for server side querying                                             | ETH-34    | Medium   | Core - AQL                       | 
| AQL optimisation for population querying                                     | ETH-33    | Medium   | Core - AQL                       | 
| AQL support for subsumption testing                                          | ETH-29    | Medium   | Core - AQL                       | 
| AQL optimisation of DB communication, server-side processing                 | ETH-25    | Medium   | Core - AQL                       | 
| Postgres: Code cleanup and removal of hacks from Postgres 9.4                | ETH-31    | Medium   | Core - Database                  | 
| Postgres: move to v12 to get SQL 2016 and native JSON                        | ETH-30    | Medium   | Core - Database                  | 
| Attestation support                                                          | ETH-24    | Medium   | Core - Database                  | 
| Terminology service - / FHIR API                                             | ETH-28    | Medium   | Services - API Development       | 
| Fluent API /Builder Pattern/Composition builder - code generator             | ETH-26    | Medium   | Services - API Development       | 
| Implementation of IHE XDS middleware                                         | ETH-32    | Medium   | Services - IHE                   | 
| ATNA system log                                                              | ETH-27    | Medium   | Services - IHE                   | 
___

##  Release 2.3.0


| **Summary**                                                                  | **Issue key** | **Priority** | **Component/s**      |
|:------------------------------------------------------------------------------|:-----------------|:----------|:---------------|
| QEWD Jumper - data transformer for UI & API (utility)                        | ETH-39    | Medium   | Components - data transformation | 
| Oracle support - new AQL processor; JSONB question; separate component       | ETH-37    | Medium   | Core - AQL                       | 
|  Data migration and export data                                              | ETH-43    | Medium   | Core - Database                  | 
| Simplify install process                                                     | ETH-41    | Medium   | DevOps                           | 
| EtherCIS + Postgres docker image; other docker images                        | ETH-38    | Medium   | DevOps                           | 
| Security and monitoring - Deployment strategy                                | ETH-42    | Medium   | Documentation                    | 
| Fix documentation of EtherCIS EhrScape implementation                        | ETH-13    | Medium   | Documentation                    | 
| Consent management service                                                   | ETH-40    | Medium   | Services - Consent               | 
| Demographics service                                                         | ETH-36    | Medium   | Services - Demographic           | 
