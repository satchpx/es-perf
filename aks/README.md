# Elasticsearch-px test on AKS

## Deploy AKS cluster

```
#./deploy.sh -g sathya-px-es -r eastus2 -c sathya-px-es1 -n 6 -s 1000 -d UltraSSD_LRS
# The above is blocked on enabling UltraSSD in US East 2 for the subscription ID
# For now use Standard SSD
./deploy.sh -g sathya-px-es -r eastus2 -c sathya-px-es1 -n 6 -s 1024 -d Premium_LRS
```

## Deploy elasticsearch
```
# Install master
helm install --name datastore-elasticsearch-master --values es-master-values-nopx.yaml ../helm-charts/elastic/elasticsearch
# Install client
helm install --name datastore-elasticsearch-client --values es-client-values-nopx.yaml ../helm-charts/elastic/elasticsearch
```

## Deploy es-rally
```

```

## Deploy the data pipeline

