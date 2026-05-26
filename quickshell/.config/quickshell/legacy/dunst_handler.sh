#!/bin/bash
# dunst_handler.sh

SUMMARY="$2"
BODY="$3"

# This is where we would send the notification to quickshell.
# For now, we'll just log it to a file to prove it's working.
echo "Notification received: $SUMMARY - $BODY" >> /home/mohamed/.config/quickshell/dunst.log

# We also need to tell quickshell to display the notification.
# We can do this by calling a D-Bus method on quickshell.
# I don't know the exact D-Bus interface for quickshell,
# but it would look something like this:
# qdbus com.example.quickshell /com/example/quickshell/Notifications com.example.quickshell.Notifications.ShowNotification "$SUMMARY" "$BODY"
