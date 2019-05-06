#!/bin/bash


set -x

qemu_output='output-qemu'
qemu_registry='qemu-registry/'
packer_project="$(dirname ${BASH_SOURCE})"
image_name_base="$(basename ${packer_project})"
alpine_version='3.9.3'
source_image_release="0.0.1"
source_image_name="qemu-alpine-image-${alpine_version}.raw"
source_image_url="https://github.com/jupytercloud-project/qemu-alpine-image/releases/download/${source_image_release}/${source_image_name}"

function ::Build.prepare() {
  rm -Rf "${qemu_output}"
  mkdir -p "${packer_project}/run"
  mkdir -p "${qemu_registry}"
  curl --location \
       --output "${qemu_registry}/${source_image_name}" \
       "${source_image_url}"
}

function ::Facts.fetch() { 
  facter --json osfamily \
    | jq --from-file ${packer_project}/facts.jq \
        --arg project_directory ${packer_project} \
        --arg image_name_base ${image_name_base} \
  > ${packer_project}/run/facts.json
}
function ::AlpineRelease::Metadata.fetch() {
#  curl --location ${alpine_releases} \
#       --output ${packer_project}/run/${latest_releases}
#  cat ${packer_project}/run/${latest_releases} \
#    | yq read --tojson - [*] \
#    | jq --from-file ${packer_project}/release.jq \
#          --arg mirror ${alpine_mirror} \
#  > ${packer_project}/run/release.json
  echo "{ \"source_image\": \"${qemu_registry}${source_image_name}\" }" > ${packer_project}/run/release.json
}
function ::Packer.build() {
  #PACKER_LOG_PATH=${packer_log_path} \
  PACKER_LOG=1 \
  packer build \
    -var-file ${packer_project}/run/facts.json \
    -var-file ${packer_project}/run/release.json \
    ${packer_project}/config-qemu.json \
  && mv ${output_qemu}/${image_name_base}-${alpine_version}.raw ${qemu_registry}
}
function ::Main () {
  ::Build.prepare
  ::Facts.fetch
  ::AlpineRelease::Metadata.fetch
  ::Packer.build
}

::Main
