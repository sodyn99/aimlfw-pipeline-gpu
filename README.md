

```bash
docker run -it --rm --gpus all -p 8888:8888 -v
 $(pwd):/app_run traininghost/pipelinegpuimage:latest /bin/bash
```