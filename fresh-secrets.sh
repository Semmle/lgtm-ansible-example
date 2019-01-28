#!/bin/bash

set -eu

env="${1:-dev}"

root="$(dirname $0)"
config_jar="${root}/files/lgtm/lgtm-config-gen.jar"
tmp_dir="${root}/tmp-state"
manifest="${root}/files/${env}-manifest.xml"
varfile="${root}/inventories/${env}/group_vars/all.yml"

function add_secret {
	ansible-vault encrypt_string --name "$1" "$2" >> "${varfile}"
}

echo "*"
echo "* Collecting secrets to put in ${varfile}"
echo "*"

read -p "Enter a secure password for the LGTM manifest: " manifest_password
export LGTM_CREDENTIALS_PASSWORD="$manifest_password"
add_secret lgtm_manifest_password "${manifest_password}"

for var in lgtm_ghe_checkout_username lgtm_ghe_checkout_password lgtm_ghe_client_id lgtm_ghe_client_secret
do
	read -p "Enter value for ${var}: " secret
	add_secret "$var" "$secret"
done

read -p "Enter a path to the certificate for the LGTM web interface: " certfile
read -p "Enter a path to the key for that certificate: " keyfile
cp "$certfile" "${root}/files/${env}.crt"
cp "$keyfile" "${root}/files/${env}.key"
ansible-vault encrypt "${root}/files/${env}.key"

read -p "Enter the path to your license file: " license
cp "$license" "${root}/files/license.dat"
ansible-vault encrypt "${root}/files/license.dat"

echo "*"
echo "* Generating certificates and keys to put in ${manifest}"
echo "*"

# Remove any old files
rm -rf "${tmp_dir}"

# Generate a fresh manifest file
mkdir -p "${tmp_dir}"/state
java -jar "$config_jar" init \
	--output "${tmp_dir}"/state/lgtm-cluster-config.yml
java -jar "$config_jar" generate \
	--input "${tmp_dir}"/state/lgtm-cluster-config.yml \
	--output "${tmp_dir}"/generated
cat "${tmp_dir}/state/manifest.xml" \
	| sed '/server-certificate-localhost/{N;N;N;N;N;N;N;d;}' \
	> "${manifest}"

# Remove temporary state
rm -rf "${tmp_dir}"

echo "*"
echo "* Finished! The new secrets are at the bottom of:"
echo "*     ${varfile}"
echo "* If there were already secrets in that file, you will"
echo "* need to remove the duplicates now."
echo "*"
