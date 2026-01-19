# Secure ECS Blue/Green Deployment 🚀

![AWS](https://img.shields.io/badge/AWS-ECS%20Fargate-232F3E)
![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF)
![Status](https://img.shields.io/badge/Deployment-Zero%20Downtime-success)

## 📖 Overview
This project demonstrates a production-ready **DevSecOps pipeline** that deploys a Python FastAPI application to **AWS ECS Fargate** using a **Blue/Green Deployment** strategy. It ensures **Zero Downtime** updates and includes automated security scanning.

## 🏗 Architecture
```
graph LR
    User --> ALB[Load Balancer]
    ALB -->|Prod Traffic| Blue[ECS Task (v1)]
    ALB -->|Test Traffic| Green[ECS Task (v2)]
    CodeDeploy -->|Traffic Switch| ALB
```
## 🛠 Tech Stack

Infrastructure: Terraform (VPC, ALB, ECS, IAM, SG)

Orchestration: AWS ECS Fargate

Deployment: AWS CodeDeploy (Blue/Green)

CI/CD: GitHub Actions + OIDC Authentication

Security: Trivy Vulnerability Scanner

App: Python 3.9 / FastAPI

# 🚀 Quick Start
## Provision Infrastructure
Initialize Terraform and create AWS resources:
```
Bash

terraform init
terraform apply --auto-approve
```
## Deploy Application
Push to the main branch to trigger the GitHub Actions pipeline:
```
Bash

git add .
git commit -m "Initial Deploy"
git push origin main
```
## Verify Blue/Green Switch
Visit the Load Balancer DNS URL.

Update APP_VERSION in task-definition.json.

Push changes and watch CodeDeploy shift traffic without downtime.

# 🧹 Cleanup
To destroy all resources and avoid costs:
```
Bash

terraform destroy --auto-approve
```
Created by Barış Polat
