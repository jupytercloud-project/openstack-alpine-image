#!/bin/sh

set -ux
interface="${interface:-unset}"
mtu="${mtu:-1500}"

if [ "X${interface}" != "Xunset" ]; do
  printf 'Setting MTU to %s on %s' ${mtu} ${interface} | logger
  ip link set ${interface} mtu ${mtu}
fi
