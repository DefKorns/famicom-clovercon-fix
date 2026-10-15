#!/usr/bin/env bash
set -euo pipefail

[ -f vendor/hmod-build/docker-make.sh ] || git submodule update --init vendor/hmod-build

sh vendor/hmod-build/docker-make.sh "$@"

ls -la out/*.hmod 2>/dev/null
