## OpenCore EFI for my desktop

CPU: 9600K

Masterboard: Prime Z390-P

NVME: SamSung 970 EVO

GPU: no external GPU

Display: Dell P2415Q

### BIOS Settings

TODO

下面主要说明，我是怎么构建这个 EFI 的，以及中间遇到的坑。

整个流程是基于 [OpenCore Desktop Guide](https://dortania.github.io/OpenCore-Desktop-Guide/) 来的。

- 先基于 OpenCorePkg 中的 EFI，添加自己的 Drivers，Kexts，以及 ACPI。
- 然后修改 config.plist。
- 不断的重试安装流程。直到可以 boot 进 macos。

```bash
EFI/
├── BOOT
│   └── BOOTx64.efi
└── OC
    ├── ACPI
    │   ├── SSDT-AWAC.aml
    │   ├── SSDT-EC-USBX-DESKTOP.aml
    │   ├── SSDT-PLUG-DRTNIA.aml
    │   └── SSDT-PMC.aml
    ├── Bootstrap
    │   └── Bootstrap.efi
    ├── Drivers
    │   ├── HfsPlus.efi
    │   └── OpenRuntime.efi
    ├── Kexts
    │   ├── AppleALC.kext
    │   ├── Lilu.kext
    │   ├── NVMeFix.kext
    │   ├── RealtekRTL8111.kext
    │   ├── SMCProcessor.kext
    │   ├── SMCSuperIO.kext
    │   ├── VirtualSMC.kext
    │   ├── VoodooTSCSync.kext
    │   └── WhateverGreen.kext
    ├── OpenCore.efi
    ├── Resources
    │   ├── Audio
    │   ├── Font
    │   ├── Image
    │   └── Label
    ├── Tools
    │   ├── OpenShell.efi
    │   └── acpidump.efi
    └── config.plist
```

Driver： 只需要添加 HfsPlus 和 OpenRuntime。

Kexts：VirtualSMC, Lilu 这两个是必须的，以及 WhateverGreen 和 AppleALC（我不确定这个是不是真的需要，我这里没有试过，反正是加上了）。网卡用 RealtekRTL8111（这个根据主板上的网卡来选）。USB 相关的不需要。wifi 蓝牙也不需要，我用了免驱的无限网卡。最后就是 VoodooTSCSync 和 NVMeFix。

### SSDT

SSDT 这块，花了不少时间。因为我是裸机安装的，无法直接获取到系统的 DSDT。

所以采用了[https://dortania.github.io/Getting-Started-With-ACPI/Manual/dump.html](https://dortania.github.io/Getting-Started-With-ACPI/Manual/dump.html) 这里提供的最后一种方法：使用 acpidump.efi。具体使用就是：进到 OpenShell 中，执行这个 efi。它会把系统的 DSDT 写出来。按照guide 提供的步骤一步一步来即可。

SSDT的编译：

- SSDT-AWAC, SSDT-EC-USBX,SSDT-PLUG-DRTNIA 这三个是修改 dsl 再编译的。
- SSDT-PMC 直接用 guide 提供的 aml。

### config.plist

config 修改直接按照 guide 说明一步一步走下来即可。不过需要注意一点：

- framebuffer-stolenmem 这个属性最好不加，直接在 BIOS 中设置 iGPU 的 memory。我在这里踩了坑：安装 macos 后，外接的4K显示器只能展示出 2k 的分辨率。后来把这个属性删掉了，才正常。
- 另外，安装过程中，使用 DP 线外接显示器，HDMI 不太好使（会黑屏）。我在这里踩了大坑，搞了整整一天，后来换了根DP 线就好了，直接进入 os 安装界面。

## Post Install

装完之后，基本没搞什么其他操作。音频视频都是正常的。DRM 的视频也能正常播放。airdrop 正常。usb 啥的也都好使。

最后就直接把 EFI copy 到 osx 的系统 EFI 中了，完成整个 hackintosh。

另外，系统安装完之后，把 VT-x 和 VT-d 打开，否则 Docker for Mac 无法启动。

- [https://github.com/docker/for-mac/issues/731](https://github.com/docker/for-mac/issues/731)
- [https://github.com/docker/for-mac/issues/2086](https://github.com/docker/for-mac/issues/2086)
- [https://github.com/docker/for-mac/issues/2255](https://github.com/docker/for-mac/issues/2255)
- [https://www.tonymacx86.com/threads/docker-on-hackintosh.261090/](https://www.tonymacx86.com/threads/docker-on-hackintosh.261090/)
