#!/bin/sh
#
# Initializes a docker volume to be used as the data directory of a Geth node
# with the given account private key encrypted by the given password
#

# Gather params
# shellcheck source=params.rc
. "$(dirname "$0")/params.rc"

# Arguments
volume="$1"
privkey_file="$2"
password_file="$3"

# Checks
# # Mandatory arguments
if [ -z "$volume" ] || [ -z "$privkey_file" ] || [ -z "$password_file" ]; then
	>&2 echo "Usage:"
	>&2 echo "$0 <volume> <privkey_file> <password_file>"
	>&2 echo
	>&2 echo TL\;DR: runs \"geth account import --password \<password_file\>\
 \<privkey_file\>\" and writes the result in the specified docker volume | \
 fold -s
	>&2 echo
	>&2 echo Initializes the docker volume specified, filling the keystore \
directory with the import account | fold -s
	>&2 echo
	>&2 echo If the volume specified does not exist yet, will create a new one \
and import the account there | fold -s
	exit 1
fi

# # Private key file exists
if ! [ -f "$privkey_file" ]; then
	>&2 echo "Private key file \"$privkey_file\" does not exist."
	exit 1
fi
# # Password file exists
if ! [ -f "$password_file" ]; then
	>&2 echo "Password file \"$password_file\" does not exist."
	exit 1
fi

# Derivated arguments
privkey_filename=$(basename "$privkey_file")
password_filename=$(basename "$password_file")

# # Same filename
if [ "$privkey_filename" = "$password_filename" ]; then
	>&2 echo "Password and private key files must have different file names"
	exit 1
fi

# Run container to `geth account import` in it
if ! container_id=$(docker run -dit \
	--mount "type=volume,source=$volume,destination=$ETH_DATA_DIR" \
	--entrypoint="/bin/sh" "$DOCKER_IMAGE_GETH"); then
    >&2 echo "Unable to run docker container" && exit 1
fi

# # Container functions
clean() {
    docker rm -f "$container_id" > /dev/null 2>&1
    if [ -n "$tmp_file" ]; then
        rm "$tmp_file" || (>&2 echo Unable to delete temporal file && exit 1)
    fi
}
run() { docker exec "$container_id" "$@"; }
copy() {
    if ! docker cp "$1" "$container_id:/root"; then
        clean && echo >&2 "Unable to copy \"$1\" to container" && exit 1
    fi
}

# Copy account private key and password into container
copy "$privkey_file"
copy "$password_file"

# Execute geth import
# # Log result
if ! tmp_file="$(mktemp)"; then >&2 echo Unable to create tmp file; fi
# # Run
if docker exec "$container_id" \
	geth account import --password "/root/$password_filename" \
	    "/root/$privkey_filename" > "$tmp_file" 2> /dev/null; then
    # Display address
    cut -d'{' -f2 "$tmp_file" | tr -d '}'
	clean
	exit 0
else
	echo Unable to initialize keystore with the account | fold -s
	clean
	exit 1
fi
