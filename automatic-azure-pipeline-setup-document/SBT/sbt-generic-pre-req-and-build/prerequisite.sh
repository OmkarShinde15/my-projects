#!/bin/bash

udeploy_path="/data3/deployable_artifacts"

cd $udeploy_path


MY_PAT=$PAT

# replace "yourPAT" with ":PatStringFromWebUI"
B64_PAT=$(printf "%s"":$MY_PAT" | base64)
sudo git -c http.extraHeader="Authorization: Basic ${B64_PAT}" clone https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_git/$REPONAME


#checking whether "azure-pipeline.yml" already exists or not.

cd $udeploy_path/$REPONAME/

# File name to check
azfile="azure-pipeline.yml"

# Check if the file exists
if [ -s "$azfile" ]; then
    echo -e "\033[31m$azfile file already exists. Pipeline already exists for this Repository.\033[0m"
    cd $udeploy_path
    sudo rm -rf $REPONAME 
    echo "Directory Clean Up Done"
    exit 1
else
    echo -e "\033[32m$azfile does not exist. Ready for azure-pipeline.yml creation.\033[0m"
fi

# File name to check
buildfile="build.sbt"


# Check if the file exists
if [ -s "$buildfile" ]; then
    echo -e "\033[32m$buildfile file exists and not-empty. Ready for build pipeline creation.\033[0m"
else
    echo -e "\033[31m$buildfile file does not exist or empty. $buildfile required for build pipeline creation.\033[0m"
    cd $udeploy_path
    sudo rm -rf $REPONAME 
    echo "Directory Clean Up Done"
    exit 1
fi


# File name to check
sonar="sonar-project.properties"

# Check if the file exists
if [ -s "$sonar" ]; then
    echo -e "\033[32m$sonar file already exists. Ready for Verification.\033[0m"
else
    echo -e "\033[32m$sonar does not exist. Ready for sonar-project.properties creation.\033[0m"
fi






# Pushing $REPONAME
cd $udeploy_path/$REPONAME
sudo git add .
sudo git commit -m "No Change"
sudo git -c http.extraHeader="Authorization: Basic ${B64_PAT}" push origin master

echo "Git Push done for $REPONAME"


#Clean up 
cd $udeploy_path
sudo rm -rf $REPONAME

echo "Clean Up Done"