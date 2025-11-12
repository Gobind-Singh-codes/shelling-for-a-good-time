#!/bin/bash

# ===============================================
# Stretch Reminder Daemon (Uses Zenity for pop-ups)
# Tracks "active usage" by checking system idle time 
# and sends a pop-up every 1 hour of activity.
# ===============================================

# --- Configuration ---
INTERVAL_SECONDS= 3600 # 1 hour
IDLE_THRESHOLD_SECONDS=900 # 15 minutes. If idle time is greater than this, the 3-hour timer is delayed.
REMINDER_TITLE="Time to Get Moving!"
REMINDER_MESSAGE="You've been active for a while! It's time to stand up, stretch, and give your eyes a break. The next reminder will appear in 1 hour of activity."
LOG_FILE="/tmp/stretch_reminder_log.txt" # Log file for monitoring (optional)

# --- Check Prerequisites ---

# 1. Check if Zenity (the pop-up utility) is installed
if ! command -v zenity &> /dev/null; then
    echo "$(date): Error: zenity is not installed. Please install it." >> $LOG_FILE
    exit 1
fi

# 2. Check if xprintidle (the active usage tracking utility) is installed
if ! command -v xprintidle &> /dev/null; then
    echo "$(date): Error: xprintidle is not installed. Please install it (e.g., sudo apt install xprintidle or sudo yum install xprintidle)." >> $LOG_FILE
    exit 1
fi

# 3. Check if a display is available (essential for graphical pop-ups)
if [ -z "$DISPLAY" ]; then
    echo "$(date): Error: DISPLAY environment variable is not set. Cannot show graphical dialog." >> $LOG_FILE
    exit 1
fi

echo "$(date): Stretch reminder daemon started successfully. Activity check threshold: $IDLE_THRESHOLD_SECONDS seconds." >> $LOG_FILE

# --- Helper Function ---
# Checks system idle time in milliseconds and converts to seconds.
get_idle_seconds() {
    # xprintidle returns time in milliseconds
    IDLE_MS=$(xprintidle)
    IDLE_S=$((IDLE_MS / 1000))
    echo $IDLE_S
}

# --- Main Loop ---
while true; do
    
    # Wait for the specified interval (1 hour of wall clock time)
    echo "$(date): Waiting for 1 hour..." >> $LOG_FILE
    sleep $INTERVAL_SECONDS

    # Loop to check for idle time and postpone the alert if necessary
    while true; do
        IDLE_TIME=$(get_idle_seconds)

        if [ "$IDLE_TIME" -gt "$IDLE_THRESHOLD_SECONDS" ]; then
            
            # If idle time is too high, the user was away. 
            # Postpone the check and wait a little longer.
            echo "$(date): Detected idle time ($IDLE_TIME seconds) is greater than threshold ($IDLE_THRESHOLD_SECONDS). Postponing alert." >> $LOG_FILE
            
            # Sleep for the length of the idle time, plus a minute, to essentially reset the activity clock
            # Use 900 seconds (15 minutes) as a safe, short delay if idle time is extremely long.
            DELAY_SECONDS=900 
            echo "$(date): Waiting $DELAY_SECONDS seconds before checking activity again..." >> $LOG_FILE
            sleep $DELAY_SECONDS
            
            # The inner loop continues, checking idle time again.
        else
            # User is active (idle time is low)
            break 
        fi
    done

    # Display the graphical reminder dialog
    zenity --info \
           --title="$REMINDER_TITLE" \
           --text="$REMINDER_MESSAGE" \
           --width=350 

    echo "$(date): Reminder displayed." >> $LOG_FILE

done