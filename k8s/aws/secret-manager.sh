#!/usr/bin/env bash

set -e

PROGRAM_NAME=$0

function usage() {
  cat <<EOF
example:
# Create secret based on json file
$PROGRAM_NAME -f profile-example.json create dev/master/adx-platform-vars

# Export and source secret as env variables
$PROGRAM_NAME read dev/master/adx-platform-vars --source-only

# Export and print command secret as env variables (debug)
$PROGRAM_NAME --verbose read dev/master/adx-platform-vars

# Delete secret
$PROGRAM_NAME delete dev/master/adx-platform-vars

# Check if secret exists
$PROGRAM_NAME exist dev/master/adx-platform-vars

Json file example:
cat profile-example.json
{
  \"AWS_S3_ACCESS_KEY\":\"AKIXXXXXXXXXXXXXXXGHL\",
  \"AWS_S3_SECRET_KEY\":\"XXXXXXX\",
  \"AWS_S3_BUCKETS_DRIVE\":\"xxxxxbucket.augmented-dx\",
  \"AWS_S3_REGION\":\"us-east-1\"
}
usage: $PROGRAM_NAME [--debug-mode] [-f <value>] {read|create|delete} {[secret-id]|[env]}

Create, delete, read secret and export to environment variable
  -v | --verbose             Verbose, activate debug mode in current shell
  -f | --file                    JSON file in order to build secret string
  -h | --help                    Print this usage
EOF
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
  -h | --help) usage && exit ;;
  -f | --file)
    JSON_FILE="$2"
    shift
    ;;
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
[[ -z ${ACTION} ]] && echo "missing argument : {read|create|delete}" && exit 1

SECRET=$2
if [[ -z ${SECRET} ]]
then
  echo "missing argument : secret-id" && exit 1
fi

function export_env() {
  SECRET_STRING=$(aws secretsmanager get-secret-value --secret-id ${SECRET} --query SecretString --output text)
  for s in $(echo $SECRET_STRING | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]"); do
    export $s
  done
}

function exist(){
  set +e
  content=$(aws secretsmanager describe-secret --secret-id ${SECRET} --query SecretString --output text 2>&1)
  exit_code=$?
  set -e
  if [[ "$exit_code" == "254" && "$content" == *"Secrets Manager can't find the specified secret"* ]]
  then
    echo "Secret ${SECRET} not found"
    false
  elif [[ "$exit_code" != "0" ]]
  then
    echo "An error occured during retrieving ${SECRET} secret"
    echo "$content"
    false
  else
    true
  fi
}

function create() {
  [[ -z ${JSON_FILE} ]] && echo "missing required json file : -f | --file}" && exit 1
  secrets=$(envsubst < $JSON_FILE)
  aws secretsmanager create-secret --name ${SECRET} --description "${SECRET} created by script" --secret-string "${secrets}" 
}

function delete() {
  aws secretsmanager delete-secret --secret-id ${SECRET} --force-delete-without-recovery
}

case ${ACTION} in
read)
  export_env
  ;;
create)
  create
  ;;
delete)
  delete
  ;;
exist)
  exist
  ;;
*)
  usage
  exit 1
  ;;
esac
