#!/usr/bin/env bash

KC=$1

if [ -z ${KC} ]; then
    KC='/root/.kube/config'
fi

# Delete master
helm delete --purge datastore-elasticsearch-master
# Delete client
helm delete --purge datastore-elasticsearch-client
# Delete pvc
kubectl --kubeconfig=${KC} get pvc -l app=datastore-elasticsearch-master -o name | xargs kubectl --kubeconfig=${KC} delete
kubectl --kubeconfig=${KC} get pvc -l app=datastore-elasticsearch-client -o name | xargs kubectl --kubeconfig=${KC} delete
