#!/bin/sh
#
# Generates a random password including special characters
#
# By default uses O.S. /dev/urandom as source of entropy and 16 characters
# length password
#
# Usage: [RANDOMNESS=/dev/urandom] ./generate_password.sh [length]
#
# Source: https://unix.stackexchange.com/a/230676
#

# Constants
DEFAULT_LENGTH=16

# Environment variables
[ -z "$RANDOMNESS" ] && RANDOMNESS="/dev/urandom"

# Arguments
[ -z "$1" ] && length="$DEFAULT_LENGTH" || length="$1"

# Generate password
LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' \
    < "$RANDOMNESS" | head -c "$length"
