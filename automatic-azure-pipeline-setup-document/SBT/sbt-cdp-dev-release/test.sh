#!/bin/bash

# Access the secret variable
echo "Using the secret variable in the script"

# Do not echo the secret variable in real-world scenarios to avoid leaking sensitive information
# For demonstration, we will just print a confirmation message
if [ -z "$PAT" ]; then
  echo "PAT is not set!"
else
  echo "PAT is set"
fi

# You can use the SECRET_VAR for your script's logic here
# Example: Use the secret variable in some command
# my_command --secret "$SECRET_VAR"