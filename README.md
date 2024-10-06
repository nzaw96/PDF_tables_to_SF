# PDF_tables_to_SF
This repo has the step-by-step instructions on loading tables in PDF files to Snowflake as database tables.

# Setting Up Snowflake External Function with AWS Lambda and API Gateway

Follow these steps to integrate Snowflake with AWS Lambda using API Gateway.

## 1. Create Lambda Function in AWS
Define the Lambda function that will process the requests from Snowflake.

## 2. Configure API Gateway
- Create a new REST API.
- Set up a resource and method to forward requests to the Lambda function.
- Enable CORS (optional) for cross-origin resource sharing.
- Deploy the API.

## 3. Retrieve API Gateway and Lambda Information
- Get the API Gateway URL endpoint.
- Retrieve the Lambda function ARN (Amazon Resource Name).

## 4. Create API Integration in Snowflake
- Use `CREATE API INTEGRATION` in Snowflake to create the API integration linking to the API Gateway.
- Set up an IAM policy in AWS to allow Snowflake access to the Lambda function.

## 5. Create External Function in Snowflake
- Use `CREATE EXTERNAL FUNCTION` to define the external function and link it to the API integration created earlier.

## 6. Test the External Function
Invoke the external function in Snowflake to verify it works as expected.
