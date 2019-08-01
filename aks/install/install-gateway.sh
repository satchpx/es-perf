#!/usr/bin/env bash

### Deploy gateway (kafka)
helm  upgrade --wait --timeout=600 --install --values helm-charts/confluent/values-prod.yaml gateway helm-charts/confluent

