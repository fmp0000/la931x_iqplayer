##!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2024-2025 NXP
####################################################################
#set -x

la9310_ccsr_base=0x`la9310_modem_info | grep CCSR |cut -f 2 -d "x"|cut -f 1 -d " "`
phytimer_base=$[$la9310_ccsr_base + 0x1020000]

devmem $[$phytimer_base + 0x0c] w 0x00000005
devmem $[$phytimer_base + 0x14] w 0x00000005
devmem $[$phytimer_base + 0x1c] w 0x00000005
devmem $[$phytimer_base + 0x24] w 0x00000005
devmem $[$phytimer_base + 0x5c] w 0x00000005