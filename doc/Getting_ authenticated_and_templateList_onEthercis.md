Getting connected to the CDR

In this section we will just ensure that we can connect to an openEHR CDR, retreive a session token, and run a simple call to retrieve a list of the loaded templates, to check that we are all setup correctly.

## A. General setup

We now need access to an openEHR CDR, Ethercis with the following information...

1. baseUrl of the CDR
2. Username and Password of the CDR (Ethercis) 



Before you can interact with the CDR you need to authorise the connection. 

#### Ripple Ethercis

Ethercis uses 'session tokens'. 
First, we must make a single `POST /session` call (using our username and password) to retreive a session token, use that session token as an http header on any subsequent calls to the CDR, then formally `DELETE /session` to invalidate the session token as we close the interaction with the CDR. 
Note that session tokens have an expiry time and in a production system these need to be refreshed.

#### POST  /session example

```javascript
const cdrUrl = 'https://cdr.code4health.org/rest/v1';

const sessiontoken = getSessiontoken(cdrUrl,'myUsername', 'myPassword');

async getSessionToken(cdr,username,password) => {
    const response = await axios.post(`${cdrUrl}/session`, {
        params : {
            username, 	// ES6 enhanced object literal syntax 
            password	// ES6 enhanced object literal syntax	
        }
    });
    return response.data.sessionId; 
}
```

Ethercis expects a Session token to be carried on the http Headers as a custom `Ehr-Session` header ..

`Ehr-Session : {{sessionToken}}`


## B. Listing the openEHR Templates registered with the CDR

We do not actually need to list the openEHR Templates as part of  this project but it is a simple way of checking that our authorisation setup is correct and that we are able to hook up to the CDR

The API Call to list templates is simple - just `GET /template` ...


```javascript
 async getCDRTemplates(cdrUrl, authHeader) {
        const response = await axios.get(`${cdrUrl}/template`,
            {
                headers : authHeader
            });
        return await response.data.templates;
    }    
```

This will return an array of template objects...

```json
{
    "templates": [
        {
            "templateId": "IDCR - Adverse Reaction List.v1",
            "createdOn": "2018-05-18T10:20:07.397Z"
        },
        {
            "templateId": "IDCR - Immunisation summary.v0",
            "createdOn": "2018-05-18T10:20:15.580Z"
        },
        {
            "templateId": "IDCR - Laboratory Order.v0",
            "createdOn": "2018-05-18T10:20:20.838Z"
        },
        {
            "templateId": "IDCR - Laboratory Test Report.v0",
            "createdOn": "2018-05-18T10:20:08.456Z"
        },
        {
            "templateId": "IDCR - Medication Statement List.v0",
            "createdOn": "2018-05-18T10:20:23.650Z"
        }
    ]
}
```
