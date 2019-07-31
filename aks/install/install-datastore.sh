#!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [px=yes/no]"
    exit 1
fi

PX=$1

if [ $1 == "yes" ]; then
    # Create the storageClassses
    kubectl apply -f manifests/portworx-storageclasses.yaml
    # Install master
    helm install --name datastore-elasticsearch-master --values manifests/es-master-values-px-rf1.yaml helm-charts/elastic/elasticsearch
    # Install client
    helm install --name datastore-elasticsearch-client --values manifests/es-client-values-px-rf1.yaml helm-charts/elastic/elasticsearch
else
    # Install master
    helm install --name datastore-elasticsearch-master --values manifests/es-master-values-nopx.yaml helm-charts/elastic/elasticsearch
    # Install client
    helm install --name datastore-elasticsearch-client --values manifests/es-client-values-nopx.yaml helm-charts/elastic/elasticsearch
fi