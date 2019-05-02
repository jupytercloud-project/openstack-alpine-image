#!/bin/bash

qemu_output='output-qemu'
qemu_registry='qemu-registry/'
packer_project="$(dirname ${BASH_SOURCE})"
image_name_base="$(basename ${packer_project})"
alpine_mirror='http://dl-cdn.alpinelinux.org'
latest_releases='latest-releases.yaml'
alpine_releases="${alpine_mirror}/alpine/latest-stable/releases/x86_64/${latest_releases}"

function ::Build.prepare() {
  rm -Rf "${qemu_output}"
  mkdir -p "${packer_project}/run"
  mkdir -p "${qemu_registry}"
}

function ::Facts.fetch() { 
  facter --json osfamily \
    | jq --from-file ${packer_project}/facts.jq \
        --arg project_directory ${packer_project} \
        --arg image_name_base ${image_name_base} \
  > ${packer_project}/run/facts.json
}
function ::AlpineRelease::Metadata.fetch() {
  curl --location ${alpine_releases} \
       --output ${packer_project}/run/${latest_releases}
  cat ${packer_project}/run/${latest_releases} \
    | yq read --tojson - [*] \
    | jq --from-file ${packer_project}/release.jq \
          --arg mirror ${alpine_mirror} \
  > ${packer_project}/run/release.json
}
function ::Packer.build() {
  #PACKER_LOG_PATH=${packer_log_path} \
  PACKER_LOG=1 \
  packer build \
    -var-file ${packer_project}/run/facts.json \
    -var-file ${packer_project}/run/release.json \
    ${packer_project}/config-qemu.json \
  && mv output-qemu/*.raw ${qemu_registry}
}
function ::Main () {
  ::Build.prepare
  ::Facts.fetch
  ::AlpineRelease::Metadata.fetch
  ::Packer.build
}

::Main
