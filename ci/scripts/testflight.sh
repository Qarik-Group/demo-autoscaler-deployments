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

header "Testing addons..."
genesis do $BOSH_DIRECTOR -- setup-cf-plugin -f
genesis do $BOSH_DIRECTOR -- bind-autoscaler

header "Cleaning up for future deployments ..."
cf delete-service-broker autoscaler -f