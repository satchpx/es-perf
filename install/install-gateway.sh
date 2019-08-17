#!/usr/bin/env bash

printUsage() {
  cat <<EOUSAGE
Usage:
  $0 
    -s <storage provider> [px|mp|gp2]
    -r <replication factor> [1|2|3]
EOUSAGE
  echo "Example: install-datastore.sh px"
}

while getopts "h?:s:r:" opt; do
    case "$opt" in
    h|\?)
        printUsage
        exit 0
        ;;
    s)  STORAGE_PROVIDER=$OPTARG
        ;;
    r)  RF=$OPTARG
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

### Deploy gateway (kafka)
if [ ${STORAGE_PROVIDER} == "gp2" ]; then
    helm  upgrade --wait --timeout=600 --install --values manifests/kafka-values-gp2.yaml gateway helm-charts/confluent
elif [ ${STORAGE_PROVIDER} == "mp" ]; then
    helm  upgrade --wait --timeout=600 --install --values manifests/kafka-values-mp.yaml gateway helm-charts/confluent
elif [ ${STORAGE_PROVIDER} == "px" ]; then
    if [ ${RF} -eq 1 ]; then
        helm  upgrade --wait --timeout=600 --install --values manifests/kafka-values-px-rf1.yaml gateway helm-charts/confluent
    elif [ ${RF} -eq 2 ]; then
        helm  upgrade --wait --timeout=600 --install --values manifests/kafka-values-px-rf2.yaml gateway helm-charts/confluent
    elif [ ${RF} -eq 3 ]; then
        helm  upgrade --wait --timeout=600 --install --values manifests/kafka-values-px-rf3-db-remote.yaml gateway helm-charts/confluent
    else
        echo "[ERROR]: Unknown replication factor ${RF}"
        exit 1
    fi
else
    echo "[ERROR]: Don't know what you're upto"
    printUsage
    exit 1
fi
