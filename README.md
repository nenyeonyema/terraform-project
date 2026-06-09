# 🏗️ Terraform AWS Infrastructure — Learning Project

![Terraform](https://img.shields.io/badge/Terraform->=1.0-7B42BC?style=flat&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC-FF9900?style=flat&logo=amazonaws)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04_LTS-E95420?style=flat&logo=ubuntu)

A progressive, hands-on Terraform project built on AWS — starting from a flat single-file configuration and evolving into reusable, multi-environment modular infrastructure.

---

## 📁 Repository Structure

```
terraform-project/
├── README.md
├── terraform-basic/              # Stage 1 — flat config, no modules
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
└── terraform-modules/            # Stage 2 & 3 — modular + multi-env
    ├── provider.tf
    ├── variables.tf
    ├── main.tf
    ├── outputs.tf
    └── modules/
        └── vpc/
            ├── variables.tf
            ├── main.tf
            └── outputs.tf
```

---

## ⚙️ Prerequisites

Before running any configuration, ensure the following are installed and configured:

- [Terraform](https://developer.hashicorp.com/terraform/install) `>= 1.0`
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Ubuntu `22.04 LTS` or later
- An AWS account with `EC2` and `VPC` permissions

### Verify AWS credentials
```bash
aws configure
aws sts get-caller-identity
```

> The second command should return your `Account ID`, `UserID`, and `ARN`. If it fails, rerun `aws configure`.

---

## 🚀 Stages Overview

| Stage | Folder | Description |
|---|---|---|
| **Stage 1** | `terraform-basic/` | Flat config — all resources in one `main.tf` |
| **Stage 2** | `terraform-modules/` | VPC extracted into a reusable child module |
| **Stage 3** | `terraform-modules/` | Same module called twice for `dev` and `prod` environments |

---

## 📦 Stage 1 — Flat Configuration

> **Location:** `terraform-basic/`

All AWS resources are defined directly in a single `main.tf` with no modules. This is the baseline approach that demonstrates the problem modules solve — repetition, poor reusability, and monolithic files.

### Infrastructure Provisioned

| Resource | Name Tag |
|---|---|
| VPC | `<project_name>-vpc` |
| Internet Gateway | `<project_name>-igw` |
| Public Subnet | `<project_name>-public-subnet` |
| Route Table | `<project_name>-public-rt` |
| Route Table Association | — |
| EC2 Instance (Ubuntu 22.04) | `<project_name>-web` |

### Variables

| Variable | Default | Description |
|---|---|---|
| `region` | `us-east-1` | AWS deployment region |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `subnet_cidr` | `10.0.1.0/24` | Public subnet CIDR block |
| `instance_type` | `t3.micro` | EC2 instance type |
| `project_name` | `nenye-stage1` | Prefix applied to all resource Name tags |

### Outputs

| Output | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `subnet_id` | ID of the public subnet |
| `instance_id` | EC2 instance ID |
| `instance_public_ip` | Public IP address of the EC2 instance |

### Usage

```bash
cd terraform-basic

terraform init
terraform plan
terraform apply
terraform destroy
```

---

## 🧩 Stage 2 — Reusable VPC Module

> **Location:** `terraform-modules/`

The VPC networking logic from Stage 1 is extracted into a child module at `modules/vpc/`. The root configuration calls the module, passes inputs to it, and consumes its outputs to place the EC2 instance in the correct subnet.

### How the Module Is Called

```hcl
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
  project_name = var.project_name
}

resource "aws_instance" "web" {
  subnet_id = module.vpc.subnet_id   # consuming module output
}
```

### Module — `modules/vpc/`

#### Inputs

| Variable | Type | Description |
|---|---|---|
| `vpc_cidr` | `string` | VPC CIDR block |
| `subnet_cidr` | `string` | Public subnet CIDR block |
| `project_name` | `string` | Prefix for all resource Name tags |

#### Outputs

| Output | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `subnet_id` | ID of the public subnet |

### Usage

```bash
cd terraform-modules

terraform init
terraform plan
terraform apply
terraform destroy
```

---

## 🌍 Stage 3 — Multi-Environment Infrastructure

> **Location:** `terraform-modules/`

The same `modules/vpc/` module is called **twice** from root `main.tf` — once for `dev` and once for `prod` — with different CIDRs and resource name prefixes. Two fully isolated environments are provisioned from a single module definition.

### Environment Comparison

| | Dev | Prod |
|---|---|---|
| VPC CIDR | `10.0.0.0/16` | `10.1.0.0/16` |
| Subnet CIDR | `10.0.1.0/24` | `10.1.1.0/24` |
| EC2 Name | `<project_name>-dev-web` | `<project_name>-prod-web` |

### Total Resources Created — `12`

- 2 × VPC
- 2 × Internet Gateway
- 2 × Public Subnet
- 2 × Route Table + Route Table Association
- 2 × EC2 Instance

### Variables

| Variable | Default | Description |
|---|---|---|
| `region` | `us-east-1` | AWS deployment region |
| `project_name` | `nenye` | Base prefix for resource names |
| `instance_type` | `t3.micro` | EC2 instance type for both environments |
| `dev_vpc_cidr` | `10.0.0.0/16` | Dev VPC CIDR block |
| `dev_subnet_cidr` | `10.0.1.0/24` | Dev subnet CIDR block |
| `prod_vpc_cidr` | `10.1.0.0/16` | Prod VPC CIDR block |
| `prod_subnet_cidr` | `10.1.1.0/24` | Prod subnet CIDR block |

### Outputs

| Output | Description |
|---|---|
| `dev_vpc_id` | Dev VPC ID |
| `dev_subnet_id` | Dev subnet ID |
| `dev_instance_id` | Dev EC2 instance ID |
| `dev_instance_public_ip` | Dev EC2 public IP |
| `prod_vpc_id` | Prod VPC ID |
| `prod_subnet_id` | Prod subnet ID |
| `prod_instance_id` | Prod EC2 instance ID |
| `prod_instance_public_ip` | Prod EC2 public IP |

### Usage

```bash
cd terraform-modules

terraform init
terraform plan
terraform apply
terraform destroy
```

---

## 📚 Key Concepts Covered

| Concept | Stage |
|---|---|
| Resource types, local names, and Name tags | 1 |
| Variable definitions, types, and defaults | 1, 2, 3 |
| Data sources — dynamic AMI lookup | 1, 2, 3 |
| Output values | 1, 2, 3 |
| Child module structure — `variables.tf`, `main.tf`, `outputs.tf` | 2 |
| Passing inputs into a module | 2 |
| Consuming module outputs (`module.vpc.subnet_id`) | 2 |
| Multi-environment from a single module | 3 |
| Terraform dependency graph and creation order | All |

---

## 🛠️ Terraform Commands Reference

```bash
terraform init        # Download providers and initialize modules
terraform fmt         # Auto-format all .tf files to HashiCorp standard
terraform validate    # Validate configuration syntax without connecting to AWS
terraform plan        # Preview changes — no real infrastructure touched
terraform apply       # Create or update real infrastructure in AWS
terraform destroy     # Tear down all Terraform-managed infrastructure
```

---

## ⚠️ Important Notes

- All EC2 instances use the **latest Ubuntu 22.04 LTS AMI** sourced dynamically via `data "aws_ami"` — no hardcoded AMI IDs
- `t3.micro` is used as the default instance type — verify free tier eligibility in your specific AWS account
- State is stored locally in `terraform.tfstate` — **do not delete this file** while resources are active or Terraform will lose track of what it has created
- Always run `terraform destroy` after practice sessions to avoid unexpected AWS charges

---

## 👤 Author

**Chinenye Onyema** — DevOps Engineer  
[LinkedIn](https://linkedin.com/chinenyeonyema/) · [Twitter/X](https://twitter.com/nenyeonyema)
