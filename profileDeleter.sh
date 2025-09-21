#!/bin/bash
# Maintained by Quintin Scherrer v0.2 9/20/25
#never coding in bash again, not even gpt could help me

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (sudo)."
    exit 1
fi

#any user that starts with a 3 or 2 will be deleted
users=$(dscl . list /Users | grep -e '^3' -e '^2')

#didnt work for me sometimes idk
echo "The following users will be deleted:"
echo "$users"
read -p "Are you SURE you want to continue? Type y to confirm: " confirm

if [ "$confirm" != "y" ]; then
    echo "Aborted."
    exit 1
fi

LOGFILE="/var/log/user_deletion_$(date +%Y%m%d_%H%M%S).log"
echo "Starting user deletion at $(date)" > "$LOGFILE"

for user in $users; do
    echo "SAY HELLO TO MY LITTLE FRIEND!"
    echo "Deleting user: $user" | tee -a "$LOGFILE"
    sudo sysadminctl -deleteUser "$user" -secure
done

echo "Deletion complete. Log saved to $LOGFILE"
