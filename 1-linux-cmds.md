# Linux Commands for Cloud & DevOps — Practical Execution Sheet

**Subject:** Cloud Computing Lab
**Environment:** Ubuntu (WSL / Cloud VM)
**Practical Title:** Linux Commands for Cloud & DevOps

---

## Step 1 — System Orientation

```bash
whoami
hostname
uname -a
cat /etc/os-release
date
uptime
```

**Why this step?**
The first thing you do on any Linux system is confirm the environment — who you are logged in as, what machine you are on, and which OS is running. This is the standard starting point on any cloud VM (AWS EC2, Azure VM, etc.) and shows the examiner that you follow a logical, professional sequence rather than running random commands.

**Concept demonstrated:** System awareness, cloud VM baseline check.

---

## Step 2 — Hardware & Resource Check

```bash
nproc
free -h
df -h
lsblk
```

**Why this step?**
Before doing any work, check the available compute and storage resources. `free -h` shows RAM usage in human-readable form. `df -h` shows disk space. `lsblk` lists attached storage devices. The `-h` flag (human-readable) is a best practice that makes output readable at a glance.

**Concept demonstrated:** Resource monitoring, capacity awareness.

---

## Step 3 — User Management

```bash
sudo useradd -m clouduser
sudo passwd clouduser
sudo usermod -aG sudo clouduser
groups clouduser
id clouduser
```

**Why this step?**
Linux multi-user management is a core cloud concept. Creating a user with `-m` creates their home directory. Adding them to the `sudo` group gives controlled administrative access. Verifying with `groups` and `id` confirms the changes took effect.

**Concept demonstrated:** User administration, access control.

---

## Step 4 — File System & Directory Structure

```bash
mkdir -p cloudlab/scripts
mkdir -p cloudlab/logs
mkdir -p cloudlab/configs
ls -l cloudlab/
touch cloudlab/configs/app.conf
ls -la cloudlab/configs/
```

**Why this step?**
Organizing work into a structured directory is a professional habit. The `-p` flag with `mkdir` creates nested directories in one command. This mirrors how real-world DevOps projects are organized on servers before deployment.

**Concept demonstrated:** Directory management, workspace organization.

---

## Step 5 — File Permissions

```bash
chmod 755 cloudlab/scripts/
chmod 644 cloudlab/configs/app.conf
ls -l cloudlab/
ls -l cloudlab/configs/
```

**Why this step?**
Linux file permissions control who can read, write, and execute files. `755` means the owner can read/write/execute; others can read/execute — suitable for a scripts directory. `644` means the owner can read/write; others can only read — suitable for config files.

**Permission reference:**

| Octet | Meaning         |
|-------|-----------------|
| 7     | read+write+exec |
| 5     | read+exec       |
| 4     | read only       |

**Concept demonstrated:** File permissions, security hardening.

---

## Step 6 — Package Management

```bash
sudo apt update
sudo apt install curl wget git tree -y
git --version
curl --version
tree cloudlab/
```

**Why this step?**
`apt update` refreshes the package index — always required before installing anything on a fresh system. Installing `curl`, `wget`, and `git` sets up the basic tools needed for any development or DevOps workflow. Verifying with `--version` confirms successful installation.

**Concept demonstrated:** Package lifecycle management, software installation.

---

## Step 7 — Working with Files

```bash
echo "Cloud Computing Practical" > cloudlab/configs/app.conf
cat cloudlab/configs/app.conf
cp cloudlab/configs/app.conf cloudlab/configs/app_backup.conf
mv cloudlab/configs/app_backup.conf cloudlab/backups/app_backup.conf 2>/dev/null || (mkdir -p cloudlab/backups && mv cloudlab/configs/app_backup.conf cloudlab/backups/)
ls cloudlab/backups/
rm cloudlab/backups/app_backup.conf
ls cloudlab/backups/
```

**Why this step?**
`echo` writes content to a file. `cat` reads it. `cp` copies and `mv` moves files. `rm` deletes. These are the most fundamental file operations in Linux and form the backbone of any server-side workflow.

**Concept demonstrated:** File creation, copying, moving, and deletion.

---

## Step 8 — Shell Scripting

```bash
cat > cloudlab/scripts/sysinfo.sh << 'EOF'
#!/bin/bash
echo "===== System Report ====="
echo "Hostname : $(hostname)"
echo "User     : $(whoami)"
echo "Date     : $(date)"
echo "RAM Free : $(free -h | awk '/^Mem/{print $4}')"
echo "Disk Use : $(df -h / | awk 'NR==2{print $5}')"
echo "========================="
EOF

chmod +x cloudlab/scripts/sysinfo.sh
bash cloudlab/scripts/sysinfo.sh
```

**Why this step?**
A shell script automates a sequence of commands. The `#!/bin/bash` shebang tells the system which interpreter to use. `chmod +x` makes it executable. This script collects system information in one run — replacing the need to type each command individually.

**Concept demonstrated:** Shell scripting, automation basics, shebang line.

---

## Step 9 — Process Management

```bash
sleep 200 &
jobs
ps aux | grep sleep
ps -e | head -15
kill %1
jobs
```

**Why this step?**
The `&` symbol runs a process in the background. `jobs` lists background jobs. `ps aux` shows all running processes with their details. `kill %1` terminates the first background job by job number. Understanding process control is essential for managing services on a server.

**Concept demonstrated:** Background processes, job control, process inspection.

---

## Step 10 — Networking Basics

```bash
ip addr show
ping -c 4 google.com
curl http://example.com -I
ifconfig
netstat -tuln
```

**Why this step?**
`ip addr show` displays the machine's IP addresses. `ping` tests basic internet connectivity. `curl -I` fetches just the HTTP headers — useful for testing if a web server is reachable. `netstat -tuln` lists all open ports and listening services.

**Concept demonstrated:** Network diagnostics, connectivity testing, port inspection.

---

## Step 11 — Searching & Filtering Text

```bash
grep "hostname" cloudlab/scripts/sysinfo.sh
grep -i "user" cloudlab/scripts/sysinfo.sh
find cloudlab/ -name "*.sh"
find cloudlab/ -type f
wc -l cloudlab/scripts/sysinfo.sh
```

**Why this step?**
`grep` searches for patterns within files — used heavily for log analysis and config inspection. `find` locates files by name or type. `wc -l` counts lines. These tools are used daily in cloud environments for searching through logs and configuration files.

**Concept demonstrated:** Text search, file search, basic log analysis.

---

## Step 12 — Archiving & Compression

```bash
tar -czvf cloudlab_backup.tar.gz cloudlab/
ls -lh cloudlab_backup.tar.gz
tar -tzvf cloudlab_backup.tar.gz
tar -xzvf cloudlab_backup.tar.gz -C /tmp/
ls /tmp/cloudlab/
```

**Why this step?**
`tar -czvf` creates a compressed archive. `-c` creates, `-z` uses gzip compression, `-v` shows verbose output, `-f` specifies the filename. `-t` lists the archive contents without extracting. `-x` extracts. Archiving is used for backups and transferring files between servers.

**tar flag reference:**

| Flag | Meaning  |
|------|----------|
| -c   | Create   |
| -x   | Extract  |
| -z   | Gzip     |
| -v   | Verbose  |
| -f   | Filename |
| -t   | List     |

**Concept demonstrated:** File archiving, compression, backup creation.

---

## Step 13 — Environment Variables

```bash
export APP_NAME="CloudLab"
export APP_PORT=3000
echo $APP_NAME
echo $APP_PORT
env | grep APP
printenv APP_NAME
```

**Why this step?**
Environment variables store configuration values that programs can read at runtime. `export` makes a variable available to child processes. `env` lists all current environment variables. In cloud deployments, app settings like database URLs and port numbers are passed as environment variables rather than hardcoded in files.

**Concept demonstrated:** Environment variables, runtime configuration.

---

## Step 14 — System Logs

```bash
sudo cat /var/log/syslog | tail -20
sudo cat /var/log/auth.log | tail -10
dmesg | tail -15
```

**Why this step?**
`/var/log/syslog` is the main system log on Ubuntu. `/var/log/auth.log` records login attempts and authentication events. `dmesg` shows kernel ring buffer messages — useful for hardware-level diagnostics. Reading logs is the first step in any troubleshooting workflow on a cloud server.

**Concept demonstrated:** Log files, system monitoring, troubleshooting.

---

## Step 15 — Wrap-up & Review

```bash
tree cloudlab/
ls -la cloudlab/
history | tail -20
echo "Practical completed successfully."
```

**Why this step?**
`tree` gives a visual overview of all files and directories created during the practical — a clean summary for the examiner. `history` shows the commands executed in this session, demonstrating a clean, intentional workflow. This is the professional way to conclude a practical session.

**Concept demonstrated:** Session review, workspace verification, professional wrap-up.

---

## Summary of Commands Covered

| Area                  | Key Commands Used                          |
|-----------------------|--------------------------------------------|
| System Info           | `whoami`, `hostname`, `uname`, `uptime`    |
| Resources             | `free`, `df`, `lsblk`, `nproc`            |
| Users                 | `useradd`, `passwd`, `usermod`, `groups`   |
| Files & Dirs          | `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` |
| Permissions           | `chmod`, `ls -l`                           |
| Packages              | `apt update`, `apt install`               |
| Scripting             | `bash`, `chmod +x`, heredoc               |
| Processes             | `ps`, `kill`, `jobs`, `sleep &`            |
| Networking            | `ip addr`, `ping`, `curl`, `netstat`       |
| Search & Filter       | `grep`, `find`, `wc`                       |
| Archiving             | `tar`, `gzip`                              |
| Environment Variables | `export`, `env`, `printenv`                |
| Logs                  | `syslog`, `auth.log`, `dmesg`              |

---

*Practical executed on Ubuntu (WSL / Cloud VM) — Cloud Computing Lab, TE IT Sem VI*
