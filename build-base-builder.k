oxr = option("params").oxr
ocds = option("params").ocds
ctx = option("params").ctx

env_config = ctx['apiextensions.crossplane.io/environment']

_metadata = lambda extname: str, suffix: str -> any {
    {
        name = oxr.metadata.name + "-" + suffix
        annotations = {
            "crossplane.io/external-name" = extname if extname != "" else oxr.metadata.name + "-" + suffix
            "krm.kcl.dev/composition-resource-name" = oxr.metadata.name + "-" + suffix
    }
    }
}

runner_config = oxr.spec.parameters.arcrunners

## Leverage the base cluster and configure based of a profile of the 
## ARC Runner type
xcluster = {
    apiVersion = "cluster.gaig.com/v1alpha1"
    kind = "GaigCluster"
    metadata = {
        name = oxr.metadata.name
    }
    spec.parameters = { 
        cluster = {
            cluster_name = runner_config.runner_name
            version = "1.29.2"
            cluster_type = "cirunner"
            network_cidr_size = "small"
            pod_cidr = "10.0.0.0/22"
            service_cidr = "10.0.128.0/21"
            service_dns_ip = "10.0.128.10"
            system_node_pool = {
                min_nodes =  1
                max_nodes =  3
                compute_size = "small"
            } 
            worker_node_pool = [{
                name =  "runners"
                min_nodes = 1
                max_nodes = 3

            }]
        }
    }
} 
items = [xcluster]
