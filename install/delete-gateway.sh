#!/usr/bin/env bash

### Delete gateway (kafka)
helm  delete --purge gateway

kubectl get pvc -l app=cp-kafka -o name | xargs kubectl delete
kubectl get pvc -l app=cp-zookeeper -o name | xargs kubectl delete
