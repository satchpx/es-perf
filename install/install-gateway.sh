#!/usr/bin/env bash

### Deploy gateway (kafka)
helm  upgrade --wait --timeout=600 --install --values manifests/kafka-values-gp2.yaml gateway helm-charts/confluent

