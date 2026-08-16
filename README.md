# Terraform AWS Infrastructure Automation

Infrastructure as Code (IaC) project using **Terraform** to provision
and manage AWS resources.

This repository contains two practical Terraform configurations:

1.  **TF-EC2-SSH** --- provisions an Amazon EC2 instance, creates an SSH
    key pair, configures a Security Group, and outputs the instance
    public IP.
2.  **TF-S3-web-host** --- creates an Amazon S3 bucket, uploads a static
    website, configures S3 website hosting, and outputs the website
    endpoint.

## 🚀 Projects

### 1. EC2 Provisioning with SSH

The `TF-EC2-SSH` configuration provisions:

-   Amazon EC2 instance
-   Amazon Linux 2023 AMI
-   `t3.micro` instance
-   AWS key pair
-   RSA 4096-bit private/public key
-   Local `sshkey.pem` file
-   AWS Security Group
-   Public IP output

The EC2 configuration uses the Amazon Linux 2023 SSM AMI parameter and
the AWS provider in the `ap-south-1` region.

### Architecture

``` text
Terraform
   |
   +----------------------+
   |                      |
   v                      v
EC2 Instance          Security Group
   |                  /     |      \
   |                SSH    HTTP   HTTPS
   |
   v
Public IP
   |
   v
SSH Access
```

The current configuration uses a `t3.micro` EC2 instance and associates
it with the Terraform-created Security Group. The public IP is exposed
through a Terraform output.

## 2. Static Website Hosting with Amazon S3

The `TF-S3-web-host` configuration automates static website hosting on
Amazon S3.

It creates an S3 bucket and uploads:

-   `index.html`
-   `style.css`
-   `error.html`

Terraform configures the bucket for static website hosting and exposes
the website endpoint as an output.

### Architecture

``` text
Terraform
    |
    v
S3 Bucket
    |
    +---- index.html
    +---- style.css
    +---- error.html
    |
    v
S3 Static Website Hosting
    |
    v
Website Endpoint
```

The repository's existing `readme.txt` describes the same workflow:
Terraform creates the S3 bucket, uploads the website objects, enables
public access, and outputs the website address.

## 🛠️ Technologies

-   Terraform
-   AWS
-   Amazon EC2
-   Amazon S3
-   AWS Security Groups
-   AWS Key Pair
-   Amazon Linux 2023
-   Terraform AWS Provider
-   Terraform TLS Provider
-   Terraform Local File Provider

## 📁 Repository Structure

``` text
terraform/
│
├── TF-EC2-SSH/
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
│
└── TF-S3-web-host/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf
    ├── index.html
    ├── style.css
    ├── error.html
    ├── readme.txt
    ├── terraform.tfstate
    └── terraform.tfstate.backup
```

## ⚙️ Prerequisites

Install and configure:

-   Terraform
-   AWS CLI
-   An AWS account
-   AWS credentials with permission to create the required resources

Verify Terraform:

``` bash
terraform version
```

Verify AWS configuration:

``` bash
aws sts get-caller-identity
```

## 🔑 AWS Configuration

The configurations currently use the AWS region:

``` text
ap-south-1
```

Configure your AWS credentials before running Terraform.

For example:

``` bash
aws configure
```

> Never commit AWS access keys, secret keys, passwords, or other
> credentials to GitHub.

## ▶️ Deploy EC2 Infrastructure

Move into the EC2 configuration:

``` bash
cd TF-EC2-SSH
```

Initialize Terraform:

``` bash
terraform init
```

Review the execution plan:

``` bash
terraform plan
```

Create the infrastructure:

``` bash
terraform apply
```

Confirm the deployment when prompted.

### Get the EC2 Public IP

``` bash
terraform output instance_ip
```

The output returns the public IP address of the EC2 instance.

## 🔐 SSH Access

The configuration creates an RSA 4096-bit key and writes the private key
to:

``` text
sshkey.pem
```

On Linux/macOS, set the required permission:

``` bash
chmod 400 sshkey.pem
```

Then connect using:

``` bash
ssh -i sshkey.pem ec2-user@<EC2_PUBLIC_IP>
```

The exact SSH username depends on the AMI being used.

## 🌐 Deploy the S3 Static Website

Move into the S3 configuration:

``` bash
cd TF-S3-web-host
```

Initialize Terraform:

``` bash
terraform init
```

Review the plan:

``` bash
terraform plan
```

Create the S3 website:

``` bash
terraform apply
```

Terraform uploads the website files automatically.

### Get Website Information

Get the bucket name:

``` bash
terraform output bucket_name
```

Get the bucket ARN:

``` bash
terraform output bucket_arn
```

Get the website endpoint:

``` bash
terraform output bucket_website_endpoint
```

The generated endpoint follows the S3 website endpoint format for the
configured AWS region.

## 📦 S3 Website Files

Terraform uploads the following files:

``` text
index.html
style.css
error.html
```

The website configuration uses:

``` text
Index document: index.html
Error document: error.html
```

## 🔒 Security Considerations

### EC2

The current Security Group allows:

    Port Protocol   Purpose
  ------ ---------- ---------
      22 TCP        SSH
      80 TCP        HTTP
     443 TCP        HTTPS

The current configuration permits these inbound rules from `0.0.0.0/0`
and IPv6 `::/0`.

For production, restrict SSH access to trusted IP ranges rather than
exposing port 22 globally.

### S3

The current S3 configuration intentionally enables public access and
`public-read` ACLs for static website hosting.

This is suitable for demonstrating public S3 website hosting, but for
modern production architectures consider private S3 storage with
**Amazon CloudFront** and an appropriate origin access configuration.

## 🧹 Destroy Infrastructure

When the resources are no longer needed, destroy them to avoid
unnecessary AWS charges.

For EC2:

``` bash
cd TF-EC2-SSH
terraform destroy
```

For S3:

``` bash
cd TF-S3-web-host
terraform destroy
```

Make sure the S3 bucket is empty before destroying it if Terraform
cannot remove its objects automatically.

## 📊 Terraform Workflow

``` text
Write Terraform Configuration
          ↓
      terraform init
          ↓
      terraform plan
          ↓
     Review Changes
          ↓
     terraform apply
          ↓
   AWS Resources Created
          ↓
    terraform output
          ↓
     Use Resources
          ↓
    terraform destroy
```

## 🎯 Key Learning Outcomes

This project demonstrates practical experience with:

-   Infrastructure as Code
-   Terraform configuration and state
-   AWS provider configuration
-   EC2 provisioning
-   SSH key generation
-   Security Group configuration
-   Terraform outputs
-   S3 bucket provisioning
-   S3 object uploads
-   Static website hosting
-   AWS resource lifecycle management

## 🔮 Possible Improvements

The project can be improved by:

-   Replacing hard-coded VPC IDs with data sources or variables.
-   Moving bucket names and instance configuration into variables.
-   Using reusable Terraform modules.
-   Adding separate `dev`, `staging`, and `prod` environments.
-   Storing Terraform state remotely using an S3 backend.
-   Adding state locking where appropriate.
-   Adding `.gitignore` for Terraform state and generated private keys.
-   Avoiding public SSH access in production.
-   Using IAM roles instead of long-lived AWS credentials.
-   Migrating public S3 websites to CloudFront with a private S3 origin.
-   Adding `terraform fmt` and `terraform validate` checks.
-   Adding CI validation through GitHub Actions or Jenkins.

## ⚠️ Repository Security Note

The repository currently contains Terraform state files in the project
directories.

Terraform state can contain sensitive infrastructure information. For a
production-quality repository, remove state files from Git tracking and
add entries such as:

``` gitignore
.terraform/
*.tfstate
*.tfstate.*
*.pem
*.tfvars
*.tfvars.json
```

Do not commit generated private keys or credentials.

## 👨‍💻 Author

**Subasangeeth C**

GitHub: https://github.com/subasangeeth

## 🔗 Repository

https://github.com/subasangeeth/terraform

------------------------------------------------------------------------

⭐ If you find this project useful, consider giving the repository a
star.
