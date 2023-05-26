#!/usr/bin/env bash
set -Eeuxo pipefail

while :; do
  case "${1:-}" in
  --path)
    export PATH=${2}
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

[[ -z "${PATH-}" ]] && die "path to private ssh key is required"

# Stop aws cli output
export AWS_PAGER=""

Service="ingest-server"

export PUBLIC_DNS=$(/usr/local/bin/aws ec2 describe-instances --filters "Name=tag:Service,Values=$Service" --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].PublicDnsName' --output text)

echo "Run \"ssh -i $PATH ec2-user@$PUBLIC_DNS\""
