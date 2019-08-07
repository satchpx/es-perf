# EKS

## Deploy EKS Cluster

#### Pre-requisites
1. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
2. Install [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl)
3. Have the AWS CLI credentials available. The following will be needed later:
```
AWS Access Key ID
AWS Secret Access Key
Default Region
Default Output Format
```

### Before you begin
```
git clone https://github.com/satchpx/es-perf
cd es-perf/eks
touch .creds.env
```

Add the following to `.creds.env` file:
```
AWS_ACCESS_KEY_ID=<AWS Access Key ID>
AWS_SECRET_ACCESS_KEY=<AWS Secret Access Key>
```

### Deploy the cluster