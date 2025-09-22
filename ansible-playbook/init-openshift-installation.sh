

ansible-playbook ./init-openshift-installation.yaml -e @variables/openshift-initialize.yaml -vv
ansible-playbook ./copy-embeded-iso-files.yaml -e @variables/copy-embeded-iso.yaml -vv
