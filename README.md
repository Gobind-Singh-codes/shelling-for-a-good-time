#📝 My Whimsical Bash Scripts

This collection is a place for small, custom shell scripts I'm creating on a whim to make my Pop!_OS environment slightly more personalized, opinionated, or just plain helpful.

These scripts are installed in my personal path (~/.local/bin/) and run automatically or on-demand.

Script Inventory

Script Name

Purpose

Status
📝 My Whimsical Bash Scripts
============================

This collection is a place for small, custom shell scripts I'm creating on a whim to make my Pop!\_OS environment slightly more personalized, opinionated, or just plain helpful.

These scripts are installed in my personal path (~/.local/bin/) and run automatically or on-demand.

Script Inventory
----------------

Script Name

Purpose

Status

stretch\_reminder

**Forces me to take a break.** It tracks active mouse/keyboard usage and pops up a Zenity dialog every 60 minutes of activity, prompting me to stand up and stretch.

Running as Daemon

sys\_info

(Placeholder) A simple script to quickly grab core OS and uptime data.

Draft

project\_cleaner

(Placeholder) A utility to recursively delete common build directories (node\_modules, target, .pyc, etc.) in my source code folders.

Draft

🏃 Details: stretch\_reminder
-----------------------------

This script is designed to run silently in the background as a daemon. It is superior to a simple cron job because it only counts time when the user is actively working.

**Location:** /home/gobindsingh/.local/bin/stretch\_reminder

### Key Configuration

The interval is currently set to **1 hour (3600 seconds)** of _active_ use.

*   **INTERVAL\_SECONDS=3600**: The core timer.
    
*   **IDLE\_THRESHOLD\_SECONDS=900**: If the system's idle time exceeds 15 minutes (900 seconds) when the timer expires, the alert is postponed until the user returns.
    

### How to Manage the Daemon

1.  nohup /home/gobindsingh/.local/bin/stretch\_reminder &
    
2.  pkill -f stretch\_reminder
    
3.  cat /tmp/stretch\_reminder\_log.txt
    
4.  nano /home/gobindsingh/.local/bin/stretch\_reminder
stretch_reminder

Forces me to take a break. It tracks active mouse/keyboard usage and pops up a Zenity dialog every 60 minutes of activity, prompting me to stand up and stretch.

Running as Daemon

sys_info

(Placeholder) A simple script to quickly grab core OS and uptime data.

Draft

project_cleaner

(Placeholder) A utility to recursively delete common build directories (node_modules, target, .pyc, etc.) in my source code folders.

Draft

🏃 Details: stretch_reminder

This script is designed to run silently in the background as a daemon. It is superior to a simple cron job because it only counts time when the user is actively working.

Location: /home/gobindsingh/.local/bin/stretch_reminder

Key Configuration

The interval is currently set to 1 hour (3600 seconds) of active use.

INTERVAL_SECONDS=3600: The core timer.

IDLE_THRESHOLD_SECONDS=900: If the system's idle time exceeds 15 minutes (900 seconds) when the timer expires, the alert is postponed until the user returns.

How to Manage the Daemon

Start/Restart the Daemon:

nohup /home/gobindsingh/.local/bin/stretch_reminder &


Stop the Daemon:

pkill -f stretch_reminder


View Logs:

cat /tmp/stretch_reminder_log.txt


Edit the Interval:

nano /home/gobindsingh/.local/bin/stretch_reminder
