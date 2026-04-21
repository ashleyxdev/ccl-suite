## Step 1: Create an AWS Account (if you don't have one)

Go to [https://aws.amazon.com](https://aws.amazon.com) and click **"Create an AWS Account"**.

You'll need:
- A valid email address
- Credit/debit card (AWS has a **Free Tier** — this whole practical will cost you nothing)
- Phone number for verification

**Already have an AWS account?** Just log in to the [AWS Console](https://console.aws.amazon.com).

---

## Step 2: Launch an EC2 Instance

In the AWS Console, let's create your virtual server.

1. In the **search bar** at the top, type **`EC2`** and click on it
2. Click the orange **"Launch instance"** button
3. Fill in the following:

   - **Name:** `hello-world-server`
   - **Application and OS Image:** Select **Ubuntu** (Ubuntu Server 24.04 LTS) — it should have a "Free tier eligible" tag
   - **Instance type:** Select **t2.micro** (Free tier eligible)
   - **Key pair:** Click **"Create new key pair"**
     - Key pair name: `hello-world-key`
     - Key pair type: RSA
     - Private key format: `.pem`
     - Click **"Create key pair"** — this will **download a `.pem` file** to your computer. **Keep this safe!**
   - **Network settings:** Leave defaults, but make sure **"Allow SSH traffic from"** is checked ✅
   - Everything else — leave as default

4. Click the orange **"Launch instance"** button on the right

---

## Step 3: Connect to Your EC2 Instance via SSH

1. In the EC2 console, click on your instance ID **`i-09d6c209e36722e96`**
2. Wait until the **Instance State** shows **"Running"** and the **Status check** shows **"2/2 checks passed"**
3. Click the **"Connect"** button at the top
4. Go to the **"SSH client"** tab
5. You'll see a command that looks like this:
   ```
   ssh -i "hello-world-key.pem" ubuntu@ec2-xx-xx-xx-xx.compute.amazonaws.com
   ```

**Before running that command**, open a terminal on your computer and navigate to where your `.pem` file was downloaded (usually Downloads folder):

```bash
cd ~/Downloads
```

Then set the correct permissions on the key file:

```bash
chmod 400 hello-world-key.pem
```

Then run the **SSH command** shown in your AWS console (copy it from the SSH client tab).

---

## Step 4: Install Node.js on the Server

Run the following commands one by one:

**First, update the package list:**
```bash
sudo apt update
```

**Then install Node.js and npm:**
```bash
sudo apt install -y nodejs npm
```

**Verify the installation:**
```bash
node -v
npm -v
```

You should see version numbers printed for both.

---

## Step 5: Create the Hello World App

Now let's create a simple Node.js application that listens on port 3000.

---

## Step 6: Install Dependencies & Run the App

**Install the express package:**
```bash
npm install
```

**Then run the app:**
```bash
node app.js
```

You should see:
```
server is running on port 8080
```

---

## Step 7: Open Port 8080 in AWS Security Group

Your EC2 instance has a firewall (Security Group) that blocks all ports by default. We need to open port **8080**.

1. Go back to the **AWS Console** in your browser
2. Navigate to **EC2 → Instances** and click on your instance
3. Scroll down and click the **"Security"** tab
4. Click on the **Security Group link** (looks like `sg-xxxxxxxxxx`)
5. Click **"Edit inbound rules"**
6. Click **"Add rule"** and fill in:
   - **Type:** Custom TCP
   - **Port range:** `8080`
   - **Source:** `Anywhere-IPv4` (0.0.0.0/0)
7. Click **"Save rules"**

---

## Step 8: Test Your App in the Browser

Get your EC2 **Public IP address** from the AWS Console (click on your instance and look for **"Public IPv4 address"**).

Then open your browser and visit:
```
http://<your-public-ip>:8080
```

For example:
```
http://16.171.145.12:8080
```

You should see **"Hello World from AWS EC2!"** in the browser! 🌍

---
