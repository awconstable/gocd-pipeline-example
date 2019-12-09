#!/bin/bash

user_id=`id -u`
echo "User: $user_id"
echo "Working Directory: "`pwd`

echo "Build Label: $GO_PIPELINE_LABEL"
label=$GO_PIPELINE_LABEL

docker_image_command="docker run --rm --user $user_id:$user_id -v /opt/gocd/agent/maven-home/:/var/maven/ -v /opt/gocd/agent/data/pipelines/$GO_PIPELINE_NAME/stash/:/buildroot -e MAVEN_CONFIG=/var/maven/.m2 -w /buildroot maven:3.6.0-jdk-11"

echo "Update version"
version_command="$docker_image_command mvn -Duser.home=/var/maven --settings .gocd/settings.xml -Djavax.net.ssl.trustStore=/buildroot/.gocd/maven.keystore -Djavax.net.ssl.trustStorePassword=changeit versions:set -DnewVersion=$label"
echo $version_command
eval $version_command

echo "Build"
build_command="$docker_image_command mvn -Duser.home=/var/maven --settings .gocd/settings.xml -Djavax.net.ssl.trustStore=/buildroot/.gocd/maven.keystore -Djavax.net.ssl.trustStorePassword=changeit package"
echo $build_command
eval $build_command
