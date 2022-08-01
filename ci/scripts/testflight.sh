#!/bin/bash
set -eu

header() {
	echo
	echo "###############################################"
	echo
	echo $*
	echo
}

header "Changing to dev-changes directory"
cd $GIT_DIRECTORY
pwd
ls -la

header "Adding required safe targets"

safe target vault "$VAULT_ADDR" -k
export VAULT_ROLE_ID=$VAULT_ROLE
export VAULT_SECRET_ID=$VAULT_SECRET

header "Installing cf-targets plugin"
cf install-plugin Targets -f

header "Listing addons..."
genesis do $BOSH_DIRECTOR list

header "Adding required CF targets"
cf api https://$CF_API --skip-ssl-validation
export CF_USERNAME=$CF_USERNAME
export CF_PASSWORD=$CF_PASSWORD
cf auth

header "Testing autoscaler binding..."
genesis do $BOSH_DIRECTOR -- setup-cf-plugin -f

# Identify the presence of autoscaler service broker and either update or bind it
autoscaler_registered=$(cf curl /v2/service_brokers|jq --arg env_name "autoscaler" -r '.resources[].entity | select(.name==$env_name) | .name')
if [[ -n $autoscaler_registered ]] ; then

	describe "Found and updating service broker autoscaler..."
	genesis do $BOSH_DIRECTOR -- update-autoscaler

else

	describe "Creating service broker autoscaler..."
	genesis do $BOSH_DIRECTOR -- bind-autoscaler

# Test overall binding process
genesis do $BOSH_DIRECTOR -- test-bind-autoscaler
