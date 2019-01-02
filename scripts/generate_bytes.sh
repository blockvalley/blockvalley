#!/bin/sh
#
# Generates n random bytes and shows the result as an hexadecimal string
#
# By default uses O.S. /dev/urandom as source of entropy and 32 bytes length
# (64 hexadecimal characters string).
#
# Usage: [RANDOMNESS=/dev/urandom] ./generate_bytes.sh [length]
#
# Source: https://stackoverflow.com/a/34329057
#

# Constants
DEFAULT_LENGTH=32

# Environment variables
[ -z "$RANDOMNESS" ] && RANDOMNESS="/dev/urandom"

# Arguments
[ -z "$1" ] && length="$DEFAULT_LENGTH" || length="$1"

# Generate random bytes as hexadecimal
hexdump -n "$length" -e '"%08x"' "$RANDOMNESS"
