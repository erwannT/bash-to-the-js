#!/usr/bin/env bash

set -e

PROGRAM_NAME=$0

function usage() {
  cat <<EOF
example:
# Create bash-to-js bucket
./s3.sh create

# Delete bash-to-js bucket
./s3.sh delete

usage: $PROGRAM_NAME {create | delete}

Delete env buckets
  -v | --verbose             Verbose, activate debug mode in current shell
  -h | --help                Print this usage
EOF
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
  -h | --help) usage && exit ;;
  -v | --verbose)
    set -x
    ;;
  -*)
    echo "unknown option: $1" >&2
    exit 1
    ;;
  *) break ;;
  esac
  shift
done

# Retrieve arguments
ACTION=$1

# Check arguments
[[ -z ${ACTION} ]] && echo "missing argument : {create}" && exit 1


function createBucket() {
  echo "Check if bucket bash-to-js exists"
  exist=$(aws s3 ls | grep -icw "bash-to-js" | cat)

  if [[ $exist == 1 ]]; then
    echo "Bucket bash-to-js already exists"
  else
  echo "Create bash-to-js bucket"
    location=$(aws s3api create-bucket --bucket bash-to-js --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1 | jq '.Location')
    echo $location
  fi
}

function deleteBucket() {
  echo "Check if bucket bash-to-js exists"
  exist=$(aws s3 ls | grep -icw "bash-to-js" | cat)

  if [[ $exist == 1 ]]; then
    echo "Delete bash-to-js"
    aws s3 rb "s3://bash-to-js" --force
  else
    echo "bash-to-js bucket does not exist"
    exit 1
  fi
}

case ${ACTION} in
create)
  createBucket
  ;;
delete)
  deleteBucket
  ;;
*)
  usage
  exit 1
  ;;
esac
