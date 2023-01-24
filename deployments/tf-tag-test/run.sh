#!/bin/bash

if [ -z $1 ]; then
	echo
	echo "Usage:"
	echo "  $0 region_name"
	echo
	echo "Environment variables:"
	echo "  TF_ENV: prod, qa, cicd, perf, sec, prodeng"
	echo "  AWS_DEFAULT_REGION: us-west-2 (default), eu-west-1, ca-central-1"
	echo

	exit 1
else
	REGION_NAME=$1
fi

if [ -z $TF_ENV ]; then
	TF_ENV="perf"
fi

if [ -z $AWS_DEFAULT_REGION ]; then
	AWS_DEFAULT_REGION="us-west-2"
fi

if [ "$TF_ENV" = "dr" ]; then
	# Special case: DR uses prod TF backend
	BACKEND_BUCKET_ENV="prod"
	BACKEND_REGION_NAME="dr-${REGION_NAME}"
else
	BACKEND_BUCKET_ENV="$TF_ENV"
	BACKEND_REGION_NAME="${REGION_NAME}"
fi

set -x
terraform init \
  -backend-config="bucket=ai-${BACKEND_BUCKET_ENV}-terraform-state" \
  -backend-config="region=us-west-2" \
  -backend-config="key=$(basename $(pwd))/${BACKEND_REGION_NAME}" \
  -backend-config "encrypt=true"
set +x

if [ $? -ne 0 ]; then
  echo "An error occured while initializing tf stack"
  exit 1
fi

echo
echo "Planning stack"
echo
mkdir -p .tf_plans
echo
terraform plan -var "aws_region=$AWS_DEFAULT_REGION" -var "aws_region=$REGION_NAME" -var-file="env/${TF_ENV}/${TF_ENV}.tfvars" --out="./.tf_plans/${TF_ENV}.out" && \
terraform show -json "./.tf_plans/${TF_ENV}.out" >  ./.tf_plans/${TF_ENV}.json && \
rm ./.tf_plans/${TF_ENV}.out && git add ./.tf_plans/${TF_ENV}.json

if [ $? -ne 0 ]; then
  echo "An error occured while planning tf stack"
  exit 1
fi

echo
echo "Run below command to apply stack"
echo
echo terraform apply -var "aws_region=$AWS_DEFAULT_REGION" -var "aws_region=$REGION_NAME" -var-file="env/${TF_ENV}.tfvars" -var-file="env/${TF_ENV}/${REGION_NAME}.tfvars"
echo
