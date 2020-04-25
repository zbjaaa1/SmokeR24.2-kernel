#!/bin/bash
set -e
USER_AGENT="WireGuard-AndroidROMBuild/0.3 ($(uname -a))"
# https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-1.0.20200401.tar.xz

[[ $(( $(date +%s) - $(stat -c %Y "net/wireguard/.check" 2>/dev/null || echo 0) )) -gt 86400 ]] || exit 0

[[ $(curl -A "$USER_AGENT" -LSs https://git.zx2c4.com/wireguard-linux-compat/refs/) =~ snapshot/wireguard-linux-compat-([0-9.]+)\.tar\.xz ]]

if [[ -f net/wireguard/version.h && $(< net/wireguard/version.h) == *${BASH_REMATCH[1]}* ]]; then
	touch net/wireguard/.check
	exit 0
fi

rm -rf net/wireguard
mkdir -p net/wireguard
curl -A "$USER_AGENT" -LsS "https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-${BASH_REMATCH[1]}.tar.xz" | tar -C "net/wireguard" -xJf - --strip-components=2 "wireguard-linux-compat-${BASH_REMATCH[1]}/src"
#module
#sed -i 's/tristate/bool/;s/default m/default y/;' net/wireguard/Kconfig
touch net/wireguard/.check
