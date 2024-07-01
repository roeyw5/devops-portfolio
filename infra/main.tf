# Module for creating argoCD and related resources
module "argocd" {
  source                = "./modules/argocd"
  argocd_namespace      = var.argocd_namespace
  argocd_release_name   = var.argocd_release_name
  argocd_repository     = var.argocd_repository
  argocd_chart          = var.argocd_chart
  argocd_version        = var.argocd_version
  ssh_key_secret_id     = var.ssh_key_secret_id
  repo_creds_name       = var.repo_creds_name
  repo_creds_repo_name  = var.repo_creds_repo_name
  repo_creds_type       = var.repo_creds_type
  repo_creds_project    = var.repo_creds_project
  repo_url              = var.repo_url
  weather_app_namespace = var.weather_app_namespace
  infra_app_namespace   = var.infra_app_namespace
  weather_app_path      = var.weather_app_path
  infra_app_path        = var.infra_app_path
  sync_options          = var.sync_options
  secrets_json          = local.secrets_json
  region                = var.region
  account_id            = var.account_id
  tags                  = var.tags
}


# Module for creating the VPC and related resources
module "network" {
  source                     = "./modules/network"
  availability_zones         = var.availability_zones
  tags                       = var.tags
  vpc_cidr                   = var.vpc_cidr
  cluster_name               = var.cluster_name
  project_name               = var.project_name
  cidr_blocks_public_subnet  = var.cidr_blocks_public_subnet
  cidr_blocks_private_subnet = var.cidr_blocks_private_subnet
}

# Module for creating the EKS cluster and node group
module "compute" {
  source             = "./modules/compute"
  cluster_name       = var.cluster_name
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids
  instance_type      = var.instance_type
  scaling_desired    = var.scaling_desired
  scaling_min        = var.scaling_min
  scaling_max        = var.scaling_max
  ami_id             = var.ami_id
  tags               = var.tags
  key_pair_name      = var.key_pair_name
  vpc_id             = module.network.vpc_id
  account_id         = var.account_id
  region             = var.region
  project_name       = var.project_name
  disk_size          = var.disk_size
  capacity_type      = var.capacity_type
  max_unavailable    = var.max_unavailable
}

