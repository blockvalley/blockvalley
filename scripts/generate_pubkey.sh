#!/bin/sh
#
# Derivates a public key given the private key in hexadecimal
# Uses geth bootnode to do that
#
# Usage: ./derivate_publickey.sh [private_key]
#
# If no private key is specified, generates the private key too
#

# Gather params
# shellcheck source=params.rc
. "$(dirname "$0")/params.rc"

# Generate new private key if none provided
if [ -z "$1" ]; then
	privkey="$("$SCRIPTS_DIR/generate_bytes.sh")"
	>&2 echo "Generated new private key"
	echo "$privkey"
else
	privkey="$1"
fi

# Get public key
docker run -it --rm --env "BOOTNODE_PRIVKEY=$privkey" \
	"$DOCKER_IMAGE_BOOTNODE" -writeaddress
