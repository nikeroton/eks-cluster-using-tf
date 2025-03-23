module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~>20.31"

# cluster info
  cluster_name = local.name
  cluster_endpoint_public_access = true
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

#   control plane network
  control_plane_subnet_ids = module.vpc.intra_subnets
  cluster_addons = {
    vpc_cni ={
        most_recent =true
    }
    kube_proxy ={
        most_recent =true
    }
    core_dns ={
        most_recent =true
    }
  }

#   managing nodes in the cluster
  eks_managed_node_group_defaults = {
    attach_cluster_primary_security_group = true
    instance_types = ["t2.micro"]
  }
  eks_managed_node_groups = {
    my-eks-cluster-ng = {
      instance_types = ["t2.micro"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
      capacity_type = "SPOT"
    }
  }

  tags = {
    Terraform = "true"
    Environment = local.env
  }
  
}