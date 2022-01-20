# Skaffold
https://skaffold.dev/

## Test In Local
https://skaffold.dev/docs/quickstart/  

### `skaffold dev`: Incompatible with multi-node cluster
If your minikube already has a `minikube` profile, which is the default one when installing minikube and kubectl, with multiple nodes.
Then when you execute `minikube start --profile custom` and `skaffold dev`, it will output:
```shell
$ skaffold dev
invalid skaffold config: getting minikube env: running [/usr/local/bin/minikube docker-env --shell none -p minikube --user=skaffold]
 - stdout: "false exit code 81\n"
 - stderr: "X Exiting due to ENV_MULTINODE_CONFLICT: The docker-env command is incompatible with multi-node clusters. Use the 'registry' add-on: https://minikube.sigs.k8s.io/docs/handbook/registry/\n"
 - cause: exit status 81
```
It is because this [Kube-context Activation](https://skaffold.dev/docs/environment/kube-context/).


### `skaffold init`: one or more valid Kubernetes manifests are required to run skaffold
1. Yes, you need Kubernetes manifests in the same project. Typically a Deployment-manifest and perhaps Service and Ingress as well if you want.
2. Use the alpha feature: `skaffold init --generate-manifests`.


Ref: https://stackoverflow.com/questions/66079569/one-or-more-valid-kubernetes-manifests-are-required-to-run-skaffold
