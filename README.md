# LGTM provisioning using Ansible

This repository contains a playbook for deploying an LGTM installation in an
automatic and reproducible way using Ansible. It includes setting up
integration with GitHub Enterprise

## Running

This repository does not include the LGTM packages and other installation
files that are contained in the LGTM bundle (e.g. `lgtm-1.20.0.tar.gz`).
To add those files, download an LGTM bundle, and run:

```
./setup.sh <path/to/lgtm-1.20.0.tar.gz>
```

To maximise the usefulness of this repository as a reference guide, it
includes all the configuration you would need to run the playbook, including
encrypted secrets. However, to prevent people accidentally deploying these
fixed secrets, the decryption key is *not* provided. Before running this
playbook, you must generate fresh secrets.

To generate secrets, put a strong password for Ansible vault in `passwd-file`
then run:

```
ANSIBLE_VAULT_PASSWORD_FILE=passwd-file ./fresh-secrets.sh
```

Finally, adjust the configuration to suit your needs by editing:

  - `inventories/dev/hosts` — to change the number and names of the hosts
    deployed to
  - `inventories/dev/all.yml` — to adjust the external LGTM hostname, the URL for GitHub, and other global settings

Then run the playbook:

```
ANSIBLE_VAULT_PASSWORD_FILE=passwd-file ansible-playbook -i inventories/dev site.yml
```
