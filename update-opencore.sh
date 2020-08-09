#!/bin/bash
set -e
OPENCORE=$1

for f in EFI/BOOT/BOOTx64.efi EFI/OC/Bootstrap/Bootstrap.efi EFI/OC/Drivers/OpenRuntime.efi EFI/OC/OpenCore.efi EFI/OC/Tools/OpenShell.efi; do
    cp $OPENCORE/$f $f
done



