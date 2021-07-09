# vim: et:ts=4:sw=4:ft=sh

configure_local_apt() {
    mkdir -p ${TMPDIR}/apt/etc/apt
    mkdir -p ${TMPDIR}/apt/var/lib/apt
    mkdir -p ${TMPDIR}/apt/var/lib/dpkg
    mkdir -p ${TMPDIR}/apt/var/cache/apt

    if [ ! -e "${TMPDIR}"/apt/var/lib/dpkg/status ]; then
        touch "${TMPDIR}"/apt/var/lib/dpkg/status
    fi
    if [ ! -e "$TMPDIR"/apt/etc/apt/trusted.gpg ]; then
        gpg --output "$TMPDIR"/apt/etc/apt/trusted.gpg --export freight@example.com
    fi
}

check_apt_support() {
    type apt-get || skip "missing apt-get"
    apt-get --version | grep Ver:.*deb || skip "missing apt-get deb support"
}
