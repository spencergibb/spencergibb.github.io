#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace by `hugo -t <yourtheme>`

cp CNAME public/

# Go To Public folder
cd public

# hack to fix bad link given at oscon
cp preso/spring-cloud-oscon-2015/index.html preso/spring-cloud-oscon-2015.html

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..
