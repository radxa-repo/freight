# vim: et:ts=4:sw=4:ft=sh

TOPDIR=$PWD
FIXTURES=${TOPDIR}/test/fixtures
TMPDIR=${TOPDIR}/test/tmp

load ${TMPDIR}/bats-assert/all.bash

FREIGHT_HOME=${TMPDIR}/freight
FREIGHT_CONFIG=${FREIGHT_HOME}/etc/freight.conf
FREIGHT_CACHE=${FREIGHT_HOME}/var/cache
FREIGHT_LIB=${FREIGHT_HOME}/var/lib
FREIGHT_POOL=${FREIGHT_HOME}/var/pool

export GNUPGHOME=${TMPDIR}/gpg

freight_init() {
    if [ "$FREIGHT_TEST_VARPOOL" = "1" ]; then
        TEST_VARPOOL=--pooldir=$FREIGHT_POOL
    fi

    gpg_init
    rm -rf $FREIGHT_HOME
    mkdir -p $FREIGHT_CACHE $FREIGHT_LIB
    bin/freight init \
        -g freight@example.com \
        -c $FREIGHT_CONFIG \
        --libdir $FREIGHT_LIB \
        --cachedir $FREIGHT_CACHE \
        --archs "i386 amd64" \
        $TEST_VARPOOL \
        "$@"
}

freight_add() {
    bin/freight add -c $FREIGHT_CONFIG "$@"
}

freight_cache() {
    bin/freight cache -p "$FIXTURES"/passphrase -c $FREIGHT_CONFIG "$@"
}

freight_cache_nohup() {
    nohup bin/freight cache  -p "$FIXTURES"/passphrase -c $FREIGHT_CONFIG "$@"
}

# Generates a GPG key for all tests, once only due to entropy required
gpg_init() {
    if [ ! -e $GNUPGHOME ]; then
        mkdir -p $GNUPGHOME
        chmod 0700 $GNUPGHOME
        gpg --batch --yes --passphrase-fd 0 --import "$FIXTURES"/first_key.gpg < "$FIXTURES"/passphrase
        gpg --batch --yes --passphrase-fd 0 --import "$FIXTURES"/second_key.gpg < "$FIXTURES"/passphrase
    fi
}
