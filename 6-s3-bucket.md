Let's get started! 🚀

## Step 1: Prepare Your Static Web App

First, let's create a simple static web application on your **local machine** (not EC2).

Create a folder called `s3-website` and inside it create a file called `index.html` with the following content:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My S3 Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #232f3e;
            color: white;
        }
        h1 { color: #ff9900; }
    </style>
</head>
<body>
    <div style="text-align:center">
        <h1>Hello from Amazon S3! 🚀</h1>
        <p>This static website is hosted on AWS S3 Bucket.</p>
    </div>
</body>
</html>
```

---

## Step 2: Create an S3 Bucket

1. Go to the **AWS Console** and search for **`S3`** in the search bar and click on it
2. Click the orange **"Create bucket"** button
3. Fill in the following:
   - **Bucket name:** `my-static-website-<yourname>` (e.g. `my-static-website-ash`) — must be **globally unique**
   - **AWS Region:** Choose the same region as your EC2 (e.g. `eu-north-1`)
   - **Object Ownership:** Select **"ACLs disabled"**
   - **Block Public Access:** **Uncheck** the **"Block all public access"** checkbox ⚠️
     - A warning will appear — check the box to **acknowledge** it
   - Everything else — leave as default

4. Click **"Create bucket"** at the bottom

---

## Step 3: Upload Your index.html File

You're already on the right page! Let's upload your file:

1. Click the orange **"Upload"** button
2. Click **"Add files"**
3. Select your **`index.html`** file from your local machine
4. Leave everything else as default
5. Click **"Upload"** at the bottom

---

## Step 4: Enable Static Website Hosting

1. Click **"Close"** to go back to your bucket
2. Click on the **"Properties"** tab
3. Scroll all the way down to **"Static website hosting"**
4. Click **"Edit"**
5. Fill in the following:
   - **Static website hosting:** Select **"Enable"**
   - **Hosting type:** Select **"Host a static website"**
   - **Index document:** `index.html`
   - **Error document:** `error.html` (optional, just type it in)
6. Click **"Save changes"**

---

## Step 5: Set a Bucket Policy for Public Access

1. Click on the **"Permissions"** tab
2. Scroll down to **"Bucket policy"**
3. Click **"Edit"**
4. Paste the following policy (replace the bucket name with yours):

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-static-website-ashish-510497447885-eu-north-1-an/*"
        }
    ]
}
```

5. Click **"Save changes"**

---

## Step 6: Access Your Live Website 🌍

1. Click on the **"Properties"** tab
2. Scroll all the way down to **"Static website hosting"**
3. You will see a **"Bucket website endpoint"** URL that looks like:
   ```
   http://my-static-website-ashish-510497447885-eu-north-1-an.s3-website.eu-north-1.amazonaws.com
   ```
4. Click on that URL or copy-paste it into your browser

---
