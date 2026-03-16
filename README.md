# Terraform

Create auth credentials to allow terraform provider to access gcloud-cli
```sh
gcloud auth application-default login
```

Then deploy the resources described in [/terraform/gcp/main.tf](./terraform/gcp/main.tf):

```sh
terraform init
terraform plan
terraform apply --auto-approve
```

If after 30min or more, the deployment is stucked creating the cluster, it is possible that the pool node doesn't have enough quota resources. You can check it running:

```sh
gcloud logging read "resource.type=gke_cluster AND resource.labels.cluster_name=<CLUSTER-NAME>" --project=<PROJECT-NAME> --limit=10
```

And looking for a message like this

```
message: "Google Compute Engine: Not all instances running in IGM after 35m17.285671686s.\
      \ Expected 1, running 0, transitioning 1. Current errors: [GCE_STOCKOUT]: Instance\
      \ 'gke-my-cluster-default-pool-c49f31f2-8gk6' creation failed: The zone 'projects/cloud-login-489913/zones/europe-west3-a'\
      \ does not have enough resources available to fulfill the request.  Try a different\
      \ zone, or try again later."
```
If you see it, then try to change the zone var used to deploy the nodes in [/terraform/gcp/variables.tf](./terraform/gcp/variables.tf), and rexecute `terraform apply`.

After the deployment has ended, execute this

```sh
kubectl get ingress ingress
NAME      CLASS    HOSTS                     ADDRESS       PORTS   AGE
ingress   <none>   vote.local,result.local   34.8.238.38   80      23m
```

If you don't see under <ADDRESS> an IPv4, wait a moment, until the LoadBalander is configured. 

Then, copy the ADDRESS IPv4, and put this under /etc/hosts in you local machine:

```sh
sudo vim /etc/hosts
34.8.238.38 vote.local result.local
```

Save it, and access to both services directly from your browser: http://vote.local and http://result.local