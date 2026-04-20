# Deploy a Static Website Using Docker

## Aim
To deploy a static website using Docker by creating a Docker image and running it inside a container.

## Prerequisites
- Windows 10/11 (64-bit)
- Internet connection
- A web browser

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Docker Desktop | Run and manage Docker containers on Windows |
| Nginx | Lightweight web server used inside the container to serve static files |
| PowerShell | Command line interface to run Docker commands |

---

## Project Structure

```
docker-static-website/
├── index.html       # Static web page
└── Dockerfile       # Blueprint to build the Docker image
```

---

## Step-by-Step Guide

### Step 1: Install Docker Desktop on Windows

1. Go to [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Click **"Download for Windows"**
3. Run the downloaded installer **Docker Desktop Installer.exe**
4. During installation:
   - Make sure **"Use WSL 2 instead of Hyper-V"** is checked
   - Click **Ok** and let the installation complete
5. **Restart your computer** when prompted
6. After restart, Docker Desktop will launch automatically
7. Accept the Docker Subscription Service Agreement

**Verify installation** — open PowerShell and run:
```powershell
docker --version
```

Expected output:
```
Docker version 29.x.x, build xxxxxxx
```

> **Note:** Docker Desktop requires Windows 10/11 (64-bit) with WSL 2 enabled. If WSL 2 is not installed, the Docker installer will guide you through installing it.

---

### Step 2: Create the Project Folder and Files

Open **PowerShell** and run:

```powershell
mkdir docker-static-website
cd docker-static-website
```

Create the `index.html` file:

```powershell
New-Item index.html
notepad index.html
```

Paste the following content into Notepad and save with `Ctrl + S`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker Static Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #0db7ed;
            color: white;
            text-align: center;
        }
        h1 { font-size: 3rem; }
        p  { font-size: 1.2rem; }
    </style>
</head>
<body>
    <div>
        <h1>🐳 Hello from Docker!</h1>
        <p>This static website is running inside a Docker container.</p>
    </div>
</body>
</html>
```

---

### Step 3: Create the Dockerfile

In the same PowerShell window, run:

```powershell
New-Item Dockerfile
notepad Dockerfile
```

Paste the following content into Notepad and save with `Ctrl + S`:

```dockerfile
# Use official Nginx image as base
FROM nginx:alpine

# Copy our static website files to Nginx's default serving directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
```

**Verify your project structure:**
```powershell
ls
```

Expected output:
```
Dockerfile
index.html
```

**What each line in the Dockerfile does:**

| Line | Explanation |
|------|-------------|
| `FROM nginx:alpine` | Uses the lightweight Nginx web server as the base image |
| `COPY index.html ...` | Copies our `index.html` into the container's web root |
| `EXPOSE 80` | Tells Docker the container will listen on port 80 |

---

### Step 4: Build the Docker Image

```powershell
docker build -t static-website .
```

Expected output:
```
[+] Building 5.2s (7/7) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load metadata for docker.io/library/nginx:alpine
 => [1/2] FROM docker.io/library/nginx:alpine
 => [2/2] COPY index.html /usr/share/nginx/html/index.html
 => exporting to image
 => => naming to docker.io/library/static-website
```

**Verify the image was created:**
```powershell
docker images
```

You should see `static-website` listed with a recent timestamp.

**What the flags mean:**

| Flag/Argument | Meaning |
|---------------|---------|
| `docker build` | Builds the image from our Dockerfile |
| `-t static-website` | Tags/names the image as `static-website` |
| `.` | Tells Docker to look for the Dockerfile in the current folder |

---

### Step 5: Run the Docker Container

```powershell
docker run -d -p 8080:80 --name my-static-website static-website
```

**Verify the container is running:**
```powershell
docker ps
```

Expected output:
```
CONTAINER ID   IMAGE            COMMAND                  STATUS          PORTS                    NAMES
0e521b1dc8f4   static-website   "/docker-entrypoint.…"  Up 47 seconds   0.0.0.0:8080->80/tcp     my-static-website
```

**What the flags mean:**

| Flag/Argument | Meaning |
|---------------|---------|
| `docker run` | Creates and starts a container from the image |
| `-d` | Runs the container in the background (detached mode) |
| `-p 8080:80` | Maps port **8080** on your machine to port **80** inside the container |
| `--name my-static-website` | Gives the container a friendly name |
| `static-website` | The image to use |

---

### Step 6: Test in the Browser

Open your web browser and visit:
```
http://localhost:8080
```

You should see the page:

> **🐳 Hello from Docker!**
> This static website is running inside a Docker container.

---

## Challenges Faced & Fixes

### Challenge 1: Docker build command fails with pipe error

**Error:**
```
ERROR: error during connect: Head "http://%2F%2F.%2Fpipe%2FdockerDesktopLinuxEngine/_ping":
open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```

**Cause:**
Docker Desktop was not running when the `docker build` command was executed.

**Fix:**
1. Press the **Windows key** and search for **"Docker Desktop"**
2. Click on it to open and launch Docker Desktop
3. Wait for it to fully start — look for the **Docker whale icon** in the taskbar (bottom right system tray)
4. Wait until it shows **"Docker Desktop is running"** (the whale icon stops animating) — this takes 30–60 seconds
5. Once Docker Desktop is running, re-run the build command:
   ```powershell
   docker build -t static-website .
   ```

> **Tip:** Always make sure Docker Desktop is running before executing any Docker commands.

---

## Key Concepts

| Concept | Description |
|---------|-------------|
| **Dockerfile** | A blueprint/recipe to build a Docker image |
| **Image** | A packaged snapshot of your app and its dependencies |
| **Container** | A running instance of an image |
| **Port Mapping `-p 8080:80`** | Maps host port 8080 to container port 80 |
| **Nginx** | A lightweight web server used to serve static files inside the container |
| **Alpine** | A minimal Linux distribution used to keep the image size small |

---

## Useful Docker Commands

| Command | What it does |
|---------|-------------|
| `docker ps` | List all running containers |
| `docker ps -a` | List all containers including stopped ones |
| `docker stop my-static-website` | Stop the running container |
| `docker start my-static-website` | Start the container again |
| `docker rm my-static-website` | Delete the container |
| `docker rmi static-website` | Delete the image |
| `docker logs my-static-website` | View container logs |
| `docker images` | List all Docker images on your machine |

---

## Comparison: Docker vs Traditional Deployment

| | Traditional | Docker |
|--|-------------|--------|
| **Setup** | Install dependencies manually on each machine | Everything packaged in an image |
| **Consistency** | Works on one machine, may fail on another | Works the same everywhere |
| **Isolation** | Shares OS resources | Runs in isolated container |
| **Portability** | Hard to move between environments | Run anywhere Docker is installed |
| **Cleanup** | Manual uninstall of dependencies | Just delete the container and image |
