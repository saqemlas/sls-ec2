#!/usr/bin/env bash
set -Eeuxo pipefail

while :; do
  case "${1:-}" in
  --region)
    export AWS_REGION=${2}
    shift
    ;;
  --bucket)
    export BUCKET_NAME=${2}
    shift
    ;;
  *) break ;;
  esac
  shift
done

die() {
  echo "$*" 1>&2
  exit 1
}

[[ -z "${AWS_REGION-}" ]] && die "region name is required"
[[ -z "${BUCKET_NAME-}" ]] && die "bucket name is required"

# Stop aws cli output
export AWS_PAGER=""

# Check if bucket exists
if [[ -z $(aws s3api head-bucket --bucket $BUCKET_NAME 2>&1 || true) ]]; then
  echo "$BUCKET_NAME already exists! Skipping create bucket..."
else 
  echo "Creating $BUCKET_NAME bucket..."
  
  # Create S3 bucket
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$AWS_REGION" \
    --create-bucket-configuration LocationConstraint="$AWS_REGION" \
    --acl private
  
  # Update S3 bucket access policy
  aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
fi
