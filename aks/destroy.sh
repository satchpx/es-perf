#!/usr/bin/env bash

printUsage() {
    cat <<EOUSAGE
Usage:
    destroy.sh
      -g <Resource Group Name to destroy>
      -a <App ID> [Optional, will interactively prompt if not provided]
      -p <App Passwd> [Optional, will interactively prompt if not provided]
      -u <Tenant ID> [Optional, will interactively prompt if not provided]


EOUSAGE
    echo "Example: destroy.sh -g sathya-px-rg"
}

while getopts "h?:g:a:p:u:" opt; do
    case "$opt" in
    h|\?)
        printUsage
        exit 0
        ;;
    g)  RG_NAME=$OPTARG
        ;;
    a)  APP_ID=$OPTARG
        ;;
    p)  PASS_KEY=$OPTARG
        ;;
    u)  TENANT_ID=$OPTARG
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

# Validate Input Args
if [[ (-z ${RG_NAME}) ]]; then
    echo "[ERROR]: Required arguments missing"
    printUsage
    exit 1
fi

if [[ (-z ${APP_ID}) || (-z ${PASS_KEY}) || (-z ${TENANT_ID}) ]]; then
    echo "[INFO]: App ID, Pass Key and Tenant Id arguments missing. Using interactive mode..."
    az login
else
    echo "[INFO]: App ID, Pass Key and Tenant Id arguments provided. Using non interactive mode..."
    az login --service-principal -u ${APP_ID} -p ${PASS_KEY}> --tenant ${TENANT_ID}
fi

az group delete --name ${RG_NAME} --yes --no-wait
