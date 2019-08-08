#!/usr/bin/env bash

KC=$1

if [ -z ${KC} ]; then
    KC='/root/.kube/config'
fi

### Deploy spark operator
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm  install incubator/sparkoperator --namespace spark-operator --set enableWebhook=true
kubectl --kubeconfig=${KC} create serviceaccount spark
kubectl --kubeconfig=${KC} create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default
