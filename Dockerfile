FROM nvidia/cuda:11.1-runtime-ubuntu20.04

# Download Miniconda py39 - https://docs.conda.io/en/latest/miniconda.html#linux-installers
RUN apt-get -qq update && apt-get -qq -y install curl bzip2 git build-essential \
    && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

ARG PYTHON_VERSION=3.7
ARG CUDA_VERSION=11.1
ARG TORCH_VERSION=1.9.1
ARG TORCHVISION_VERSION=0.10.1
RUN conda create -n app python=$PYTHON_VERSION cudatoolkit=$CUDA_VERSION \
    pytorch==${TORCH_VERSION} torchvision==${TORCHVISION_VERSION} -c pytorch -c nvidia

# Make sure the shell commands run inside the environment
SHELL ["conda", "run", "-n", "app", "--no-capture-output", "/bin/bash", "-c"]

# Install Pillow-SIMD w/ libjpeg-turbo
COPY scripts/install-pillow-simd-w-libjpeg-turbo.sh /opt/scripts/install-pillow-simd-w-libjpeg-turbo.sh
RUN bash /opt/scripts/install-pillow-simd-w-libjpeg-turbo.sh
