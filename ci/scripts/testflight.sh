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

header "Listing addons..."
genesis do $BOSH_DIRECTOR list

header "Testing addons..."
genesis do $BOSH_DIRECTOR -- setup-cf-plugin -f
genesis do $BOSH_DIRECTOR -- bind-autoscaler
