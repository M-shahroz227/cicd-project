# AWS EC2 GitHub Actions CI/CD Pipeline

A hands-on DevOps project demonstrating automated CI/CD deployment of a static website to an AWS EC2 instance using **GitHub Actions and AWS Systems Manager (SSM)** — without SSH or SCP.

## Project Overview

This project automates the process of testing and deploying a website whenever code is pushed to the `main` branch.

GitHub Actions runs the build and test stages. If the tests pass, the deployment job uses AWS Systems Manager Run Command to update the website on an Amazon Linux 2023 EC2 instance.

## Architecture

```text
        Developer
            |
            | git push
            v
       GitHub Repository
            |
            v
      GitHub Actions
            |
            v
      Build Application
            |
            v
        Run Tests
            |
            v
       Configure AWS
        Credentials
            |
            v
       AWS SSM Command
            |
            v
       Amazon EC2
      (Amazon Linux 2023)
            |
            v
       Update Nginx
            |
            v
       Live Website
```

## Technologies Used

- AWS EC2
- Amazon Linux 2023
- AWS Systems Manager (SSM)
- AWS IAM
- GitHub Actions
- Git and GitHub
- Nginx
- Linux
- YAML
- Bash
- Python 3

## Project Structure

```text
cicd-project/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── deploy/
│   └── deploy.sh
│
├── tests/
│   └── test.sh
│
├── index.html
│
└── README.md
```

## CI/CD Pipeline Stages

### 1. Source Code Management
- Developer pushes code to the GitHub repository.
- GitHub Actions triggers automatically on pushes to the `main` branch.

### 2. Build Application
- GitHub Actions checks out the source code.
- Runs the build step.

### 3. Run Tests
- Executes the test script:
  `bash tests/test.sh`
- Deployment proceeds only when tests pass.

### 4. Configure AWS Credentials
- Uses GitHub repository secrets to authenticate with AWS.
- AWS credentials are configured using `aws-actions/configure-aws-credentials`.

### 5. Deploy Using AWS SSM
- Sends a remote command using AWS Systems Manager.
- No SSH or SCP connection is required.

### 6. Update Nginx Website
- Copies the updated `index.html` to the Nginx web directory.
- Restarts Nginx.
- Checks the local web server response.

### 7. Verify Deployment
- GitHub Actions checks the SSM command status.
- The workflow reports success when deployment completes.

## AWS Configuration

### EC2 Instance
- Operating System: Amazon Linux 2023
- Web Server: Nginx
- Deployment Method: AWS Systems Manager Run Command

### IAM Role for EC2

Created an EC2 IAM role with this AWS managed policy:

`AmazonSSMManagedInstanceCore`

This allows the EC2 instance to communicate with AWS Systems Manager.

### IAM User for GitHub Actions

Created a dedicated IAM user:

`github-actions-deploy`

Attached a custom IAM policy with permissions for:
- `ssm:SendCommand`
- `ssm:GetCommandInvocation`
- `ssm:ListCommandInvocations`
- `ssm:ListCommands`
- `ec2:DescribeInstances`

### GitHub Repository Secrets

Added the following secrets under:

**GitHub Repository → Settings → Secrets and variables → Actions**

| Secret Name | Purpose |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |

Never store AWS credentials directly in source code or commit them to GitHub.

## GitHub Actions Workflow

Workflow file:

`.github/workflows/ci.yml`

The pipeline contains two jobs:

1. `build-and-test`
2. `deploy`

The deployment job depends on the successful completion of the build and test job.

## How to Run This Project

Clone the repository:

```bash
git clone https://github.com/M-shahroz227/cicd-project.git
```

Enter the project directory:

```bash
cd cicd-project
```

Make your changes to `index.html`.

Add and commit changes:

```bash
git add .
git commit -m "Update website"
```

Push to GitHub:

```bash
git push origin main
```

GitHub Actions will automatically execute the CI/CD pipeline.

## Screenshots

Add your actual project screenshots in the `screenshots/` directory.

### 1. GitHub Actions Pipeline Success

![GitHub Actions Success](screenshots/github-actions-success.png)

### 2. Live Website on AWS EC2

![Live Website](screenshots/live-website.png)

### 3. AWS Systems Manager Managed Node

![SSM Managed Node](screenshots/ssm-managed-node.png)

## Security Notes

- AWS credentials are stored in GitHub Secrets.
- EC2 uses an IAM role for Systems Manager communication.
- Deployment is performed through SSM instead of SSH.
- SSH access should remain restricted to trusted IP addresses.
- Use least-privilege IAM permissions.
- Rotate long-lived access keys regularly.
- Prefer GitHub OIDC authentication when it is available in your AWS account.

## What I Learned

- Creating CI/CD pipelines using GitHub Actions.
- Automating build and test stages.
- Configuring AWS IAM users, roles, and permissions.
- Connecting GitHub Actions with AWS.
- Deploying applications using AWS Systems Manager.
- Managing Nginx on Amazon Linux 2023.
- Automating deployments without SSH or SCP.

## Author

**Muhammad Shahroz**

GitHub: https://github.com/M-shahroz227

---

*This is a hands-on personal DevOps learning project demonstrating CI/CD automation with AWS and GitHub Actions.*
