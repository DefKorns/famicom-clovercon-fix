MOD_ID       := famicom_clovercon_fix
MOD_NAME     := Famicom Clovercon Fix
MOD_CATEGORY := System
MOD_DEPS     := mod/install mod/uninstall mod/etc/init.d/S77clvcon_detect

all: hmod

clean:
	rm -rf out/

include vendor/hmod-build/hmod.mk

.PHONY: all clean
