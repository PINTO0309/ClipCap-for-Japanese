FROM pinto0309/base-x64-ubuntu2204-cuda118:latest
ENV DEBIAN_FRONTEND=noninteractive
ARG USERNAME=user
ARG WKDIR=/workdir

SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        curl \
        wget \
        gcc \
        git \
        make \
        gnupg2 \
        lsb-release \
        build-essential \
        ca-certificates \
        python3-dev \
    && apt-get install -y  --no-install-recommends \
        python-is-python3 \
        python3-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/apt.conf.d/docker-clean \
    && pip install pip -U \
    && pip install \
        cmake==3.27.5 \
        clip==0.2.0 \
        cog==0.4.4 \
        mecab-python3==1.0.8 \
        unidic-lite==1.0.8 \
        numpy==1.23.3 \
        opencv_python==4.8.1.78 \
        Pillow==9.2.0 \
        pycocoevalcap==1.2 \
        requests==2.28.1 \
        scikit-image==0.21.0 \
        tqdm==4.64.0 \
        transformers==4.22.2 \
        wandb==0.15.12 \
    && pip install torch torchvision torchaudio \
        --index-url https://download.pytorch.org/whl/cu118 \
    && wget https://github.com/rinnakk/japanese-clip/releases/download/v0.2.0/japanese_clip-0.2.0-py3-none-any.whl \
    && pip install japanese_clip-0.2.0-py3-none-any.whl

RUN echo "root:root" | chpasswd \
    && useradd \
        --create-home \
        --home-dir /home/${USERNAME} \
        --shell /bin/bash \
        --user-group \
        --groups adm,sudo \
        ${USERNAME} \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && cat /dev/null > /etc/sudoers.d/${USERNAME} \
    && echo "%${USERNAME}    ALL=(ALL)   NOPASSWD:    ALL" >> \
        /etc/sudoers.d/${USERNAME} \
    && chown ${USERNAME}:${USERNAME} /run/user/

USER ${USERNAME}
WORKDIR ${WKDIR}

RUN echo "export USER=`whoami`" >> ~/.bashrc \
    && echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc \
    && echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc \
    && echo 'export PATH=${PATH}:${HOME}/.local/bin' >> ~/.bashrc
