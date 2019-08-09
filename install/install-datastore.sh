#!/usr/bin/env bash

printUsage() {
  cat <<EOUSAGE
Usage:
  $0 
    -s <storage provider> [px|mp|gp2]
    -r <replication factor> [1|2]
    -k <kubeconfig file> [Optional]
EOUSAGE
  echo "Example: install-datastore.sh px"
}

while getopts "h?:s:" opt; do
    case "$opt" in
    h|\?)
        printUsage
        exit 0
        ;;
    s)  STORAGE_PROVIDER=$OPTARG
        ;;
    R)  RF=$OPTARG
        ;;
    k)  KC=$OPTARG
        ;;
    :)
        echo "[ERROR] Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    default)
       printUsage
       exit 1
    esac
done

if [[ (-z ${STORAGE_PROVIDER}) ]]; then
    echo "[ERROR]: Required arguments missing"
    printUsage
    exit 1
fi

if [[ (${STORAGE_PROVIDER} == "px") && (-z ${RF}) ]]; then
    echo "[ERROR]: Need a replication specification when using px"
    printUsage
    exit 1
fi

if [[ (${STORAGE_PROVIDER} != "px") && (${STORAGE_PROVIDER} != "mp") && (${STORAGE_PROVIDER} != "gp2") ]]; then
    echo "[ERROR]: Invalid argument/ value"
    printUsage
    exit 1
fi

if [ -z ${KC} ]; then
    KC='/root/.kube/config'
fi

if [ ${STORAGE_PROVIDER} == "px" ]; then
    # Create the storageClassses
    kubectl --kubeconfig=${KC} apply -f manifests/portworx-storageclasses.yaml
    if [ ${RF} -eq 2 ]; then
        # Install master
        helm install --name datastore-elasticsearch-master --values manifests/es-master-values-px-rf2.yaml helm-charts/elastic/elasticsearch
        # Install client
        helm install --name datastore-elasticsearch-client --values manifests/es-client-values-px-rf2.yaml helm-charts/elastic/elasticsearch
    else
        # Install master
        helm install --name datastore-elasticsearch-master --values manifests/es-master-values-px-rf1.yaml helm-charts/elastic/elasticsearch
        # Install client
        helm install --name datastore-elasticsearch-client --values manifests/es-client-values-px-rf1.yaml helm-charts/elastic/elasticsearch
    fi
elif [ ${STORAGE_PROVIDER} == "mp" ]; then
    # Install master
    helm install --name datastore-elasticsearch-master --values manifests/es-master-values-mp.yaml helm-charts/elastic/elasticsearch
    # Install client
    helm install --name datastore-elasticsearch-client --values manifests/es-client-values-mp.yaml helm-charts/elastic/elasticsearch
elif [ ${STORAGE_PROVIDER} == "gp2" ]; then
    # Install master
    helm install --name datastore-elasticsearch-master --values manifests/es-master-values-gp2.yaml helm-charts/elastic/elasticsearch
    # Install client
    helm install --name datastore-elasticsearch-client --values manifests/es-client-values-gp2.yaml helm-charts/elastic/elasticsearch
fi
