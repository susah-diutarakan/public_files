#!/bin/bash
echo "Please enter your node ID:"
read -r user_id

# Validate that input is not empty
if [ -z "$user_id" ]; then
    echo "Error: No code entered. Please try again." >&2
    exit 1
fi

echo "Node ID entered: $user_id"
echo -e "\033[0;32mRunning Nexus...!\033[0m"
nexus-network start --node-id "$user_id"
