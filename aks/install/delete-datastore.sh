#!/usr/bin/env bash


# Delete master
helm delete --purge datastore-elasticsearch-master
# Delete client
helm delete --purge datastore-elasticsearch-client
# Delete pvc
kubectl get pvc -l app=datastore-elasticsearch-master -o name | xargs kubectl delete -f
kubectl get pvc -l app=datastore-elasticsearch-client -o name | xargs kubectl delete -f
