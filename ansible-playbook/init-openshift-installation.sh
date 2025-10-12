

ansible-playbook ./init-openshift-installation.yaml -e @variables/openshift-initialize.yaml -vv -kK
# ansible-playbook ./copy-embeded-iso-files.yaml -e @variables/copy-embeded-iso.yaml -vv -kK
