## Step 1: Install Terraform on Your Local Machine

Open your **local terminal** and run the following commands:

**Command 1:**
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

**Command 2:**
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

**Command 3:**
```bash
sudo apt update && sudo apt install terraform -y
```

**Verify installation:**
```bash
terraform -v
```

---

Terraform v1.14.9 is installed successfully! ✅

## Step 2: Set Up AWS CLI & Credentials

Terraform needs AWS credentials to create resources. Let's set that up.

**First, install AWS CLI:**
```bash
sudo apt install awscli -y
```

**Verify:**
```bash
aws --version
```

**Then configure your AWS credentials:**
```bash
aws configure
```

It will ask you 4 things:
```
AWS Access Key ID: <your access key>
AWS Secret Access Key: <your secret key>
Default region name: eu-north-1
Default output format: json
```

### To get your Access Key & Secret Key:
1. Go to **AWS Console**
2. Click on your **account name** (top right)
3. Click **"Security credentials"**
4. Scroll down to **"Access keys"**
5. Click **"Create access key"**
6. Select **"CLI"** → check acknowledgement → click **"Next"** → **"Create access key"**
7. **Copy both the Access Key and Secret Access Key** — you won't see the secret again!

---

## Step 3: Create the Terraform Project Structure

Let's create a project folder with the required files:

```bash
mkdir terraform-ec2 && cd terraform-ec2
```

Now create the following **4 files** inside this folder:

```bash
touch main.tf variables.tf terraform.tfvars outputs.tf
```

Verify the files are created:
```bash
ls
```

You should see:
```
main.tf  outputs.tf  terraform.tfvars  variables.tf
```

---

### Here's what each file does:
| File | Purpose |
|------|---------|
| `main.tf` | Main configuration — defines the EC2 resource |
| `variables.tf` | Declares input variables |
| `terraform.tfvars` | Assigns values to the input variables |
| `outputs.tf` | Defines output variables (e.g. public IP) |

---
Perfect! 🎉 Let's fill in the files one by one.

## Step 4: Write `variables.tf`

Open the file:
```bash
nano variables.tf
```

Paste the following content:
```hcl
variable "aws_region" {
  description = "AWS region to deploy the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}
```

Save and exit:
- Press `Ctrl + X` → `Y` → `Enter`

---

## Step 5: Write `terraform.tfvars`

Open the file:
```bash
nano terraform.tfvars
```

Paste the following content:
```hcl
aws_region    = "eu-north-1"
ami_id        = "ami-0c1ac8728ef7f7ddc"
instance_type = "t3.micro"
instance_name = "terraform-ec2-instance"
```

Save and exit:
- Press `Ctrl + X` → `Y` → `Enter`

> 💡 **Note:** The `ami_id` above is a valid **Ubuntu 24.04 LTS** AMI for `eu-north-1` region. If you're using a different region, the AMI ID will be different.

---

## Step 6: Write `main.tf`

Open the file:
```bash
nano main.tf
```

Paste the following content:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

Save and exit:
- Press `Ctrl + X` → `Y` → `Enter`

---

## Step 7: Write `outputs.tf`

Open the file:
```bash
nano outputs.tf
```

Paste the following content:
```hcl
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.my_ec2.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.my_ec2.public_ip
}

output "instance_state" {
  description = "The state of the EC2 instance"
  value       = aws_instance.my_ec2.instance_state
}
```

Save and exit:
- Press `Ctrl + X` → `Y` → `Enter`

---

## Step 8: Initialize Terraform

Now let's run the Terraform commands! First, initialize the project:

```bash
terraform init
```

This will:
- Download the **AWS provider plugin**
- Set up the **backend**
- Create a `.terraform` folder

You should see something like:
```
Terraform has been successfully initialized!
```

---

## Step 9: Validate & Plan

First let's **validate** the configuration files for any syntax errors:

```bash
terraform validate
```

You should see:
```
Success! The configuration is valid.
```

Then run **plan** to preview what Terraform will create:

```bash
terraform plan
```

This will show you a detailed preview of the EC2 instance that will be created — without actually creating it yet.

Look for this at the end:
```
Plan: 1 to add, 0 to change, 0 to destroy.
```

---

## Step 10: Apply the Terraform Configuration

Now let's actually **create the EC2 instance** on AWS!

```bash
terraform apply
```

Terraform will show the plan again and ask for confirmation. Type **`yes`** and press Enter:

```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

Wait for it to complete — it usually takes **30-60 seconds**.

You should see at the end:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Along with the **output values** — instance ID, public IP and state!

---

If the AMI ID doesn't exist in your region. Let's find the correct one!

## Fix: Get the Correct AMI ID

1. Go to **AWS Console**
2. Search for **EC2** and click on it
3. Click **"Launch instance"** (don't worry, we won't actually launch it)
4. Under **"Application and OS Images"** section
5. Select **Ubuntu** → **Ubuntu Server 24.04 LTS**
6. You will see the **AMI ID** on the right side — it looks like `ami-xxxxxxxxxx`
7. **Copy that AMI ID**

Then update your `terraform.tfvars`:
```bash
nano terraform.tfvars
```

Replace the `ami_id` value with the correct one:
```hcl
aws_region    = "eu-north-1"
ami_id        = "ami-xxxxxxxxxx"
instance_type = "t3.micro"
instance_name = "terraform-ec2-instance"
```

Save and exit: `Ctrl + X` → `Y` → `Enter`

---