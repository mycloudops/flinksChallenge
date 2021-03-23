#/bin/bash
sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo snap install helm --classic
microk8s enable dns
microk8s enable helm
microk8s enable ingress
microk8s enable registry
microk8s enable registry:size=5Gi
sudo systemctl restart docker
sudo docker build -t localhost:32000/mynginx:latest .
sudo docker tag localhost:32000/mynginx:latest localhost:32000/mynginx:latest
echo "pushing image to local repo"
sleep 1m
sudo docker push localhost:32000/mynginx:latest
sudo snap alias microk8s.kubectl kubectl
kubectl create -f nginx.yaml
kubectl create -f flinksApp.yaml
IP=$(curl ifconfig.me | awk '{print $1}')
HOSTNAME="challenge.domain.local"
HOST="${IP} ${HOSTNAME}"
echo "$HOST" | sudo tee -a /etc/hosts > /dev/null
echo "Please visit URL: challenge.domain.local:32512"
