#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CWD=$(pwd)

if [[ "$VCPKG_ROOT" == "" ]]; then
  echo "NO VCPKG_ROOT!"
  exit 1
fi 

if [[ $CWD == $SCRIPT_DIR ]]; then 
  _SRC="$SCRIPT_DIR"
  _BUILD="${SCRIPT_DIR}/build"
  if [[ ! -d ./build ]]; then 
    mkdir build 
  fi
elif [[ "$CWD/../" -ef $SCRIPT_DIR ]]; then
  _SRC=".."
  _BUILD="."
else
  echo "Cannot configure from directory: $CWD"
  exit 1 
fi
_CMD="$(command -v cmake)"
if command -v ninja &> /dev/null; then
  _CMD="${_CMD} -G\"Ninja Multi-Config\""
fi
_CMD="${_CMD} -DCMAKE_TOOLCHAIN_FILE=${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
_CMD="${_CMD} -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=${SCRIPT_DIR}/toolchain/clang-latest.cmake"
_CMD="${_CMD} -S ${_SRC} -B ${_BUILD}"

echo "${_CMD}"
eval "${_CMD}"
