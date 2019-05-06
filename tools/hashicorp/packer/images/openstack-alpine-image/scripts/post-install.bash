
#set -ux 

ALPINE_RELEASE="$(cat /etc/alpine-release)"

# Upgrade All Packages in OneShot
#apk upgrade --update-cache --available

function install_consul {
  apk add consul
}
#
# install cloud-init
#
function install_cloud_init {
  apk add cloud-init \
          dmidecode \
          udev \
          iproute2 \
          drill
  #      procps \
  rc-update add cloud-init default
}

#
# install docker
#
function install_docker {
  apk add fuse
  echo 'fuse' >> /etc/modules
  modprobe fuse

  apk add docker
  rc-update add docker default
  rc-service docker start
  sleep 2
  docker plugin install --grant-all-permissions vieux/sshfs
}

function install_consul {
  apk add consul
}
#
# install fuse filesystems
#
function install_fuse {
#  apk add s3fs-fuse
  apk add fuse
          sshfs
}


function install_motd {
  esh -o /etc/motd \
    /tmp/data/etc/motd.esh \
    ALPINE_RELEASE=${ALPINE_RELEASE}
  chmod a+r /etc/motd
}

function install_udhcpc {
  cp /tmp/data/etc/network/interfaces \
    /etc/network/interfaces
  cp -R /tmp/data/etc/udhcpc \
    /etc/
  chmod u+x /etc/udhcpc/post-bound/*.sh
}
#############################################################################
#
# yq is a portable command-line YAML processor
# https://github.com/mikefarah/yq
# http://mikefarah.github.io/yq/
#
#############################################################################
function install_yq {
  local version='2.3.0'
  local src="https://github.com/mikefarah/yq/releases/download/${version}/yq_linux_amd64"
  local dst='/usr/bin/yq'
  wget "${src}" -O "${dst}"
  chmod a+x "${dst}"
}

#
#
#
function install_cloud_init_lite {
  set -ux
  #
  #
  #
  printf "169.254.169.254 openstack-metadata-service.link-local\n" >> /etc/hosts

  esh -o /etc/init.d/cloud-init-lite \
      /tmp/data/etc/init.d/cloud-init-lite.esh
      
  chmod a+x "/etc/init.d/cloud-init-lite"
  rc-update add cloud-init-lite boot
}

function main {
  install_fuse
  install_docker
  install_consul
  install_motd
  install_udhcpc
  install_yq
  install_cloud_init_lite
}

main

