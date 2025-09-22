# !/bin/bash


export KUBECONFIG=/ocp/ocp-setup/auth/kubeconfig

oc extract -n openshift-machine-api secret/worker-user-data --keys=userData --to=.
mv userData worker.ign


oc extract -n openshift-machine-api secret/master-user-data --keys=userData --to=.
mv userData master.ign