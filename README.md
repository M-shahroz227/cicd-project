# AWS DevOps Project: Infrastructure as Code & CI/CD Automation

A complete hands-on DevOps project demonstrating AWS infrastructure provisioning, configuration management, and automated application deployment using Terraform, Ansible, and GitHub Actions.

## Project Overview

This project demonstrates an end-to-end DevOps workflow:

- Provision AWS infrastructure using Terraform.
- Configure an Amazon Linux 2023 EC2 instance using Ansible.
- Install and configure Nginx as a web server.
- Automate application testing and deployment using GitHub Actions.
- Deploy website updates through AWS Systems Manager (SSM), without SSH or SCP in the CI/CD deployment workflow.

## Project Architecture

```text
                 Developer
                     |
                     | Git Push
                     v
              GitHub Repository
                     |
          +----------+-----------+
          |                      |
          v                      v
      Terraform               Ansible
          |                      |
          v                      v
     AWS Infrastructure     EC2 Configuration
          |                      |
          v                      v
       AWS EC2  <----------  Install Nginx
          |
          v
    GitHub Actions CI/CD
          |
          v
      Build & Test
          |
          v
    Configure AWS Credentials
          |
          v
      AWS Systems Manager
          |
          v
      Deploy index.html
          |
          v
      Restart Nginx
          |
          v
       Live Website
```

## Technologies Used

| Category | Technologies |
|---|---|
| Cloud Platform | AWS |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| CI/CD | GitHub Actions |
| Operating System | Amazon Linux 2023 |
| Web Server | Nginx |
| Remote Management | AWS Systems Manager |
| Version Control | Git and GitHub |
| Scripting | Bash, Python |
| Configuration | YAML, HCL |
| Cloud Security | AWS IAM |

# 1. Terraform – Infrastructure Provisioning

Terraform is used to provision AWS infrastructure through Infrastructure as Code (IaC).

### Infrastructure Created

- AWS EC2 instance
- Amazon Linux 2023 AMI
- EC2 Security Group
- SSH inbound rule restricted to the configured IP
- HTTP inbound rule on port 80
- EC2 key pair configuration
- Default VPC and subnet
- EC2 instance outputs

### Terraform Directory Structure

```text
terraform/
│
├── provider.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── output.tf
│
└── .gitignore
```

### Terraform Files Explained

| File | Purpose |
|---|---|
| provider.tf | AWS provider and region configuration |
| main.tf | AWS infrastructure resources |
| variables.tf | Input variable definitions |
| terraform.tfvars | Variable values |
| output.tf | EC2 instance ID, public IP, DNS and private IP |
| .gitignore | Excludes Terraform state and sensitive files |

### Terraform Commands

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Check formatting:

```bash
terraform fmt
```

Preview infrastructure changes:

```bash
terraform plan
```

Create AWS infrastructure:

```bash
terraform apply
```

Display outputs:

```bash
terraform output
```

Destroy infrastructure when it is no longer needed:

```bash
terraform destroy
```

**Important:** Terraform state files and sensitive variable files should not be committed to GitHub.

# 2. Ansible – Configuration Management

Ansible is used to configure the EC2 instance after Terraform provisions the infrastructure.

### Configuration Tasks

- Connect to EC2 using SSH.
- Use the `ec2-user` account.
- Install Nginx.
- Start the Nginx service.
- Enable Nginx at system startup.
- Configure the website's HTML page.

### Ansible Directory Structure

```text
ansible/
│
├── ansible.cfg
├── inventory.ini
└── nginx.yaml
```

### Ansible Files Explained

| File | Purpose |
|---|---|
| ansible.cfg | Ansible configuration |
| inventory.ini | EC2 host and SSH connection details |
| nginx.yaml | Nginx installation and configuration playbook |

### Ansible Configuration

The inventory contains the EC2 connection information:

```ini
[web]
pathnex ansible_host=YOUR_EC2_PUBLIC_IP ansible_user=ec2-user ansible_ssh_private_key_file=/home/shahroz/.ssh/newpathnex.pem
```

Replace the example public IP with the actual EC2 public IP.

Keep the private key outside the GitHub repository.

### Ansible Playbook

The playbook installs and starts Nginx on Amazon Linux 2023.

```yaml
---
- name: Install and Configure Nginx on Pathnex Server
  hosts: web
  become: yes
  gather_facts: false

  tasks:
    - name: Install Nginx
      ansible.builtin.dnf:
        name: nginx
        state: present

    - name: Start and enable Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: yes
```

### Ansible Commands

Check connectivity:

```bash
ansible all -i inventory.ini -m ping
```

Run the Nginx playbook:

```bash
ansible-playbook -i inventory.ini nginx.yaml
```

Verify Nginx service:

```bash
sudo systemctl status nginx
```

# 3. GitHub Actions – CI/CD Pipeline

GitHub Actions automates application testing and deployment whenever new code is pushed to the `main` branch.

### CI/CD Pipeline Stages

**Stage 1 – Source Code Management**
- Developer pushes code to GitHub.
- GitHub Actions triggers automatically.

**Stage 2 – Build**
- Checks out the application source code.
- Executes the build step.

**Stage 3 – Testing**
- Runs the test script.
- Deployment starts only after successful tests.

**Stage 4 – AWS Authentication**
- Configures AWS credentials from GitHub Secrets.
- Uses a dedicated IAM deployment user.

**Stage 5 – Deployment**
- Sends an AWS Systems Manager Run Command.
- Executes commands on the EC2 instance.
- Updates the Nginx website.

**Stage 6 – Verification**
- Checks the SSM command status.
- Verifies the Nginx HTTP response.
- Reports deployment success or failure.

### GitHub Actions Directory Structure

```text
.github/
└── workflows/
    └── ci.yml
```

### GitHub Secrets

Configure the following secrets:

GitHub Repository → Settings → Secrets and variables → Actions

| Secret | Description |
|---|---|
| AWS_ACCESS_KEY_ID | AWS access key |
| AWS_SECRET_ACCESS_KEY | AWS secret access key |

Never expose AWS credentials in source code.

# 4. AWS Systems Manager Configuration

The deployment workflow uses AWS Systems Manager instead of SSH or SCP.

### EC2 IAM Role

An IAM role is attached to the EC2 instance with this AWS managed policy:

`AmazonSSMManagedInstanceCore`

This allows the EC2 instance to communicate with Systems Manager.

### GitHub Actions IAM User

A dedicated IAM user is used for deployment:

`github-actions-deploy`

The deployment user has permissions for the required SSM operations and EC2 instance description.

### Deployment Process

```text
GitHub Actions
      |
      v
AWS Authentication
      |
      v
SSM SendCommand
      |
      v
Amazon EC2
      |
      v
Update index.html
      |
      v
Restart Nginx
      |
      v
Verify Website
```

# 5. Complete Project Directory Structure

The intended combined GitHub repository structure is:

```text
cicd-project/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── terraform/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── output.tf
│   └── .gitignore
│
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini
│   └── nginx.yaml
│
├── deploy/
│   └── deploy.sh
│
├── tests/
│   └── test.sh
│
├── screenshots/
│   ├── terraform-infrastructure.png
│   ├── ansible-playbook-success.png
│   ├── github-actions-success.png
│   ├── ssm-managed-node.png
│   └── live-website.png
│
├── index.html
├── .gitignore
└── README.md
```

**Note:** The Terraform and Ansible directories should be added to the GitHub repository to match this structure. Do not upload Terraform state files, private SSH keys, AWS credentials, or sensitive `.tfvars` values.

# 6. How to Run the Complete Project

### Step 1 – Provision Infrastructure

Navigate to the Terraform directory:

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

### Step 2 – Configure EC2 Using Ansible

Navigate to the Ansible directory:

```bash
cd ../ansible
```

Update the inventory with the EC2 public IP, then run:

```bash
ansible all -i inventory.ini -m ping
ansible-playbook -i inventory.ini nginx.yaml
```

### Step 3 – Push Application Code

Navigate to the project directory:

```bash
git add .
git commit -m "Update application"
git push origin main
```

### Step 4 – Automatic Deployment

GitHub Actions automatically:

1. Builds the application.
2. Runs tests.
3. Authenticates with AWS.
4. Sends an SSM deployment command.
5. Updates the website on EC2.
6. Restarts Nginx.
7. Verifies deployment status.

# 7. Project Screenshots

Add actual screenshots of your project in the `screenshots/` folder.

### Terraform Infrastructure

![Terraform Infrastructure](screenshots/terraform-infrastructure.png)

### Ansible Playbook Execution

![Ansible Playbook](screenshots/ansible-playbook-success.png)

### GitHub Actions Pipeline

![GitHub Actions](screenshots/github-actions-success.png)

### AWS Systems Manager

![SSM Managed Node](screenshots/ssm-managed-node.png)

### Live Website

![Live Website](screenshots/live-website.png)

# 8. Security Best Practices

- Store AWS credentials in GitHub Secrets.
- Never commit private SSH keys.
- Never commit Terraform state files.
- Keep SSH access restricted to trusted IP addresses.
- Use least-privilege IAM permissions.
- Use an EC2 IAM role for Systems Manager.
- Rotate long-lived AWS access keys.
- Prefer GitHub OIDC authentication when available in the AWS account.

# 9. Skills Demonstrated

Through this project, I practiced:

- AWS infrastructure provisioning.
- Infrastructure as Code using Terraform.
- Configuration management using Ansible.
- Linux server administration.
- Nginx installation and configuration.
- AWS IAM roles, users, and policies.
- AWS Systems Manager remote execution.
- Git and GitHub version control.
- GitHub Actions CI/CD automation.
- Automated application deployment.
- Troubleshooting cloud infrastructure and deployment issues.

# Author

**Muhammad Shahroz**

GitHub: https://github.com/M-shahroz227

Repository: https://github.com/M-shahroz227/cicd-project

---

*Personal hands-on DevOps project demonstrating Infrastructure as Code, Configuration Management, AWS Cloud Infrastructure, and CI/CD Automation.*
