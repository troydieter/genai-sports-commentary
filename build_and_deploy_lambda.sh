#!/bin/bash
set -e
cd lambda 
rm -rf kinesis-stream-processor.zip packages
#pip install --target ./packages dependencies/botocore-1.29.162-py3-none-any.whl dependencies/boto3-1.26.162-py3-none-any.whl 
pip install --target ./packages  urllib3==1.26.15 boto3
cd packages && zip -r ../kinesis-stream-processor.zip . 
cd .. && zip kinesis-stream-processor.zip lambda_function.py 
# aws lambda update-function-code --function-name bedrock-play-by-play-commentary-processor --zip-file fileb://kinesis-stream-processor.zip
aws iam create-role --role-name GenAILambdaExecutionRole --assume-role-policy-document file://../trust-policy.json
aws iam attach-role-policy --role-name GenAILambdaExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws lambda create-function --function-name bedrock-play-by-play-commentary-processor --role "arn:aws:iam::XXX:role/GenAILambdaExecutionRole" --runtime "python3.9" --handler "lambda_function" --zip-file fileb://kinesis-stream-processor.zip
rm -rf kinesis-stream-processor.zip
