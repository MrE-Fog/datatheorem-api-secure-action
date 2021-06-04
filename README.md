# Data Theorem API Secure Github Action

Data Theorem's API Secure will scan your RESTful APIs for security issues, 
including SQL injection and potential leaks of personally identifiable information.

More information can be found here:  
https://www.datatheorem.com/products/api-secure

Enabling this integration requires a valid Data Theorem API key.

## Set your Data Theorem API key as a secret
To find your Data Theorem API key, connect to https://www.securetheorem.com/mobile/sdlc/results_api_access using your Data Theorem account.  
Create an encrypted variable named `DT_RESULTS_API_KEY` in your Github repository.

For more information, see [Github Encrypted secrets](https://docs.github.com/en/actions/reference/encrypted-secrets).

## Find your RESTful API's ID
Go to your [API Secure inventory]((https://securetheorem.com/api/inventory)) in the Data Theorem portal find 
the RESTful API you wish to scan.

Retrieve the RESTful API’s ID from the url of the RESTful API’s page that looks like:  
`https://securetheorem.com/api/restful-apis/<asset_id>`


## Optional scan configuration
Optionally, the following scan configuration settings can be specified:

`should_perform_pii_analysis: <true/false>`  
If set to true, the API responses received by the scanner will be analyzed for personally identifiable information.

`should_perform_sql_injection_scan: <true/false>`    
If set to true, the API’s parameters will be scanned for SQL injection issues.  
This type of scan requires sending a lot of requests to the API,
it will significantly increase the load on the API, and could potentially disrupt it.


## Sample usage

```yaml
name: Request a Data Theorem API Secure asset scan

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    name: deploy and test API
    runs-on: ubuntu-20.04
    steps:
      - name: Request Data Theorem API Secure scan
        uses: datatheorem/data-theorem-api-secure-action@v1.0.0
        with:
          dt_results_api_key: ${{ secrets.DT_RESULTS_API_KEY }}
          asset_id: "15255982-380f-4dae-8fed-b06fc6a82566"
          asset_base_url: "https://<asset_base_url>/"
          # Optional scan configuration
          should_perform_pii_analysis: false
          should_perform_sql_injection_scan: false
```
