#!/bin/bash -l

set -e

# Check required environment variables
if [ -z ${INPUT_DT_RESULTS_API_KEY} ]; then
  echo "Missing input: DT_RESULTS_API_KEY"
  exit 1
elif [[ ${INPUT_DT_RESULTS_API_KEY} =~ APIKey* ]]; then
  echo "Variable dt_upload_api_key should not start with 'APIKey'"
  exit 1
fi

if [ -z "${INPUT_ASSET_ID}" ]; then
  echo "Missing input: INPUT_ASSET_ID"
  exit 1
fi

if [ -z "${INPUT_ASSET_BASE_URL}" ]; then
  echo "Missing input: INPUT_ASSET_BASE_URL"
  exit 1
fi

generate_payload()
{
  cat <<EOF
{
  "asset_id": "${INPUT_ASSET_ID}",
  "asset_base_url": "${INPUT_ASSET_BASE_URL}",
  "restful_api_scan_config": {
    "should_perform_pii_analysis": $INPUT_SHOULD_PERFORM_PII_ANALYSIS,
    "should_perform_sql_injection_scan": $INPUT_SHOULD_PERFORM_SQL_INJECTION_SCAN
  }
}
EOF
}

# Send a scan request
response=$(
  curl -s -w "%{http_code}" -X POST -H "Authorization: APIKey ${INPUT_DT_RESULTS_API_KEY}" \
  -H "Accept: application/json" -H "Content-Type:application/json" \
  --data "$(generate_payload)" https://api.securetheorem.com/apis/devops/v1/asset_scans/restful_api_scans \
  )
http_code=${response: -3}
response_body=${response::-3}

# Check that http status code is 201
[ ! ${http_code} -eq 201 ] && echo ${http_code} && echo ${response_body} && exit 1

echo $response_body


