# Day 07 - Linux Automation Project

## Project Objective

The objective of this project is to automate common Linux administration tasks using Bash scripting. The project includes:

* Log backup automation
* System monitoring
* Cleanup of old backups
* Task scheduling using Cron

---

# Project Structure

```bash
linux-automation-project/
│
├── backup.sh
├── monitor.sh
├── cleanup.sh
├── backups/
├── logs/
└── README.md
```

---

# Step 1: Create Project Directory

## Command

```bash
mkdir -p ~/linux-automation-project/{backups,logs}
```

## Explanation

### mkdir

`mkdir` stands for **Make Directory**.

It is used to create folders in Linux.

Example:

```bash
mkdir test
```

Creates:

```text
test/
```

### -p

The `-p` option creates parent directories if they do not already exist.

Example:

```bash
mkdir -p project/test/demo
```

This creates all directories automatically.

### ~

The `~` symbol represents the current user's home directory.

Example:

```bash
echo ~
```

Output:

```text
/home/ubuntu
```

### {backups,logs}

This is called **Brace Expansion**.

Instead of creating directories one by one:

```bash
mkdir backups
mkdir logs
```

Linux creates both directories with a single command.

---

# Verify Directory Structure

## Command

```bash
tree ~/linux-automation-project
```

## Explanation

The `tree` command displays folders and files in a hierarchical structure.

Example Output:

```text
linux-automation-project
├── backups
└── logs
```

### Why is it useful?

DevOps engineers use `tree` to quickly understand project structures.

---

# Step 2: Explore Linux Logs

## Command

```bash
ls /var/log
```

## Explanation

### ls

`ls` stands for **List**.

It displays files and directories.

Example:

```bash
ls
```

Output:

```text
Documents
Downloads
file.txt
```

### /var/log

Linux stores system logs in `/var/log`.

Logs contain information about:

* User logins
* Service status
* Errors
* Security events
* System messages

### Common Log Files

#### auth.log

Stores authentication-related information.

Examples:

* SSH Login
* Failed Login Attempts
* User Authentication

#### syslog

Stores general system messages.

#### kern.log

Stores Linux Kernel messages.

### Why Logs Matter

Logs are the first place DevOps engineers check during troubleshooting.

---

# Step 3: Create Backup Script

## Create File

```bash
nano backup.sh
```

## Script

```bash
#!/bin/bash

DATE=$(date +%F)

tar -czf backups/log_backup_$DATE.tar.gz /var/log

echo "Backup created successfully"
```

---

# Script Explanation

## Shebang

```bash
#!/bin/bash
```

This tells Linux to execute the script using the Bash shell.

Without this line, Linux may not know which interpreter should run the script.

---

## Variable

```bash
DATE=$(date +%F)
```

A variable stores information.

The `date +%F` command returns:

```text
YYYY-MM-DD
```

Example:

```text
2026-06-08
```

The result is stored inside the variable `DATE`.

---

## Command Substitution

```bash
$(date +%F)
```

This executes a command and stores its output.

Example:

```bash
echo $(date)
```

Output:

```text
Mon Jun 08 2026
```

---

## tar Command

```bash
tar -czf backups/log_backup_$DATE.tar.gz /var/log
```

### What is tar?

`tar` is a Linux archiving utility.

It combines multiple files into a single archive.

### Options Used

#### -c

Create a new archive.

#### -z

Compress using gzip.

#### -f

Specify archive filename.

### Result

```text
log_backup_2026-06-08.tar.gz
```

---

## echo Command

```bash
echo "Backup created successfully"
```

Displays text on the terminal.

Example:

```bash
echo Hello
```

Output:

```text
Hello
```

Used to provide status messages to users.

---

# Step 4: File Permissions

## Check Permissions

```bash
ls -l
```

Example Output:

```text
-rw-r--r-- backup.sh
```

### Permission Breakdown

```text
-rw-r--r--
```

#### Owner

```text
rw-
```

Read and Write permission.

#### Group

```text
r--
```

Read permission only.

#### Others

```text
r--
```

Read permission only.

---

## Make Script Executable

```bash
chmod +x backup.sh
```

### chmod

`chmod` stands for Change Mode.

Used to modify file permissions.

### +x

Adds Execute permission.

Without execute permission:

```bash
./backup.sh
```

Will return:

```text
Permission denied
```

---

# Step 5: Run the Script

## Command

```bash
./backup.sh
```

### Why ./ ?

`.` represents the current directory.

Linux does not automatically search the current directory for executable files.

Therefore:

```bash
./backup.sh
```

Means:

```text
Execute backup.sh from the current directory.
```

---

# Step 6: Create Monitoring Script

## Create File

```bash
nano monitor.sh
```

## Script

```bash
#!/bin/bash

echo "===== SYSTEM REPORT ====="

echo "Date:"
date

echo ""

echo "CPU Load:"
uptime

echo ""

echo "Memory Usage:"
free -h

echo ""

echo "Disk Usage:"
df -h
```

---

# Monitoring Commands

## uptime

```bash
uptime
```

Shows system load average.

Example:

```text
load average: 0.20, 0.25, 0.30
```

### Why Use It?

Indicates CPU workload.

Lower values indicate lower system load.

---

## free -h

```bash
free -h
```

Displays memory usage.

Example:

```text
Mem: 8Gi
Used: 2Gi
Free: 6Gi
```

### -h

Human-readable format.

Displays values in MB or GB instead of bytes.

---

## df -h

```bash
df -h
```

Displays disk space information.

Shows:

* Total Space
* Used Space
* Available Space

### Why Use It?

Prevents servers from running out of storage.

---

# Step 7: Cleanup Script

## Create File

```bash
nano cleanup.sh
```

## Script

```bash
#!/bin/bash

find backups/ -type f -mtime +7 -delete

echo "Old backups deleted"
```

---

# Understanding find Command

## find

Searches for files and directories.

## -type f

Search only files.

## -mtime +7

Files older than 7 days.

## -delete

Delete matching files.

### Why Use It?

Prevents old backups from filling the disk.

---

# Step 8: Cron Job Automation

## Open Cron Editor

```bash
crontab -e
```

### What is Cron?

Cron is a Linux task scheduler.

It automatically executes commands at scheduled times.

---

## Schedule Tasks

```bash
0 1 * * * /home/ubuntu/linux-automation-project/backup.sh

0 2 * * * /home/ubuntu/linux-automation-project/monitor.sh

0 3 * * * /home/ubuntu/linux-automation-project/cleanup.sh
```

---

# Cron Format

```text
* * * * *
│ │ │ │ │
│ │ │ │ └── Day of Week
│ │ │ └──── Month
│ │ └────── Day of Month
│ └──────── Hour
└────────── Minute
```

Example:

```text
0 1 * * *
```

Means:

```text
Run at 1:00 AM every day.
```

---

# Verify Cron Jobs

```bash
crontab -l
```

Displays all scheduled cron jobs.

---

# Skills Learned

By completing this project, I learned:

* Linux File System
* Log Management
* Bash Scripting
* Variables
* Command Substitution
* File Permissions
* System Monitoring
* Disk Monitoring
* Memory Monitoring
* Archiving using tar
* Automation using Cron
* Git and GitHub

This project provides a strong foundation for DevOps practices and server administration.
