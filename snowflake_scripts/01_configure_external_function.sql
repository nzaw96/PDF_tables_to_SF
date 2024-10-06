use role training_role;
use database nay_db;
use schema nay_schema;

CREATE OR REPLACE API INTEGRATION sf_aws_api_integration
  api_provider = aws_api_gateway
  api_aws_role_arn = '<YOUR_AWS_ROLE_ARN>'
  api_allowed_prefixes = ('<YOUR_RESOURCE_INVOCATION_URL_IN_API_GATEWAY>')
  enabled = true;

describe integration sf_aws_api_integration;

--API integration created successfully.
--Finally creating the external function itself

CREATE EXTERNAL FUNCTION ext_func_for_pdf_tbl_extract(n INTEGER, v VARCHAR)
    RETURNS VARIANT
    API_INTEGRATION = sf_aws_api_integration
    AS '<YOUR_RESOURCE_INVOCATION_URL_IN_API_GATEWAY>';
--ext func successfully created

--Check if your ext func executes successfully
select ext_func_for_pdf_tbl_extract(0, 'uoforegon_data.pdf');

--OPTIONAL. Last part to parse the json-string output from your ext func into table
set last_q = last_query_id();
select $last_q;
select parse_json($1) from table(result_scan($last_q));
