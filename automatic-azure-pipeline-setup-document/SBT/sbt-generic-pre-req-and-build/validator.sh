#!/bin/bash

whoami

# Perform the curl request and capture the output
response=$(curl -k --user ":$PAT" --header "Content-Type: application/json" --header "Accept:application/json" https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_apis/git/repositories/$REPONAME?api-version=5.1)

# Extract the repository ID using jq
id=$(echo "$response" | jq -r '.id')

# Store ID as a variable
REPOSITORY_ID=$id

#echo $repo_id

# Check if repo_id is not null
if [ -n "$id" ] && [ "$id" != "null" ]; then
    echo -e "\033[32m$REPONAME Repository exist.\033[0m"
else
    echo -e "\033[31m$REPONAME Repository does not exist.\033[0m"
    exit 1
fi

# Using task.setvariable to pass repo_id for next task

echo "##vso[task.setvariable variable=REPOSITORY_ID]$id"