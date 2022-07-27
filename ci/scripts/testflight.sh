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
cd dev-changes
pwd
ls -la

header "Adding required safe targets"
echo "Vault Address used: $VAULT_ADDR"
safe target vault "$VAULT_ADDR" -k
export VAULT_ROLE_ID=$VAULT_ROLE
export VAULT_SECRET_ID=$VAULT_SECRET

header "Testing addons..."
genesis do dev list