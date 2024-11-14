
- Install `nvidia-container-toolkit`

  ```bash
  ./setup_nvidia_toolkit.sh
  ```

- Configure `containerd`

  ```bash
  sudo nvidia-ctk runtime configure --runtime=containerd
  ```

  ```bash
  sudo vim /etc/containerd/config.toml
  ```

  ```toml
      [plugins."io.containerd.grpc.v1.cri".containerd]
        default_runtime_name = "nvidia" # nvidia로 변경
        # 기타 설정 생략

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]

        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
          BinaryName = "/usr/bin/nvidia-container-runtime"
          # 기타 설정 생략

        # 아래 내용 추가
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.env]
          LD_LIBRARY_PATH = "/usr/lib/x86_64-linux-gnu:/usr/local/cuda/lib64"
  ```

  ```bash
  sudo systemctl restart containerd
  ```

- Install `nvidia-device-plugin`

  ```bash
  kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.16.2/deployments/static/nvidia-device-plugin.yml
  ```

    - Delete `nvidia-device-plugin`

      ```bash
      kubectl delete -n kube-system daemonset nvidia-device-plugin-daemonset
      ```

- Build `pipeline-gpu` image

  ```bash
  ./build_pipeline_gpu.sh
  ```

- Check GPU usage with `nerdctl`

  ```bash
  sudo nerdctl run -it --rm --gpus all --namespace k8s.io -p 8888:8888 -v $(pwd):/app_run traininghost/pipelinegpuimage:latest /bin/bash -c "nvidia-smi"
  ```

- Check GPU usage in Pod

    ```bash
    kubectl apply -f simple_gpu_check.yaml
    ```

    ```bash
    kubectl exec -it gpu-pod -- /bin/bash -c "nvidia-smi"
    ```

    ```bash
    kubectl exec -it gpu-pod -- /bin/bash -c "python3 -c \"import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))\""
    ```