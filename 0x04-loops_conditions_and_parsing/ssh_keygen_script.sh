#!/usr/bin/env bash

# This script generates an SSH RSA key pair and uploads the public key to GitHub

# Variables
directory="$HOME/alx-system_engineering-devops/0x04-loops_conditions_and_parsing"
key_file="$HOME/.ssh/id_rsa"
public_key_file="$HOME/.ssh/id_rsa.pub"
output_file="$directory/0-RSA_public_key.pub"
repo_url="git@github.com:OrapelengN/alx-system_engineering-devops.git"

# Ensure .ssh directory exists
mkdir -p "$HOME/.ssh"

# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f "$key_file" -N ""
echo "SSH key pair generated."

# Ensure SSH agent is running
eval "$(ssh-agent -s)"
ssh-add "$key_file"

# Ensure project directory exists
mkdir -p "$directory"

# Copy public key to project directory
cat "$public_key_file" > "$output_file"
echo "Public key saved to $output_file."

# Git operations
cd "$directory" || exit
git add 0-RSA_public_key.pub
git commit -m "Add RSA public key"
git push "$repo_url" main

echo "Public key pushed to GitHub repository."
