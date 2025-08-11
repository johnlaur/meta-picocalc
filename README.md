# meta-picocalc-luckfox

This is a **Yocto Project** meta-layer for building a Linux image for the **ClockworkPi PicoCalc** running on the **Luckfox Lyra** board.
The layer uses **[KAS](https://kas.readthedocs.io/)** for configuration management and reproducible builds, and includes **RAUC** support for over-the-air (OTA) updates using a **dual rootfs** setup.

---

## Features
- Pre-configured for the Clockwork PicoCalc hardware. The system runs read-only on the internal MMC with an Overlay-FS on the external SD-Card.
- Luckfox Lyra board support.
- KAS-based build setup for reproducible builds.
- **RAUC** OTA update support with dual root filesystem (A/B).
- Ready-to-use shell environment entry after build.
- Extensible - In the future additional boards can be supported.

---

## Prerequisites

Make sure you have the following installed on your build host:

- Docker

---

## Build Instructions

1. **Clone this repository**:
   ```bash
   mkdir picocalc-buildsystem && cd picocalc-buildsystem
   git clone https://github.com/0xd61/meta-picocalc.git
   ```

2. **Run the build with KAS**:
   ```bash
   ./meta-picocalc/kas-container --ssh-dir ~/.ssh build --update meta-picocalc/kas-luckfox-lyra-bundle.yaml
   ```

   This will:
   - Download the Yocto sources.
   - Apply the configurations for the PicoCalc with the Luckfox Lyra.
   - Build the image.

3. **Find the output image**
   After the build completes, the image (picocalc-image-luckfox-lyra.rootfs.wic) will be located in:
   ```
   build/tmp/deploy/images/luckfox-lyra/
   ```

4. **Install**
   Install the image with dd on a Micro-SD card.
   ```
   dd if=build/tmp/deploy/images/luckfox-lyra/picocalc-image-luckfox-lyra.rootfs.wic of=/dev/mmcblk0 bs=4M
   ```

   Create a ext4 partition on the external Picocalc SD-Card which will be mounted at `/data` on the system.

---

## Getting a Shell Environment

To drop into the Yocto build shell environment (for custom builds, debugging, or running `bitbake` commands manually):

```bash
./meta-picocalc/kas-container --ssh-dir ~/.ssh shell meta-picocalc/kas-luckfox-lyra-bundle.yaml
```

Inside this shell, you can run commands like:
```bash
bitbake virtual/kernel
```

---

## OTA Updates with RAUC

This meta-layer configures **RAUC** for robust **A/B dual rootfs** OTA updates.
The device has two root partitions (`rootfsA` and `rootfsB`). During an update:
1. RAUC installs the new system image to the inactive rootfs.
2. The bootloader is updated to boot from the new rootfs.
3. If the new system boots successfully, it is marked as “good”; otherwise, the system falls back to the previous version.

The system uses a dual-rootfs for proper rollbacks if a update failed. Updates can be installed with rauc.
Copy the `.raucb` file onto the SD-Card and install it with:
```
rauc install picocalc-bundle-luckfox-lyra.raucb
reboot
```

RAUC will automatically boot into the updated rootfs. If the boot fails, the device will revert to the previous rootfs.

More on RAUC: https://rauc.readthedocs.io/

---

## References
- [Yocto Project Documentation](https://docs.yoctoproject.org/)
- [KAS Documentation](https://kas.readthedocs.io/)
- [RAUC Documentation](https://rauc.readthedocs.io/)
- [Luckfox Lyra Documentation](https://wiki.luckfox.com/Luckfox-Lyra/)


## Acknowledgements
Special thanks to [hisptoot](https://github.com/hisptoot/picocalc_luckfox_lyra/)
for providing the kernel drivers for keyboard, display, and audio support.
