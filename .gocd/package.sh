#!/bin/bash

echo "User: "`id -u`
echo "Working Directory: "`pwd`

echo "Module: $1"
module=$1

echo "Build Label: $GO_PIPELINE_LABEL"
label=$GO_PIPELINE_LABEL

agent_build_root=/godata/pipelines/$GO_PIPELINE_NAME/stash

cd $agent_build_root/$module

echo "Current dir: "`pwd`

env

docker_image_command="docker run --rm --user $user_id:$user_id -v /opt/gocd/agent/maven-home/:/var/maven/ -v /opt/gocd/agent/data/pipelines/$GO_PIPELINE_NAME/work/:/buildroot -e MAVEN_CONFIG=/var/maven/.m2 -w /buildroot maven:3.6.0-jdk-11"

base_image_download_command="$docker_image_command wget --no-check-certificate https://docker.repo/docker_image-gcr_io_distroless_java_11.tar -O /buildroot/$module/target/docker_image-gcr_io_distroless_java_11.tar"

echo "Download base Docker image from Artifactory"
echo $base_image_download_command
eval $base_image_download_command

package_command="$docker_image_command mvn -Duser.home=/var/maven --settings .gocd/settings.xml -Djavax.net.ssl.trustStore=/buildroot/.gocd/maven.keystore -Djavax.net.ssl.trustStorePassword=changeit compile jib:buildTar -B -DskipTests=true -Djib.from.image=tar:///buildroot/$module/target/docker_image-gcr_io_distroless_java_11.tar"

echo "Build a docker image"
echo $package_command
eval $package_command
