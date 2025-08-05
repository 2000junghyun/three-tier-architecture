# Three-Tier Security Architecture

## Overview

This project provisions a **three-tier architecture** on AWS using Terraform. It separates the **Web**, **App**, and **DB** tiers into independent instances across different subnets, providing improved scalability, fault isolation, and security.

## Tech Stack

- Terraform (modular infrastructure as code)
- AWS EC2 (Web & App Tier)
- AWS RDS (DB Tier)
- Ubuntu 24.04
- Nginx + Flask + MySQL
- Shell scripts: `setup_web.sh`, `setup_app.sh`
- CloudWatch & S3 for logging (optional)

## Directory Structure

```
.
├── modules/
│   ├── vpc/                # Creating VPC, subnets, route tables, gateways
│   ├── security_group/     # Defining all security group rules for each tier
│   ├── alb/                # Provisioning the Application Load Balancer (ALB)
│   ├── ec2_web/            # Launching and configuring EC2 instances for the Web Tier
│   ├── ec2_app/            # Launching and configuring EC2 instances for the App Tier
│   ├── ec2_db/             # Launching EC2-based self-managed MySQL DB
│   └── rds/                # Provisioning AWS RDS managed database service
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## How to Use

### Create resources

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

> Make sure you have created an AWS key pair named `three-tier-key`.

### Tier Connection Test

- **Web Tier (ALB) → Web EC2**
  - Open ALB DNS in browser:  
    `http://<alb_dns_name>` → `Hello from Web Tier!`
- **Web Tier → App Tier**
  - SSH into Web EC2 and test connection:  
    `$ curl http://<app_private_ip>:5000` → `Hello from App Tier!`
- **App Tier → DB Tier**
  - SSH into App EC2 and connect to RDS or EC2 DB:  
    `$ mysql -h <rds-endpoint> -u <db-user> -p`

### Remove resources

```bash
$ terraform destroy
```


## Features / Main Logic

- **Modular Terraform Structure**  
  All components (VPC, Subnets, Routes, Security Groups, EC2, ALB, RDS) are managed via reusable modules.

- **Auto Scaling & Multi-AZ Support**  
  Web/App Tier EC2 instances are deployed across multiple Availability Zones using Auto Scaling Groups.

- **User Data Scripts for Initialization**  
  - `setup_web.sh` installs and configures Nginx.
  - `setup_app.sh` installs Python, Flask, creates a virtual environment, and registers the app as a systemd service.

- **Application Load Balancer (ALB)**  
  - All external traffic flows through ALB.
  - Logs can be forwarded to CloudWatch or S3.
  - ALB improves security and supports autoscaling.

- **Dual DB Tier Setup: RDS and EC2**  
  - **RDS** (managed) for real-world scenario
  - **EC2 MySQL** (self-managed) for advanced control and comparison


## Motivation / Expected Impact

- Practice a realistic **three-tier architecture** used in production environments.
- Learn how to provision infrastructure using **Terraform modules**.
- Explore scalability, logging, and security management across all tiers.
- Set the foundation for extending into containerization, WAF, or microservices architecture.