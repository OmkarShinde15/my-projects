echo "$BUILD_DEFINITION_ID"

# Define the JSON content with placeholders for variables

json='
{
  "source": undefined,
  "revision": 1,
  "description": null,
  "createdBy": null,
  "createdOn": null,
  "modifiedBy": null,
  "modifiedOn": null,
  "isDeleted": false,
  "variables": {
    
  },
  "variableGroups": [
    
  ],
  "environments": [
    {
      "id": null,
      "rank": 1,
      "name": "'"$STAGE1_NAME"'",
      "variables": {
        
      },
      "variableGroups": [
        
      ],
      "preDeployApprovals": {
        "approvals": [
          {
            "rank": 1,
            "isAutomated": true,
            "isNotificationOn": false,
            "id": 0
          }
        ]
      },
      "postDeployApprovals": {
        "approvals": [
          {
            "rank": 1,
            "isAutomated": true,
            "isNotificationOn": false,
            "id": 0
          }
        ]
      },
      "deployPhases": [
        {
          "deploymentInput": {
            "parallelExecution": {
              "parallelExecutionType": "none"
            },
            "deploymentHealthOption": "Custom",
            "tags": [     
              "'"$STAGE1_DEPLOYMENT_TAG"'"     //Tags inside JBDL_PROD deployment group
            ],
            "skipArtifactsDownload": false,
            "artifactsDownloadInput": {
              "downloadInputs": [
                
              ]
            },
            "queueId": '"$STAGE_DEPLOYMENT_GRP_ID"',     //JBDL_PROD deployment group id
            "demands": [
              
            ],
            "enableAccessToken": false,
            "timeoutInMinutes": 0,
            "jobCancelTimeoutInMinutes": 1,
            "condition": "succeeded()",
            "overrideInputs": {
              
            },
            "deploymentGroupName": "'"$STAGE_DEPLOYMENT_GRP_NAME"'"      //deployment group name
          },
          "rank": 1,
          "phaseType": 4,     //4=Deployment group jobs, 1=Agent Pool jobs
          "name": "Deployment group jobs",
          "refName": null,
          "workflowTasks": [    //All Tasks are specified here.
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "permission access",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd '"$UDEPLOY_PATH"'\n\nMAX_RETRIES=3\nRETRIES=0\n\nwhile [ $RETRIES -lt $MAX_RETRIES ]; do\n    #rm -rf '"$REPONAME"'\n    find '"$UDEPLOY_PATH"'/'"$REPONAME"' -depth -print0 | xargs -0 rm -rvf 2>&1 | tee deletion_log.txt\n    if [ $? -eq 0 ]; then\n        echo \"'"$REPONAME"' folder Deletion and required permission provided successfully\"\n        mkdir '"$REPONAME"'\n        ls -lR '"$REPONAME"'\n        cd '"$REPONAME"'\n        ls -lrth\n        mkdir scripts\n        break\n    else\n        echo \"Deletion failed. Retrying...\"\n        sleep 1  # Wait for 1 second before retrying\n        ((RETRIES++))\n    fi\ndone\n\n#chmod 755 '"$REPONAME"'\n#chown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            },
            {
              "environment": {
                
              },
              "taskId": "07fc5c20-6772-11e5-abde-6901d3c00755",
              "version": "3.*",
              "name": "Artifactory Generic Download",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "connection": "1432adb7-7168-410e-963f-6167fa8877a1",
                "specSource": "taskConfiguration",
                "fileSpec": "{\n  \"files\": [\n    {\n      \"pattern\": \"jconn-regulatory-webapp__dev__java/$(Build.DefinitionName)/$(Build.DefinitionName)_$(Build.BuildId)/*.jar\",\n      \"target\": \"$(System.DefaultWorkingDirectory)/\"\n    }\n  ]\n}",
                "file": "",
                "replaceSpecVars": "false",
                "specVars": "",
                "collectBuildInfo": "false",
                "buildName": "$(Build.DefinitionName)",
                "buildNumber": "$(Build.BuildNumber)",
                "module": "",
                "includeEnvVars": "false",
                "dryRun": "false",
                "failNoOp": "true",
                "insecureTls": "false",
                "threads": "3",
                "retries": "3",
                "splitCount": "3",
                "minSplit": "5120",
                "validateSymlinks": "false",
                "syncDeletes": "false",
                "syncDeletesPath": ""
              }
            },
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "copy jar",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd $(System.DefaultWorkingDirectory)/'"$REPONAME"'\ncp -R $(Build.DefinitionName)_$(Build.BuildId)/*.jar '"$UDEPLOY_PATH"'/'"$REPONAME"'/\n\nchown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'/*.jar\n\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            },
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "copy script_files",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd $(System.DefaultWorkingDirectory)/_'"$REPONAME"'\ncp -R script_files/* '"$UDEPLOY_PATH"'/'"$REPONAME"'/scripts\nchown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'/scripts\n\ncd '"$UDEPLOY_PATH"'/'"$REPONAME"'\nls\ncd '"$REPONAME"'\nls\n\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            }
          ]
        }
      ],
      "environmentOptions": {
        "emailNotificationType": "OnlyOnFailure",
        "emailRecipients": "release.environment.owner;release.creator",
        "skipArtifactsDownload": false,
        "timeoutInMinutes": 0,
        "enableAccessToken": false,
        "publishDeploymentStatus": true,
        "badgeEnabled": false,
        "autoLinkWorkItems": false,
        "pullRequestDeploymentEnabled": false
      },
      "demands": [
        
      ],
      "conditions": [
        {
          "name": "ReleaseStarted",
          "conditionType": 1,     //1=after release, bydefault manual only
          "value": ""
        }
      ],
      "executionPolicy": {
        "concurrencyCount": 0,
        "queueDepthCount": 0
      },
      "schedules": [
        
      ],
      "retentionPolicy": {
        "daysToKeep": 130,
        "releasesToKeep": 3,
        "retainBuild": true
      },
      "properties": {
        
      },
      "preDeploymentGates": {
        "id": 0,
        "gatesOptions": null,
        "gates": [
          
        ]
      },
      "postDeploymentGates": {
        "id": 0,
        "gatesOptions": null,
        "gates": [
          
        ]
      },
      "environmentTriggers": [
        
      ]
    },
    {
      "id": null,
      "rank": 2,
      "name": "'"$STAGE2_NAME"'",
      "variables": {
        
      },
      "variableGroups": [
        
      ],
      "preDeployApprovals": {
        "approvals": [
          {
            "rank": 1,
            "isAutomated": true,
            "isNotificationOn": false,
            "id": 0
          }
        ]
      },
      "postDeployApprovals": {
        "approvals": [
          {
            "rank": 1,
            "isAutomated": true,
            "isNotificationOn": false,
            "id": 0
          }
        ]
      },
      "deployPhases": [
        {
          "deploymentInput": {
            "parallelExecution": {
              "parallelExecutionType": "none"
            },
            "deploymentHealthOption": "Custom",
            "tags": [     
              "'"$STAGE2_DEPLOYMENT_TAG"'"     //Tags inside JBDL_PROD deployment group
            ],
            "skipArtifactsDownload": false,
            "artifactsDownloadInput": {
              "downloadInputs": [
                
              ]
            },
            "queueId": '"$STAGE_DEPLOYMENT_GRP_ID"',     //JBDL_PROD deployment group id
            "demands": [
              
            ],
            "enableAccessToken": false,
            "timeoutInMinutes": 0,
            "jobCancelTimeoutInMinutes": 1,
            "condition": "succeeded()",
            "overrideInputs": {
              
            },
            "deploymentGroupName": "'"$STAGE_DEPLOYMENT_GRP_NAME"'"      //deployment group name
          },
          "rank": 1,
          "phaseType": 4,     //4=Deployment group jobs, 1=Agent Pool jobs
          "name": "Deployment group jobs",
          "refName": null,
          "workflowTasks": [    //All Tasks are specified here.
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "permission access",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd '"$UDEPLOY_PATH"'\n\nMAX_RETRIES=3\nRETRIES=0\n\nwhile [ $RETRIES -lt $MAX_RETRIES ]; do\n    #rm -rf '"$REPONAME"'\n    find '"$UDEPLOY_PATH"'/'"$REPONAME"' -depth -print0 | xargs -0 rm -rvf 2>&1 | tee deletion_log.txt\n    if [ $? -eq 0 ]; then\n        echo \"'"$REPONAME"' folder Deletion and required permission provided successfully\"\n        mkdir '"$REPONAME"'\n        ls -lR '"$REPONAME"'\n        cd '"$REPONAME"'\n        ls -lrth\n        mkdir scripts\n        break\n    else\n        echo \"Deletion failed. Retrying...\"\n        sleep 1  # Wait for 1 second before retrying\n        ((RETRIES++))\n    fi\ndone\n\n#chmod 755 '"$REPONAME"'\n#chown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            },
            {
              "environment": {
                
              },
              "taskId": "07fc5c20-6772-11e5-abde-6901d3c00755",
              "version": "3.*",
              "name": "Artifactory Generic Download",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "connection": "1432adb7-7168-410e-963f-6167fa8877a1",
                "specSource": "taskConfiguration",
                "fileSpec": "{\n  \"files\": [\n    {\n      \"pattern\": \"jconn-regulatory-webapp__dev__java/$(Build.DefinitionName)/$(Build.DefinitionName)_$(Build.BuildId)/*.jar\",\n      \"target\": \"$(System.DefaultWorkingDirectory)/\"\n    }\n  ]\n}",
                "file": "",
                "replaceSpecVars": "false",
                "specVars": "",
                "collectBuildInfo": "false",
                "buildName": "$(Build.DefinitionName)",
                "buildNumber": "$(Build.BuildNumber)",
                "module": "",
                "includeEnvVars": "false",
                "dryRun": "false",
                "failNoOp": "true",
                "insecureTls": "false",
                "threads": "3",
                "retries": "3",
                "splitCount": "3",
                "minSplit": "5120",
                "validateSymlinks": "false",
                "syncDeletes": "false",
                "syncDeletesPath": ""
              }
            },
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "copy jar",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd $(System.DefaultWorkingDirectory)/'"$REPONAME"'\ncp -R $(Build.DefinitionName)_$(Build.BuildId)/*.jar '"$UDEPLOY_PATH"'/'"$REPONAME"'/\n\nchown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'/*.jar\n\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            },
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "copy script_files",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd $(System.DefaultWorkingDirectory)/_'"$REPONAME"'\ncp -R script_files/* '"$UDEPLOY_PATH"'/'"$REPONAME"'/scripts\nchown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'/scripts\n\ncd '"$UDEPLOY_PATH"'/'"$REPONAME"'\nls\ncd '"$REPONAME"'\nls\n\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            }
          ]
        }
      ],
      "environmentOptions": {
        "emailNotificationType": "OnlyOnFailure",
        "emailRecipients": "release.environment.owner;release.creator",
        "skipArtifactsDownload": false,
        "timeoutInMinutes": 0,
        "enableAccessToken": false,
        "publishDeploymentStatus": true,
        "badgeEnabled": false,
        "autoLinkWorkItems": false,
        "pullRequestDeploymentEnabled": false
      },
      "demands": [
        
      ],
      "conditions": [
        {
          "name": "ReleaseStarted",
          "conditionType": 1,     //1=after release, bydefault manual only
          "value": ""
        }
      ],
      "executionPolicy": {
        "concurrencyCount": 0,
        "queueDepthCount": 0
      },
      "schedules": [
        
      ],
      "retentionPolicy": {
        "daysToKeep": 130,
        "releasesToKeep": 3,
        "retainBuild": true
      },
      "properties": {
        
      },
      "preDeploymentGates": {
        "id": 0,
        "gatesOptions": null,
        "gates": [
          
        ]
      },
      "postDeploymentGates": {
        "id": 0,
        "gatesOptions": null,
        "gates": [
          
        ]
      },
      "environmentTriggers": [
        
      ]
    },
    {
      "id": null,
      "rank": 3,
      "name": "'"$STAGE3_NAME"'",
      "variables": {
        
      },
      "variableGroups": [
        
      ],
      "preDeployApprovals": {
        "approvals": [
          {
            "rank": 1,
            "isAutomated": true,
            "isNotificationOn": false,
            "id": 0
          }
        ]
      },
      "postDeployApprovals": {
        "approvals": [
          {
            "rank": 1,
            "isAutomated": true,
            "isNotificationOn": false,
            "id": 0
          }
        ]
      },
      "deployPhases": [
        {
          "deploymentInput": {
            "parallelExecution": {
              "parallelExecutionType": "none"
            },
            "deploymentHealthOption": "Custom",
            "tags": [     
              "'"$STAGE3_DEPLOYMENT_TAG"'"     //Tags inside JBDL_PROD deployment group
            ],
            "skipArtifactsDownload": false,
            "artifactsDownloadInput": {
              "downloadInputs": [
                
              ]
            },
            "queueId": '"$STAGE_DEPLOYMENT_GRP_ID"',     //JBDL_PROD deployment group id
            "demands": [
              
            ],
            "enableAccessToken": false,
            "timeoutInMinutes": 0,
            "jobCancelTimeoutInMinutes": 1,
            "condition": "succeeded()",
            "overrideInputs": {
              
            },
            "deploymentGroupName": "'"$STAGE_DEPLOYMENT_GRP_NAME"'"      //deployment group name
          },
          "rank": 1,
          "phaseType": 4,     //4=Deployment group jobs, 1=Agent Pool jobs
          "name": "Deployment group jobs",
          "refName": null,
          "workflowTasks": [    //All Tasks are specified here.
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "permission access",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd '"$UDEPLOY_PATH"'\n\nMAX_RETRIES=3\nRETRIES=0\n\nwhile [ $RETRIES -lt $MAX_RETRIES ]; do\n    #rm -rf '"$REPONAME"'\n    find '"$UDEPLOY_PATH"'/'"$REPONAME"' -depth -print0 | xargs -0 rm -rvf 2>&1 | tee deletion_log.txt\n    if [ $? -eq 0 ]; then\n        echo \"'"$REPONAME"' folder Deletion and required permission provided successfully\"\n        mkdir '"$REPONAME"'\n        ls -lR '"$REPONAME"'\n        cd '"$REPONAME"'\n        ls -lrth\n        mkdir scripts\n        break\n    else\n        echo \"Deletion failed. Retrying...\"\n        sleep 1  # Wait for 1 second before retrying\n        ((RETRIES++))\n    fi\ndone\n\n#chmod 755 '"$REPONAME"'\n#chown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            },
            {
              "environment": {
                
              },
              "taskId": "07fc5c20-6772-11e5-abde-6901d3c00755",
              "version": "3.*",
              "name": "Artifactory Generic Download",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "connection": "1432adb7-7168-410e-963f-6167fa8877a1",
                "specSource": "taskConfiguration",
                "fileSpec": "{\n  \"files\": [\n    {\n      \"pattern\": \"jconn-regulatory-webapp__dev__java/$(Build.DefinitionName)/$(Build.DefinitionName)_$(Build.BuildId)/*.jar\",\n      \"target\": \"$(System.DefaultWorkingDirectory)/\"\n    }\n  ]\n}",
                "file": "",
                "replaceSpecVars": "false",
                "specVars": "",
                "collectBuildInfo": "false",
                "buildName": "$(Build.DefinitionName)",
                "buildNumber": "$(Build.BuildNumber)",
                "module": "",
                "includeEnvVars": "false",
                "dryRun": "false",
                "failNoOp": "true",
                "insecureTls": "false",
                "threads": "3",
                "retries": "3",
                "splitCount": "3",
                "minSplit": "5120",
                "validateSymlinks": "false",
                "syncDeletes": "false",
                "syncDeletesPath": ""
              }
            },
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "copy jar",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd $(System.DefaultWorkingDirectory)/'"$REPONAME"'\ncp -R $(Build.DefinitionName)_$(Build.BuildId)/*.jar '"$UDEPLOY_PATH"'/'"$REPONAME"'/\n\nchown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'/*.jar\n\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            },
            {
              "environment": {
                
              },
              "taskId": "6c731c3c-3c68-459a-a5c9-bde6e6595b5b",
              "version": "3.*",
              "name": "copy script_files",
              "refName": "",
              "enabled": true,
              "alwaysRun": false,
              "continueOnError": false,
              "timeoutInMinutes": 0,
              "definitionType": "task",
              "overrideInputs": {
                
              },
              "condition": "succeeded()",
              "inputs": {
                "targetType": "inline",
                "filePath": "",
                "arguments": "",
                "script": "cd $(System.DefaultWorkingDirectory)/_'"$REPONAME"'\ncp -R script_files/* '"$UDEPLOY_PATH"'/'"$REPONAME"'/scripts\nchown -R '"$UDEPLOY_USER"':'"$UDEPLOY_USER"' '"$UDEPLOY_PATH"'/'"$REPONAME"'/scripts\n\ncd '"$UDEPLOY_PATH"'/'"$REPONAME"'\nls\ncd '"$REPONAME"'\nls\n\n",
                "workingDirectory": "",
                "failOnStderr": "false",
                "noProfile": "true",
                "noRc": "true"
              }
            }
          ]
        }
      ],
      "environmentOptions": {
        "emailNotificationType": "OnlyOnFailure",
        "emailRecipients": "release.environment.owner;release.creator",
        "skipArtifactsDownload": false,
        "timeoutInMinutes": 0,
        "enableAccessToken": false,
        "publishDeploymentStatus": true,
        "badgeEnabled": false,
        "autoLinkWorkItems": false,
        "pullRequestDeploymentEnabled": false
      },
      "demands": [
        
      ],
      "conditions": [
        {
          "name": "ReleaseStarted",
          "conditionType": 1,     //1=after release, bydefault manual only
          "value": ""
        }
      ],
      "executionPolicy": {
        "concurrencyCount": 0,
        "queueDepthCount": 0
      },
      "schedules": [
        
      ],
      "retentionPolicy": {
        "daysToKeep": 130,
        "releasesToKeep": 3,
        "retainBuild": true
      },
      "properties": {
        
      },
      "preDeploymentGates": {
        "id": 0,
        "gatesOptions": null,
        "gates": [
          
        ]
      },
      "postDeploymentGates": {
        "id": 0,
        "gatesOptions": null,
        "gates": [
          
        ]
      },
      "environmentTriggers": [
        
      ]
    }
  ],
  "artifacts": [
    {
      "sourceId": "f39823e3-86b7-4e95-84f6-d9d3326bf65f:'"$BUILD_DEFINITION_ID"'",
      "type": "Build",
      "alias": "_'"$REPONAME"'",
      "definitionReference": {
        "artifactSourceDefinitionUrl": {
          "id": "https://devops.jio.com/_permalink/_build/index?collectionId=6adb6ff6-cd3b-4f2d-8f6c-246a320333b1&projectId=f39823e3-86b7-4e95-84f6-d9d3326bf65f&definitionId='"$BUILD_DEFINITION_ID"'",
          "name": ""
        },
        "defaultVersionBranch": {
          "id": "",
          "name": ""
        },
        "defaultVersionSpecific": {
          "id": "",
          "name": ""
        },
        "defaultVersionTags": {
          "id": "",
          "name": ""
        },
        "defaultVersionType": {
          "id": "latestType",
          "name": "Latest"
        },
        "definition": {
          "id": "'"$BUILD_DEFINITION_ID"'",
          "name": "'"$REPONAME"'"
        },
        "definitions": {
          "id": "",
          "name": ""
        },
        "IsMultiDefinitionType": {
          "id": "False",
          "name": "False"
        },
        "project": {
          "id": "f39823e3-86b7-4e95-84f6-d9d3326bf65f",
          "name": "Data Platforms"
        },
        "repository": {
          "id": "",
          "name": ""
        }
      },
      "isPrimary": true,
      "isRetained": false
    }
  ],
  "triggers": [
    {
      "artifactAlias": "_'"$REPONAME"'",
      "triggerConditions": [
        
      ],
      "triggerType": 1      //CD trigger enabled for build artifact
    }
  ],
  "releaseNameFormat": "Release-$(rev:r)",
  "tags": [
    
  ],
  "pipelineProcess": {
    "type": 1
  },
  "properties": {
    "DefinitionCreationSource": {
      "$type": "System.String",
      "$value": "ReleaseNew"
    },
    "System.EnvironmentRankLogicVersion": {
      "$type": "System.String",
      "$value": "2"
    }
  },
  "id": null,
  "name": "'"$REPONAME"'",
  "path": "'"$RELEASE_PATH"'",
  "projectReference": null,
  "_links": {}
}
'


#echo "$json"

# Send the JSON content using curl
#curl -k --user ":$PAT" \
#--header "Content-Type: application/json" \
#--header "Accept: application/json" \
#https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_apis/release/definitions?api-version=5.1 \
#--data-binary "$json"



# Run curl command to create build definition and capture response
response=$(curl -k --user ":$PAT" --header "Content-Type: application/json" --header "Accept:application/json" https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_apis/release/definitions?api-version=5.1 --data-binary "$json")

# Extract ID from response using jq
id=$(echo $response | jq -r '.id')

# Store ID as a variable
RELEASE_DEFINITION_ID=$id

# Output ID for verification
echo "$RELEASE_DEFINITION_ID"
