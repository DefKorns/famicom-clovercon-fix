#!/bin/sh
#  Copyright (C) 2026 DefKorns (https://defkorns.github.io/LICENSE)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Explicit modes: Windows checkouts lose exec bits.
set -e
cd "$(dirname "$0")"

out="out/shonen_jump_clovercon_fix.hmod"
tarball="out/shonen_jump_clovercon_fix.tar"
mkdir -p out
rm -f "$out" "$tarball"

tar --force-local -cf "$tarball" --owner=0 --group=0 --mode=644 -C mod ./readme.md
tar --force-local -rf "$tarball" --owner=0 --group=0 --mode=755 -C mod ./uninstall ./etc
gzip -9 -n -c "$tarball" > "$out"
rm -f "$tarball"

tar --force-local -tvzf "$out"
