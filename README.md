# LGTM provisioning using Ansible

This repository contains a playbook for deploying an LGTM installation in an
automatic and reproducible way using Ansible, including integration with
GitHub Enterprise.

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

## Troubleshooting

In order to run this playbook, you need one machine with Ansible installed (and
this repository checked out) and several target machines (the machines you wish
to install LGTM on).

There should be a good network connection between the machine running Ansible
and the target machines, as large packages are copied to the target machines.

The target machines should have Python (2 or 3) installed. If they do not, you
will see this error message:

```
fatal: [lgtm-dev-controller]: FAILED! => {"changed": false, "module_stderr": "Shared connection to julian-lgtm-dev-controller closed.\r\n", "module_stdout": "/bin/sh: 1: /usr/bin/python: not found\r\n", "msg": "MODULE FAILURE", "rc": 127}
```

## Contributing

We welcome contributions to this Ansible configuration for deploying LGTM. If
you have an idea or a bugfix then please go ahead and open a pull request!
Before you do, though, please take the time to read our [contributing
guidelines](CONTRIBUTING.md).

## License

The configuration files, scripts, and other files in this repository are
licensed under [Apache License 2.0](LICENSE) by [Semmle](https://semmle.com).
