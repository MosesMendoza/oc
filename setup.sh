#!/bin/bash

export PREFIX="/opt/tools"
export PATH="${PATH}:${PREFIX}/bin"

base="/home/oc"

make_dirs(){
  echo "creating directories"
  mkdir -p "${base}/build/vim"
  mkdir -p "${base}/{unpackaged,sources}"
  sudo mkdir -p "${PREFIX}"
  sudo chown "${USER}" "${PREFIX}"
  echod "done"
}

get_sources(){
  echo "retrieving sources"
  pushd "${base}/sources"


echo "setting up directories"

echo "Downloading vim"

