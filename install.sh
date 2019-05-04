#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Vimix
COLOR_VARIANTS=('-Doder' '-Beryl' '-Ruby' '-Black' '-White')

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local dest=${1}
  local name=${2}
  local color=${3}

  local THEME_DIR=${dest}/${name}${color}

  [[ -d ${THEME_DIR} ]] && rm -rf ${THEME_DIR}

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                           ${THEME_DIR}
  cp -ur ${SRC_DIR}/COPYING                                                          ${THEME_DIR}
  cp -ur ${SRC_DIR}/AUTHORS                                                          ${THEME_DIR}

  cp -ur ${SRC_DIR}/Vimix-Paper/*                                                    ${THEME_DIR}/
  cp -r ${SRC_DIR}/Places-color/places${color}/*.svg                                 ${THEME_DIR}/scalable/places/

  cd ${THEME_DIR}
  sed -i "s/-Paper/${color}/g" index.theme

  cd ${dest}
  gtk-update-icon-cache ${name}${color}
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

install_base() {
  [[ -d ${DEST_DIR}/Vimix-Paper ]] && rm -rf ${DEST_DIR}/Vimix-Paper
  [[ -d ${DEST_DIR}/Vimix-Old ]] && rm -rf ${DEST_DIR}/Vimix-Old

  cp -ur ${SRC_DIR}/Vimix-Paper ${DEST_DIR}
  cp -ur ${SRC_DIR}/Vimix-Old   ${DEST_DIR}

  cd ${DEST_DIR}
  gtk-update-icon-cache Vimix-Paper
  gtk-update-icon-cache Vimix-Old
}

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${color}"
done

install_base

echo
echo Done.

