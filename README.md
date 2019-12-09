# GoCD Pipeline Example

## Start server
```
docker run -d -p8153:8153 -p8154:8154 -v /opt/gocd/server/data/:/godata -v /opt/gocd/server/home:/home/go --name goserver -e GO_SERVER_SYSTEM_PROPERTIES="-Dhttp.proxyhost=172.17.0.1 -Dhttp.proxyport=3128 -Dhttps.proxyhost=172.17.0.1 -Dhttps.proxyport=3128" gocd/gocd-server:v19.1.0
```
## Start an agent
```
docker run -d -e GO_SERVER_URL=https://172.17.0.1:8154/go --name goagent -v /var/run/docker.sock:/var/run/docker.sock -v /opt/gocd/agent/data:/godata -v /opt/gocd/agent/home:/home/go -e GO_AGENT_SYSTEM_PROPERTIES="-Dhttp.proxyhost=172.17.0.1 -Dhttp.proxyport=3128 -Dhttps.proxyhost=172.17.0.1 -Dhttps.proxyport=3128" gocd/gocd-agent-centos-7:v19.1.0
```
## Setup agent

1. start agent using above command
1. login to agent's docker container - `docker exec -it goagent /bin/bash`
1. set proxies(maybe you'll need to use cntlm): export http_proxy=http://172.17.0.1:3128; export https_proxy=http://172.17.0.1:3128
1. install docker client - yum install docker-client
1. Enable go user access to docker socket
1. chown root:1000 /var/run/docker.sock
