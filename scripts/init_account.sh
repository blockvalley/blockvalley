#!/bin/sh
#
# Initializes a geth node's docker volume with the given account private key
# and password
#
# Given a docker volume that will be used as the geth data dir for a
# geth node, initializes the data dir importing the given account using its
# private key and a password to protect it.
#

# Gather params
source "$(dirname "$0")/params.rc"

# Arguments
volume="$1"
privkey_file="$2"
password_file="$3"

# Checks
# # Mandatory arguments
if [ "$volume" == "" ] || [ "$privkey_file" == "" ] || [ "$password_file" == "" ]; then
	echo "Usage:"
	echo "$0 <volume> <privkey_file> <password_file>"
	echo
	echo TL\;DR: runs \"geth account import --password \<password_file\>\
 \<privkey_file\>\" and writes the result in the specified docker volume | \
 fold -s
	echo
	echo Initializes the docker volume specified, filling the keystore \
directory with the import account | fold -s
	echo
	echo If the volume specified does not exist yet, will create a new one \
and import the account there | fold -s
	exit 1
fi

# # Private key file exists
if ! [ -f "$privkey_file" ]; then
	echo "Private key file \"$privkey_file\" does not exist."
	exit 1
fi
# # Password file exists
if ! [ -f "$password_file" ]; then
	echo "Password file \"$password_file\" does not exist."
	exit 1
fi

# Derivated arguments
privkey_filename=$(basename "$privkey_file")
password_filename=$(basename "$password_file")

# # Same filename
if [ "$privkey_filename" == "$password_filename" ]; then
	echo "Password and private key files must have different file names"
	exit 1
fi

# Run container to `geth account import` in it :P
container_id=$(docker run -dit \
	--mount type=volume,source=$volume,destination=$ETH_DATA_DIR \
	--entrypoint="/bin/sh" "$DOCKER_IMAGE_GETH"
)
[ $? -ne 0 ] && echo "Unable to run docker container" && exit 1

# # Container functions
function clean {
	docker rm -f "$container_id" &> /dev/null
}

function run {
	docker exec "$container_id" "$@"
}

function copy {
	docker cp "$1" $container_id:/root
	[ $? -ne 0 ] && clean && echo "Unable to copy \"$1\" to container" &&
exit 1
}

# Copy account private key into container
copy "$privkey_file"
copy "$password_file"

# Execute geth import
docker exec "$container_id" \
	geth account import --password "/root/$password_filename" \
	"/root/$privkey_filename"

# Check execution
if [ $? -eq 0 ]; then
	echo Initialized volume with \"$privkey_file\" and \"$password_file\" in \
keystore directory | fold -s
	clean
	exit 0
else
	echo Unable to initialize keystore with the account | fold -s
	clean
	exit 1
fi
