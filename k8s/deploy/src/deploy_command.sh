script_dir=$(readlink -f $(dirname $0))

$script_dir/../aws/s3.sh create

source $script_dir/../aws/secret-manager.sh read bash2js --source-only

app_helm_values=$(mktemp)

envsubst < $script_dir/../simple-app-helm/values.yaml > $app_helm_values

helm install -f $app_helm_values -n bash2jsdemo --create-namespace bash2js-demo $script_dir/../simple-app-helm