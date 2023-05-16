[![Terraform](https://github.com/Andrej988/jowe-api/actions/workflows/terraform.yml/badge.svg)](https://github.com/Andrej988/jowe-api/actions/workflows/terraform.yml)

# JoWe (Journal for Wellness) API

Backend (API) for JoWe (Journal for Wellness) application.
For frontend see: https://github.com/Andrej988/jowe-web

## About
JoWe API is a backend for JoWe application using AWS serverless technologies and terraform (IaC).

API is built using AWS API Gateway and uses the following AWS services:
- Cognito for authentication
- DynamoDB tables for storage of data
- Lambdas for retrieval and manipulation of data in dynamoDB tables
- SNS and SQS for fan-out pattern for deletion of user data (upon account deletion request) to allow having separate lambda per each dynamodb table.

## Background
JoWe application started as a small proof-of-concept project to learn more about AWS serverless and Terraform. As I poses a semi-smart bathroom scale which is able to obtain also other indicators besides weight, I decided to build a small application to track these measurements and progress over time.
