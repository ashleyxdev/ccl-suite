## Step 1: Install Ansible on Your Local Machine

Open your **local terminal** and run:

**Add the Ansible repository:**
```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
```

**Install Ansible:**
```bash
sudo apt install -y ansible
```

**Verify installation:**
```bash
ansible --version
```

You should see something like:
```
ansible [core 2.x.x]
```

OR

```bash
pip install ansible
```

If you get an error about `externally managed environment`, run:
```bash
pip install ansible --break-system-packages
```

**Verify installation:**
```bash
ansible --version
```

---

## Step 2: Launch a New EC2 Instance

1. Go to **AWS Console → EC2 → Launch instance**
2. Fill in the following:
   - **Name:** `ansible-target-server`
   - **OS:** Ubuntu Server 24.04 LTS (Free tier eligible)
   - **Instance type:** `t2.micro` or `t3.micro`
   - **Key pair:** Select the existing **`hello-world-key`** (reuse the same .pem file)
   - **Network settings:** Make sure **"Allow SSH traffic from"** is checked ✅
3. Click **"Launch instance"**

Wait for the instance to show **"Running"** state and note down the **Public IPv4 address**.

---

## Step 3: Create the Ansible Inventory File

The inventory file tells Ansible **which servers to target**.

Make sure you're in the ansible-nginx folder:
```bash
cd ~/clg/ccl/ansible-nginx
```

Create the inventory file:
```bash
nano inventory.ini
```

Paste the following:
```ini
[webservers]
<Public IPv4 addr> ansible_user=ubuntu ansible_ssh_private_key_file=<path/to/key.pem> ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

Save and exit:
- Press `Ctrl + X` → `Y` → `Enter`

---

**Test the connection:**
```bash
ansible -i inventory.ini webservers -m ping
```

You should see:
```
13.62.76.207 | SUCCESS => {
    "ping": "pong"
}
```

## Step 4: Write the Ansible Playbook

Now let's create the main playbook file:

```bash
nano playbook.yml
```

Paste the following:
```yaml
---
- name: Install and Configure Nginx
  hosts: webservers
  become: yes

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Start and enable Nginx service
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Create a custom index.html
      copy:
        content: |
          <html>
            <body>
              <h1>Hello from Ansible + Nginx! 🚀</h1>
              <p>This server was configured using an Ansible Playbook.</p>
            </body>
          </html>
        dest: /var/www/html/index.html
```

Save and exit:
- Press `Ctrl + X` → `Y` → `Enter`

---

## Step 5: Run the Ansible Playbook

Now let's execute the playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

You should see each task executing one by one:
```
PLAY [Install and Configure Nginx] ******************************

TASK [Gathering Facts] ******************************************
ok: [13.62.76.207]

TASK [Update apt cache] *****************************************
changed: [13.62.76.207]

TASK [Install Nginx] ********************************************
changed: [13.62.76.207]

TASK [Start and enable Nginx service] ***************************
ok: [13.62.76.207]

TASK [Create a custom index.html] *******************************
changed: [13.62.76.207]

PLAY RECAP ******************************************************
13.62.76.207 : ok=5 changed=3 unreachable=0 failed=0
```

---

## Step 6: Open Port 80 & Test in Browser

We need to open **port 80** (HTTP) in the AWS Security Group:

1. Go to **AWS Console → EC2 → Instances**
2. Click on `ansible-target-server`
3. Click **"Security"** tab → click the **Security Group**
4. Click **"Edit inbound rules"** → **"Add rule"**
   - **Type:** HTTP
   - **Port:** `80`
   - **Source:** `Anywhere-IPv4` (0.0.0.0/0)
5. Click **"Save rules"**

Then open your browser and visit:
```
http://13.62.76.207
```

You should see **"Hello from Ansible + Nginx! 🚀"**

---