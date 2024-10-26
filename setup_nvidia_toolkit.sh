curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit

# sudo nvidia-ctk runtime configure --runtime=containerd
# sudo systemctl restart containerd

# kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.16.2/deployments/static/nvidia-device-plugin.yml

# kubectl delete -n kube-system daemonset nvidia-device-plugin-daemonset

# helm repo add nvdp https://nvidia.github.io/k8s-device-plugin
# helm repo update
# helm upgrade -i nvdp nvdp/nvidia-device-plugin \
#   --namespace nvidia-device-plugin \
#   --create-namespace \
#   --version 0.16.2