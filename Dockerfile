FROM ubuntu

WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl wget \
  ocl-icd-libopencl1 \
  opencl-headers \
  nano \
  ocl-icd-opencl-dev \
  nvidia-opencl-dev \
  build-essential \
  clinfo pkg-config && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/OpenCL/vendors && \
  echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd && \
  ln -s /usr/local/cuda/lib64/libOpenCL.so.1 /usr/lib/libOpenCL.so && \
  echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
  echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

RUN ldconfig

COPY . ./
RUN PATH=/usr/local/nvidia/bin:$PATH \
  LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH \
  NVIDIA_VISIBLE_DEVICES=all \
  NVIDIA_DRIVER_CAPABILITIES=compute,utility \
  make