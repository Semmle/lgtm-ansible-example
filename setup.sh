#!/bin/bash

set -eu

lgtm_bundle="${1:-}"
files_dir="$(dirname $0)/files"

if [ -z "$lgtm_bundle" ]; then
	echo Usage: $0 "lgtm-<version>.tar.gz" 1>&2
	exit 1
fi

# Remove any old files
rm -rf "${files_dir}"/lgtm*
rm -rf "${files_dir}"/init/odasa-*

# Unpack LGTM artifacts and put them in place
tar -xzf "$lgtm_bundle" -C "${files_dir}"
mkdir -p "${files_dir}"/{lgtm,init}
rm "${files_dir}"/lgtm-*/lgtm/*.sh
mv "${files_dir}"/lgtm-*/lgtm/* "${files_dir}/lgtm"
rm -r "${files_dir}"/lgtm-*
