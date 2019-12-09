#!/bin/bash

echo "User: "`id -u`
echo "Working Directory: "`pwd`

module=$1
echo "Module: $module"

label=$GO_PIPELINE_LABEL
echo "Build Label: $label"

server=$2
echo "Server: $server"

ports=$3
echo "Ports: $ports"

database=$4
echo "Database: $database"

container="teamservice-$module"

agent_build_root=/godata/pipelines/$GO_PIPELINE_NAME/stash
agent_target_dir=$agent_build_root/$module/target

cd $agent_target_dir

echo "Current dir: "`pwd`

echo "Stop and remove $container container from $server"
ssh root@$server "docker stop $container || true && docker rm $container || true"

echo "Deploy $container docker image to $server"
cat $agent_target_dir/jib-image.tar | ssh root@$server 'docker load'

echo "Remove old docker images from $server"
ssh root@$server "docker image prune -f"

echo "Deploy $container container start script to $server"
cat $agent_build_root/.gocd/$container-start.sh | sed s/--VERSION--/$label/ | sed s/--SERVER--/$server/ | sed s/--DATABASE--/$database/ | sed s/--PORTS--/$ports/ | ssh root@$server "cat - > /usr/local/bin/${container}-start.sh"
ssh root@$server "chmod +x /usr/local/bin/${container}-start.sh"

if [ $container = 'web' ]
then
    echo "Deploy $container container stop script to $server"
    cat $agent_build_root/.gocd/$container-stop.sh | ssh root@$server "cat - > /usr/local/bin/${container}-stop.sh"
    ssh root@$server "chmod +x /usr/local/bin/${container}-stop.sh"
    echo "Start $container container on $server"
    ssh root@$server "/usr/local/bin/${container}-start.sh"
fi
