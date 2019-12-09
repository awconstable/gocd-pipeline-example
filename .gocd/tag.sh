#!/bin/bash

user_id=`id -u`
echo "User: $user_id"
echo "Working Directory: "`pwd`

label=$GO_PIPELINE_LABEL
echo "Build Label: $label"

git config user.name "GoCD $GO_PIPELINE_NAME Pipeline"
git config user.email "gocd@rbs.com"
git tag -a $label -m "GoCD tagging version $label"
git push origin --tags
