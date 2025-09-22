#!/bin/bash

machine_type=$1

ansible-playbook ./init-ocp-svc.yaml -e @variables/coreos-boot-vars.yaml -e "machine_type=${machine_type}" -vv