# shellcheck disable=SC1090,SC1091
# Freight configuration.

# Default directories for the Freight library and Freight cache.  Your
# web server's document root should be `$VARCACHE`.
VARLIB="/var/lib/freight"
VARCACHE="/var/cache/freight"

# If the file system does not support hard link, you can use symbolic
# link instead. In this mode file will be copied to VARPOOL first, then
# symlinked to VARLIB and finally VARCACHE. Implies SYMLINKS="on".
VARPOOL=""

# Default architectures.
# shellcheck disable=SC2034
ARCHS="i386 amd64"

# Default `Origin`, `Label`, 'NotAutomatic`, and
# `ButAutomaticUpgrades` fields for `Release` files.
# shellcheck disable=SC2034
ORIGIN="Freight"
# shellcheck disable=SC2034
LABEL="Freight"
# shellcheck disable=SC2034
NOT_AUTOMATIC="no"
# shellcheck disable=SC2034
BUT_AUTOMATIC_UPGRADES="no"

# shellcheck disable=SC2034
CACHE="off"

# shellcheck disable=SC2034
SYMLINKS="off"

# Source all existing configuration files from lowest- to highest-priority.
PREFIX="$(dirname "$(dirname "$0")")"
if [ "$PREFIX" = "/usr" ]; then
    [ -f "/etc/freight.conf" ] && . "/etc/freight.conf"
else
    [ -f "$PREFIX/etc/freight.conf" ] && . "$PREFIX/etc/freight.conf"
fi
[ -f "$HOME/.freight.conf" ] && . "$HOME/.freight.conf"
DIRNAME="$PWD"
while true; do
    [ -f "$DIRNAME/etc/freight.conf" ] && . "$DIRNAME/etc/freight.conf" && break
    [ -f "$DIRNAME/.freight.conf" ] && . "$DIRNAME/.freight.conf" && break
    [ "$DIRNAME" = "/" ] && break
    DIRNAME="$(dirname "$DIRNAME")"
done
[ "$FREIGHT_CONF" ] && [ -f "$FREIGHT_CONF" ] && . "$FREIGHT_CONF"
if [ "$CONF" ]; then
    if [ -f "$CONF" ]; then
        . "$CONF"
    else
        echo "# [freight] $CONF does not exist" >&2
        exit 1
    fi
fi

# Normalize directory names.
VARLIB=${VARLIB%%/}
VARCACHE=${VARCACHE%%/}
VARPOOL=${VARPOOL%%/}

# Override options
if [ -n "$VARPOOL" ]; then
    # shellcheck disable=SC2034
    LINK_OPTION="-rsL"
    # shellcheck disable=SC2034
    SYMLINKS="on"
else
    # For some reasons ln will not work if argv[1] == "" in tests
    # shellcheck disable=SC2034
    LINK_OPTION="--"
fi

# vim: et:ts=4:sw=4
