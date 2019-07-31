# Elasticsearch-px test on AKS

## Deploy AKS cluster

```
#./deploy.sh -g sathya-px-es -r eastus2 -c sathya-px-es1 -n 6 -s 1000 -d UltraSSD_LRS
# The above is blocked on enabling UltraSSD in US East 2 for the subscription ID
# For now use Standard SSD
./deploy.sh -g sathya-px-es -r eastus2 -c sathya-px-es1 -n 6 -s 1024 -d Premium_LRS
```

## Deploy the data pipeline

### Deploy elasticsearch without px (managed premium)
```
# Install master
helm install --name datastore-elasticsearch-master --values manifests/es-master-values-nopx.yaml ../helm-charts/elastic/elasticsearch
# Install client
helm install --name datastore-elasticsearch-client --values manifests/es-client-values-nopx.yaml ../helm-charts/elastic/elasticsearch
```

### Deploy gateway (kafka)
```
helm  upgrade --wait --timeout=600 --install --values ../helm-charts/confluent/values-prod.yaml gateway ../helm-charts/confluent
```

### Deploy spark operator
```
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm  install incubator/sparkoperator --namespace spark-operator --set enableWebhook=true
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default
```

## Start the test

### Create topic
```
kubectl exec -it gateway-cp-kafka-0 --container cp-kafka-broker bash
kafka-topics --zookeeper gateway-cp-zookeeper:2181 --topic planes3 --create --replication-factor 1 --partitions 3
kafka-topics --zookeeper gateway-cp-zookeeper:2181 --topic planes5 --create --replication-factor 1 --partitions 5
kafka-topics --zookeeper gateway-cp-zookeeper:2181 --topic planes7 --create --replication-factor 1 --partitions 7
kafka-topics --zookeeper gateway-cp-zookeeper:2181 --topic planes10 --create --replication-factor 1 --partitions 10
```

### Deploy spark job
```
kubectl apply -f manifests/sparkop-es-2.4.1.yaml
```

### Deploy rttest-mon
```
kubectl apply -f manifests/rttest-mon.yaml
```

### Note: Wait for the pods to become ready before proceeding.

### Start Elastic Index Monitor (EIM)
```
kubectl exec -it rttest-mon-2 tmux
cd /opt/rttest
java -cp target/rttest.jar com.esri.rttest.mon.ElasticIndexMon http://datastore-elasticsearch-client:9200/planes 70
```

### Start Kafka Topic Monitor (KTM)
```
kubectl exec -it rttest-mon-1 tmux
cd /opt/rttest
java -cp target/rttest.jar com.esri.rttest.mon.KafkaTopicMon gateway-cp-kafka:9092 planes3
```

### Start Send
```
kubectl apply -f manifests/rttest-send-kafka-25k-5m.yaml
```


### Deploy elasticsearch with px
#### Create the storageClass
```
kubectl apply -f ../manifests/portworx-storageclasses.yaml
```

#### Deploy elasticsearch using helm
```
# Install master
helm install --name datastore-elasticsearch-master --values manifests/es-master-values-px-rf1.yaml ../helm-charts/elastic/elasticsearch
# Install client
helm install --name datastore-elasticsearch-client --values manifests/es-client-values-px-rf1.yaml ../helm-charts/elastic/elasticsearch
```


## Deploy es-rally
```
helm install --name elasticsearch-rally ../helm-charts/elasticsearch-rally
```


