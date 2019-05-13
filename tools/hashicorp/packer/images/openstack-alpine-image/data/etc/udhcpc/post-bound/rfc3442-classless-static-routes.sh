#!/bin/sh

set -ux

SED=sed #'gsed'
interface="${interface:-eth0}"
routes_string="${staticroutes}"

function routes_array_from_string {
  local routes_string="${1}"
  local split='%s %s;'
  IFS=' '
  printf "$split" ${routes_string}
}

function default_route {
  ip route show default 0.0.0.0/0 | awk '{print $3}'
}

function add_route_on_from {
  local interface="${1}"
  local route_string="${2}"
  local ip_route_add="ip route add %s via %s dev ${interface}"
  IFS=' '
  printf "${ip_route_add}" ${route_string} | sh -s
}

function on_interface_add_routes_from_string {
  local interface="${1}"
  local routes_string="${2}"

  routes_array="$( routes_array_from_string "${routes_string}" )"
  IFS=';'
  for route_string in $routes_array; do
    echo "|${route_string}|"
    match=$(echo $route_string | ${SED} --silent --regexp-extended 's/^(0\.0\.0\.0\/0).*/\1/p')
    echo "match=${match}"
    if [ "X${match}" = 'X' ]; then
      printf 'adding route: %s\n' ${route_string}
      add_route_on_from "${interface}" "${route_string}"
      #sleep 10
    else
      printf 'ignoring default route: %s\n' "${route_string}"
      printf 'default route %s\n' "$(default_route)"
    fi
  done
}

on_interface_add_routes_from_string "${interface}" "${routes_string}"
