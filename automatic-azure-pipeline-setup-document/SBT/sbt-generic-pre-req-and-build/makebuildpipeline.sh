#echo "$REPOSITORY_ID"
#echo "$BUILD_PATH"
#echo "$QUEUE_ID"
#echo "$AGENT_POOL"
#echo "$POOL_ID"

#!/bin/bash
json='
{
  "name": "'"$REPONAME"'",
  "path": "'"$BUILD_PATH"'",            //Folder in which build pipeline will be created
  "queue": {
    "id": '"$QUEUE_ID"',           //queue id of agent140
    "name": "'"$AGENT_POOL"'",
    "pool": {
      "id": '"$POOL_ID"',          //pool id of agent140
      "name": "'"$AGENT_POOL"'"
    }
  },
  "triggers": [
      {
          "branchFilters": [],          //bydefault master branch is selected for auto-triger
          "pathFilters": [],
          "settingsSourceType": 2,
          "batchChanges": false,
          "maxConcurrentBuildsPerBranch": 1,
          "triggerType": "continuousIntegration"        //CI enabled
      }
  ],
  "process": {
      "yamlFilename": "/azure-pipeline.yml",
      "type": 2         //Configure pipeline using existing azure-pipeline.yml
  },
  "repository": {
      "properties": {
          "cleanOptions": "0",
          "fetchDepth": "0",
          "gitLfsSupport": "false",
          "skipSyncSource": "false",
          "checkoutNestedSubmodules": "false",
          "labelSources": "0",
          "labelSourcesFormat": "$(build.buildNumber)",
          "reportBuildStatus": "false"
      },
      "id": "'"$REPOSITORY_ID"'",
      "type": "TfsGit",
      "name": "'"$REPONAME"'",
      "url": "https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_git/'"$REPONAME"'",
      "defaultBranch": "refs/heads/master",         //default branch set to master
      "clean": null,
      "checkoutSubmodules": false
  },
  "configuration": {            //repository information
    "type": "yaml",
    "path": "/azure-pipeline.yml",
    "queueStatus": "enabled",
    "repository": {
      "id": "'"$REPOSITORY_ID"'",
      "name": "'"$REPONAME"'",
      "type": "azureReposGit"
    }
  },
  "project": {          //project information
      "id": "f39823e3-86b7-4e95-84f6-d9d3326bf65f",
      "name": "Data Platforms",
      "url": "https://devops.jio.com/AnalyticsAndDataScience/_apis/projects/f39823e3-86b7-4e95-84f6-d9d3326bf65f",
      "state": "wellFormed",
      "visibility": "private"
      
  }
}'


# Run curl command to create build definition and capture response
response=$(curl -k --user ":$PAT" --header "Content-Type: application/json" --header "Accept:application/json" https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_apis/build/definitions?api-version=5.1 --data-binary "$json")

# Extract ID from response using jq
id=$(echo $response | jq -r '.id')

# Store ID as a variable
BUILD_DEFINITION_ID=$id

# Output ID for verification
# Using task.setvariable to pass build_id for next task

echo "##vso[task.setvariable variable=BUILD_DEFINITION_ID]$id"