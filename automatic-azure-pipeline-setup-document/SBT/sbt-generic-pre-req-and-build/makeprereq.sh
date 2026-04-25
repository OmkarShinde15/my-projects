#!/bin/bash


udeploy_path="/data3/deployable_artifacts"

cd $udeploy_path



#Clone your Auto-Repo-Test
MY_PAT=$PAT



# replace "yourPAT" with ":PatStringFromWebUI"
B64_PAT=$(printf "%s"":$MY_PAT" | base64)
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" clone https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_git/$REPONAME




# replace "yourPAT" with ":PatStringFromWebUI"
B64_PAT=$(printf "%s"":$MY_PAT" | base64)
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" clone https://devops.jio.com/AnalyticsAndDataScience/Data%20Platforms/_git/Auto-Pipeline-Templates


#checking whether "build.sbt" already exists or not.

cd $udeploy_path/$REPONAME/

git config user.name "SI_udeploy"
git config user.email SI_udeploy@auto.cicd

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

#checking whether "azure-pipeline.yml" already exists or not.

# File name to check
file="azure-pipeline.yml"

# Check if the file exists
if [ -f "$file" ]; then
    echo -e "\033[31m$azfile file already exists. Pipeline already exists for this Repository.\033[0m"
    cd $udeploy_path
    sudo rm -rf $REPONAME Auto-Pipeline-Templates
    echo "Directory Clean Up Done"
    exit 1
else
    echo "$file does not exist."
    cd $udeploy_path/$REPONAME/
    sudo cp ../Auto-Pipeline-Templates/azure-pipeline.yml .
    echo -e "\033[32mCreation of azure-pipeline.yml for "$REPONAME".\033[0m"
fi

#checking whether "sonar-project.properties" already exists or not.

# File name to check
sonar="sonar-project.properties"

# Check if the file exists
if [ -f "$sonar" ]; then
    echo "$sonar file already exists. Verifying the $sonar file."
    cd $udeploy_path/Auto-Pipeline-Templates
    cp sonar-project-template.properties sonar-project.properties
    sed -i "s|REPO|$REPONAME|g" sonar-project.properties

    cd $udeploy_path/$REPONAME/
    sudo mv -f ../Auto-Pipeline-Templates/sonar-project.properties .
    echo -e "\033[32mVerification of sonar-project.properties for "$REPONAME" done.\033[0m"
    
else
    echo "$sonar does not exist."
    cd $udeploy_path/Auto-Pipeline-Templates
    cp sonar-project-template.properties sonar-project.properties
    sed -i "s|REPO|$REPONAME|g" sonar-project.properties

    cd $udeploy_path/$REPONAME/
    sudo mv ../Auto-Pipeline-Templates/sonar-project.properties .
    echo -e "\033[32mCreation of sonar-project.properties for "$REPONAME".\033[0m"
fi





# Pushing Auto-Pipeline-Templates
cd $udeploy_path/Auto-Pipeline-Templates
git add .
git commit -m "No Change"
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" push origin master

echo "Git Push done for Auto-Pipeline-Templates"

# Pushing $REPONAME
cd $udeploy_path/$REPONAME
git add .
git commit -m "Added azure-pipeline.yml"
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" push origin master

echo "Git Push done for $REPONAME"


#Clean up 
cd $udeploy_path

sudo rm -rf $REPONAME Auto-Pipeline-Templates


echo "Clean Up Done"