
# 🚚 Driver Hours AWS Infrastructure

AWS infrastructure for a Driver Hours Reporting System, fully built with Terraform IaC. Designed according to AWS Well-Architected best practices, it ensures strong security, high availability, optimized costs, and a modular architecture that’s easy to scale and expand.

---

## 📘 Project Overview

This repository provides a fully modular AWS environment that includes:

- VPC with public and private subnets across multiple Availability Zones  
- Application Load Balancer (ALB) protected by AWS WAF  
- EC2 Auto Scaling Group (ASG) deployed in private subnets  
- RDS Multi-AZ database (encrypted)  
- S3 buckets for logs, backups, and static content  
- IAM least-privilege roles and instance profiles  
- CloudWatch logs, metrics, alarms, and SNS notifications  
- Terraform backend stored in S3 with DynamoDB state locking  
- CI/CD-ready structure for GitHub Actions  

---

## 🏗 Architecture Diagram

```text
 Users
   │
   ▼
 AWS WAF
   │
   ▼
 Application Load Balancer (Public)
   │
   ▼
 EC2 Auto Scaling Group (Private Subnets)
   │
   ▼
 RDS Multi-AZ (Private, Encrypted)
   │
   ▼
 S3 (Logs • Backups • Static Files)
```

## 🔐 Security Architecture

### **Network Security**
- EC2 instances run in **private subnets only**
- Only ALB is publicly accessible
- AWS WAF blocks harmful requests at Layer 7
- Security Groups strictly control inbound/outbound flows
- NACLs restrict subnet-level behavior

### **Encryption**
- HTTPS is supported through AWS ACM certificates in production environments
- RDS encrypted using AWS KMS
- S3 buckets encrypted (SSE-S3 or SSE-KMS)
- TLS enforced end-to-end

### **IAM**
- Full least-privilege IAM policies
- EC2 instance role includes access only to logs + SSM
- Secrets stored securely in AWS SSM Parameter Store or Secrets Manager

---

## 📊 Monitoring & Logging

The monitoring module includes:
- CloudWatch log groups (ALB, EC2, System Logs, Application logs)
- CloudWatch alarms on CPU, instance status, and ALB errors
- SNS notifications to an alert email address
- S3 bucket for ALB access logs
- RDS performance metrics (CPU, connections, free storage)
## 📁 Project Structure

```text
driver-hours-aws-infra/
│
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
│
├── modules/
│   ├── alb/
│   ├── compute/
│   ├── iam/
│   ├── monitoring/
│   ├── rds/
│   ├── s3/
│   ├── vpc/
│   └── waf/
│
├── envs/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.auto.tfvars   (excluded)
│   │
│   └── prod/
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.auto.tfvars   (excluded)
│
└── .github/
    └── workflows/
        └── deploy-eks.yml    # CI/CD pipeline (terraform plan/apply)
```

## 🚀 Quick Start

### **1. Initialize Terraform**
```bash
terraform init
```
### **2. Preview changes**
```bash
terraform plan
```
### **3. Apply infrastructure**
```bash
terraform apply -auto-approve
```
----

## ⚙️ CI/CD With GitHub Actions

The repository includes a complete GitHub Actions pipeline that performs:

- Terraform formatting (`terraform fmt`)
- Terraform validation (`terraform validate`)
- Terraform plan creation
- Manual approval stage (for safe production deployments)
- Terraform apply
- Optional ALB health checks after deployment

All sensitive values including the region, VPC CIDRs, instance types, alert email, and database credentials are securely stored in **GitHub Secrets**.

---

## 🧪 Post-Deployment Verification

### **ALB / EC2**
- ALB returns **HTTP 200**
- Target Group shows **healthy** EC2 instances

### **RDS**
- EC2 can successfully connect to the database
- Multi-AZ failover functions correctly

### **Security**
- EC2 instances are **not publicly accessible**
- RDS is accessible **only** from the EC2 Security Group
- WAF logs show blocked or filtered harmful requests

### **Monitoring**
- CloudWatch logs are visible
- SNS alert emails are received
- ALB access logs are stored in S3

---

## 📝 Summary

This project deploys a complete, production-grade AWS environment using Terraform modules:

- Secure and isolated VPC  
- Public ALB protected with AWS WAF  
- Private EC2 Auto Scaling Group  
- Encrypted Multi-AZ RDS  
- S3 for logs, backups, and static assets  
- IAM least-privilege implementation  
- CloudWatch logging and SNS alerting  
- Remote Terraform backend (S3 + DynamoDB)  
- CI/CD-ready with GitHub Actions — secure, scalable, cost-efficient, and production-grade  

