#!/bin/sh

#
# Initializes a geth node's docker volume given the "genesis.json" file
#
# Given a docker volume that will be used as the "geth" data dir for a
# geth node, initializes the data dir with the genesis block generated
# using the genesis JSON file.
#
# This means, filling the "geth" directory of the volume with the genesis 
# block generated based on the genesis JSON file.
#

# Gather params
source "$(dirname "$0")/params.rc"

# Constants
# # Apply defaults
[ "$NETWORK" == "" ] && NETWORK="$NETWORK_DEFAULT"
[ "$GENESIS_FILENAME" == "" ] && GENESIS_FILENAME="$GENESIS_FILENAME_DEFAULT"

# Arguments
volume="$1"
genesis_file="$CONFIG_DIR/$NETWORK/$GENESIS_FILENAME"

# Checks
# # Mandatory arguments
if [ "$volume" == "" ]; then
	echo "Usage:"
	echo \[NETWORK=\"$NETWORK_DEFAULT\"\]\
[GENESIS_FILENAME=\"$GENESIS_FILENAME_DEFAULT\"] "$0" \<volume\> | fold -s
	echo
	echo TL\;DR: runs \"geth init\" with the specified \
genesis file and writes the result in the specified docker volume | fold -s
	echo
	echo The genesis file will be automatically chosen given the network, \
configuration directory and genesis filename
	echo
	echo By default, will use then \"$genesis_file\" | fold -s
	echo
	echo Initializes the docker volume specified, filling the geth folder \
with the chain data using the genesis JSON file, so that a node can start \
syncing a blockchain. | fold -s
	echo
	echo If the geth folder already contains data, aborts as it would \
overwrite some data \(the first blocks\) | fold -s
	echo
	echo If the volume specified does not exist yet, will create a new one \
and initialize it | fold -s
	exit 1
fi

# # Genesis file exists
if ! [ -f "$genesis_file" ]; then
	echo "Genesis file \"$genesis_file\" does not exist."
	exit 1
fi

# Run container to `geth init` in it :P
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

# "geth" directory
# # Create geth directory if does not exist
if ! run sh -c "[ -d \"$ETH_DATA_DIR/geth\" ]"; then
 	echo "Creating volume datadir's geth directory"
 	run mkdir "$ETH_DATA_DIR/geth"
 	if [ $? -ne 0 ]; then
 		echo "Unable to create geth directory in volume"
		clean
 		exit 1
 	fi

# # Not empty "geth" directory
elif [ "$(run sh -c "ls -A \"$ETH_DATA_DIR/geth\"")" ]; then
 	echo "Volume's geth directory is not empty. Aborting."
 	echo "Make sure the volume has not been init yet"
	clean
 	exit 1
fi

# Copy genesis.json into container
docker cp "$genesis_file" $container_id:/root
[ $? -ne 0 ] && clean && echo "Unable to copy genesis to container" && exit 1

# Execute geth init
docker exec "$container_id" geth init "/root/$GENESIS_FILENAME"

# Check execution
if [ $? -eq 0 ]; then
	echo "Initialized volume with $genesis_file in geth directory"
	clean
	exit 0
else
	echo "Unable to initialize geth"
	clean
	exit 1
fi
