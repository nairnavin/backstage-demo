#!/bin/bash

set -e

rm -f .env

gum style  --foreground 212 --border-foreground 212 --border normal --margin "1 2" --padding "1 2" \
'Create Kubernetes clusters in DigitalOcean with Pulumi'

echo "
# This script will create a Kubernetes cluster in DigitalOcean using Pulumi

## Prerequisites

You will need following tool installed:

| Name       | Required | More info                                           |
|------------|----------|-----------------------------------------------------|
| Pulumi CLI | Yes      | \`https://www.pulumi.com/docs/iac/download-install/\` |
" | gum format
echo ""
gum confirm "Do you have Pulumi installed?" || exit 0

echo "
## Pulumi Authentication

To create Kubernetes clusters in DigitalOcean, you'll need to provide your Pulumi access token. You can generate one by following the instructions here: \`https://www.pulumi.com/docs/pulumi-cloud/access-management/access-tokens/\`.

Please enter your Pulumi access token below:
" | gum format

cd iac/do-cluster
rm -f .env

PULUMI_ACCESS_TOKEN=$(gum input --placeholder "Enter Pulumi access token" --value "$PULUMI_ACCESS_TOKEN" --password)
echo "export PULUMI_ACCESS_TOKEN=$PULUMI_ACCESS_TOKEN" > $(pwd)/.env
echo ""
echo "
## DigitalOcean Authentication

To create Kubernetes clusters in DigitalOcean, you'll need to provide your DigitalOcean access token. Use the one provided by the workshop organizers.
" | gum format

DIGITALOCEAN_TOKEN=$(gum input --placeholder "DigitalOcean token" --value "$DIGITALOCEAN_TOKEN" --password)
echo "export DIGITALOCEAN_TOKEN=$DIGITALOCEAN_TOKEN" >>  $(pwd)/.env
echo ""

source  .env
pulumi stack init dev || true
pulumi stack select dev
pulumi up -y -f
pulumi stack output kubeconfig --show-secrets > kubeconfig.yaml

export KUBECONFIG=$(pwd)/kubeconfig.yaml
echo "export KUBECONFIG=$(pwd)/kubeconfig.yaml" >> $(pwd)/.env

kubectl get nodes

echo ""

echo "
-> Head over to the next chapter by running the \`./setup.sh\` script
" | gum format
