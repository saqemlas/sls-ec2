#!/usr/bin/env bash

# Stop aws cli output
export AWS_PAGER=""

Service="ingest-server"

export PUBLIC_IP=$(/usr/local/bin/aws ec2 describe-instances --filters "Name=tag:Service,Values=$Service" --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

PORT=80

echo "Copy and paste \"http://$PUBLIC_IP:$PORT\" into browser"
