# PDF_tables_to_SF
This repo has the step-by-step instructions on loading tables in PDF files to Snowflake as database tables.

## 01) Steps for configuring a Snowflake External Function w/ AWS

Follow these steps to integrate Snowflake with AWS Lambda using API Gateway. For more detailed steps, check out the [Snowflake docs](https://docs.snowflake.com/en/sql-reference/external-functions-creating-aws-ui).

### 1. Create Lambda Function in AWS
Define the Lambda function that will process the requests from Snowflake.

### 2. Configure API Gateway
- Create a new REST API.
- Set up a resource and method to forward requests to the Lambda function.
- Enable CORS (optional) for cross-origin resource sharing.
- Deploy the API.

### 3. Retrieve API Gateway and Lambda Information
- Get the API Gateway URL endpoint.
- Retrieve the Lambda function ARN (Amazon Resource Name).

### 4. Create API Integration in Snowflake
- Use `CREATE API INTEGRATION` in Snowflake to create the API integration linking to the API Gateway.
- Set up an IAM policy in AWS to allow Snowflake access to the Lambda function.

### 5. Create External Function in Snowflake
- Use `CREATE EXTERNAL FUNCTION` to define the external function and link it to the API integration created earlier.
- Here's the [link](snowflake_scripts/01_configure_external_function.sql) to Snowflake script for creating API integration and External function.

### 6. Test the External Function
Invoke the external function in Snowflake to verify it works as expected.

## 02) Setting Up Local Development Environment

Once you've finished setting up your External Function (and verified it to be working), you'll need to work on your lambda_function.py to add code that actually extract tables from PDF files and send them to Snowflake.

Prerequisites: 
- IDE (VS Code is recommended)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [AWS CLI](https://aws.amazon.com/cli/)

Below are the steps to build and push your Docker Image to Amazon ECR.

### 1. Build the Docker image locally
```bash
   docker build -t pdf_tbl_extract .
```
### 2. Authenticate Docker with Amazon ECR
```bash
   aws ecr get-login-password --region <YOUR_AWS_REGION> | docker login --username AWS --password-stdin <YOUR_AWS_ACCOUNT_NUMBER>.dkr.ecr.<YOUR_AWS_REGION>.amazonaws.com
```
### 3. Tag the Docker image before pushing to ECR
```bash
   docker tag pdf_tbl_extract:latest <YOUR_AWS_ACCOUNT_NUMBER>.dkr.ecr.<YOUR_AWS_REGION>.amazonaws.com/repo_for_pdf_tbl_extract:<YOUR_IMAGE_TAG>
```
### 4. Push the Docker image to ECR
```bash
   docker push <YOUR_AWS_ACCOUNT_NUMBER>.dkr.ecr.<YOUR_AWS_REGION>.amazonaws.com/repo_for_pdf_tbl_extract:<YOUR_IMAGE_TAG>
```
