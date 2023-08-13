# Thinkering With OP Stack

## Rationale
this section allows you to iterate easily, after passing
[generate-the-l2-config-files](https://stack.optimism.io/docs/build/getting-started/#generate-the-l2-config-files) in getting started guide OP Stack

## Local dev

from this point, we are expecting you are already have
```sh
echo "Admin Key"
echo "Proposer Key"
echo "Batcher Key"
echo "Sequencer Key"
echo "genesis.json"
echo "rollup.json"
echo "jwt.txt"
```

and know the values of l2ChainID, L1StandardBridgeProxy, L2OutputOracleProxy

if not run this command
```sh
cd packages/contracts-bedrock

cat deployments/getting-started/L1StandardBridgeProxy.json | jq -r .address
cat deployments/getting-started/L2OutputOracleProxy.json | jq -r .address
```

### Setup
copy `genesis.json` and `rollup.json` into [goerli folder](./goerli/)

```sh
cp .tpl-env.goerli env.goerli
```

fill out missing value in env.goerli:

```txt
"OP_NODE_L2_ENGINE_AUTH_RAW" with value in jwt.txt
"OP_NODE_L1_ETH_RPC" with L1 server RPC
"OP_NODE_L1_KIND" with the provider
"OP_NODE_SEQUENCER_KEY" with sequencer key
"OP_BATCHER_KEY" with batcher key
"OP_PROPOSER_KEY" with proposer key
"OP_PROPOSER_L2OO_ADDR" with L2OutputOracleProxy
```

### Docker Compose

[check this yaml manifest](./docker/compose.yaml), comment out image section, and uncomment build section if you want to build your own docker images

```sh
docker compose -f build/docker/compose.yaml up
```

### Kubernetes
[check this yaml manifest](./k8s/op-stack/config/config-template.yaml), fill out the missing config Private Key value and adapt value of RPC URL with your own config

after all the configmap key is the same like env.goerli

```sh
cp build/k8s/op-stack/config/config-template.yaml  build/k8s/op-stack/config/config.yaml

kustomize build build/k8s/blockscout | kubectl apply -f -
```