FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://journald.conf \
    file://wlan.network \
    file://98-wifi.link \
"

do_install() {
    install -d ${D}${systemd_unitdir}/network
    install -m 644 ${WORKDIR}/wlan.network ${D}${systemd_unitdir}/network
    install -m 644 ${WORKDIR}/98-wifi.link ${D}${systemd_unitdir}/network
}

FILES:${PN} += "\
    ${systemd_unitdir} \
"
