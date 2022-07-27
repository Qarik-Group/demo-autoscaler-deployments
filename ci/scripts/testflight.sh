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

header "Testing addons..."
genesis do dev list