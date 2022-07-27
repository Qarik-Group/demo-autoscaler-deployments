#!/bin/bash
set -eu

header() {
	echo
	echo "###############################################"
	echo
	echo $*
	echo
}

header "Testing addons..."
genesis do dev-cf-app-autoscaler list