# PDF_tables_to_SF
This repo has the step-by-step instructions on loading tables in PDF files to Snowflake as database tables.

## Steps for configuring an external function
Here are the steps for setting up a Snowflake external function with AWS Lambda and API Gateway:

1. Create Lambda Function in AWS:

Define the function that will process the requests from Snowflake.
2. Configure API Gateway:

Create a new REST API.
Set up a resource and method to forward requests to the Lambda function.
Enable CORS (optional) for cross-origin resource sharing.
Deploy the API.
3. Retrieve API Gateway and Lambda Information:

Get the API Gateway's URL endpoint and Lambda function ARN (Amazon Resource Name).
4. Create API Integration in Snowflake:

Use CREATE API INTEGRATION to create the API integration in Snowflake, linking to the API Gateway.
Grant Snowflake access by setting up an IAM policy in AWS for the integration.
5. Create External Function in Snowflake:

Use CREATE EXTERNAL FUNCTION to define the function and link it to the API integration created earlier.
6. Test the Function:

Invoke the external function in Snowflake to ensure it works as expected.
These are the essential steps to integrate Snowflake external functions with AWS Lambda via API Gateway.
