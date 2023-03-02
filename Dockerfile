# GPU should be set to either "A10G" or "T4"
ARG GPU=A10G

FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# OS setup
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y \
        libgl1 \
        libglib2.0-0 \
        procps \
        curl \
        vim \
        libreadline8 \
        bzip2 \
        wget \
        git \
        git-lfs \
        tzdata \
        psmisc \
        bash \
        ca-certificates \
        netbase \
        openssh-client \
        libsqlite3-dev \
        python3-pip \
        python3-venv \
        python-is-python3 \
        build-essential \
        libssl-dev \
        libffi-dev \
        aria2 \
    \
    && pip3 install --upgrade pip \
    \
    && git lfs install \
    \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# For debug shells, quality of life and OS timezone setting (UTC)
RUN printf "\n. /etc/profile\n" >> /root/.profile
RUN printf "\n. /etc/profile\n" >> /root/.bashrc
RUN printf "\nset mouse=\n" >> /usr/share/vim/vim82/defaults.vim
RUN echo "UTC" > /etc/timezone
ENV TZ=UTC
ENV ENV="/etc/profile"

# Poetry for Python packages
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local/poetry python3 - --yes \
    && ln -s /usr/local/poetry/bin/poetry /usr/bin/poetry \
    \
    && poetry config virtualenvs.create false \
    && poetry config virtualenvs.in-project false

# Sets up virtualenv for dependencies
ENV VIRTUAL_ENV="/opt/venv"
ENV VIRTUAL_ENV_DISABLE_PROMPT=1
ENV POETRY_ACTIVE=1
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN echo "export PATH=$PATH" >> ~/.bashrc \
    && python3 -m venv $VIRTUAL_ENV \
    && /opt/venv/bin/pip install --upgrade --no-cache-dir pip

# Installation of basic Python dependencies specified in pyproject.toml
WORKDIR /app
COPY pyproject.toml poetry.lock /app/
RUN poetry install

# Install xformers for the specified GPU
ARG GPU
RUN case "$GPU" in \
        [aA]10[gG]) /opt/venv/bin/pip install https://github.com/camenduru/stable-diffusion-webui-colab/releases/download/0.0.16/xformers-0.0.16+814314d.d20230119.A10G-cp310-cp310-linux_x86_64.whl;; \
        [tT]4) /opt/venv/bin/pip install https://github.com/camenduru/stable-diffusion-webui-colab/releases/download/0.0.16/xformers-0.0.16+814314d.d20230118-cp310-cp310-linux_x86_64.whl;; \
        *) echo "invalid GPU setting"; exit 1;; \
    esac

# WebUI + extensions
RUN git clone -b v2.0 https://github.com/camenduru/stable-diffusion-webui
RUN wget https://raw.githubusercontent.com/camenduru/stable-diffusion-webui-scripts/main/run_n_times.py -O /app/stable-diffusion-webui/scripts/run_n_times.py
RUN git clone -b v1.6 https://github.com/camenduru/deforum-for-automatic1111-webui /app/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui
RUN git clone -b v2.0 https://github.com/camenduru/stable-diffusion-webui-images-browser /app/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser
RUN git clone -b v2.0 https://github.com/camenduru/sd-civitai-browser /app/stable-diffusion-webui/extensions/sd-civitai-browser
RUN git clone -b v1.6 https://github.com/camenduru/sd-webui-additional-networks /app/stable-diffusion-webui/extensions/sd-webui-additional-networks
RUN git clone https://github.com/Mikubill/sd-webui-controlnet /app/stable-diffusion-webui/extensions/sd-webui-controlnet \
    && (cd /app/stable-diffusion-webui/extensions/sd-webui-controlnet && git checkout 5c74f300c3ac04323963af80dd2b971a7c2b2b29) \
    && mkdir -p /app/stable-diffusion-webui/models/ControlNet

# Prepare WebUI environment
WORKDIR /app/stable-diffusion-webui
COPY config.json ui-config.json /app/stable-diffusion-webui/
RUN python launch.py --exit --skip-torch-cuda-test

# Copy startup scripts
COPY run.py on_start.sh /app/stable-diffusion-webui/
RUN chmod +x on_start.sh

# Run app as non-root user
RUN adduser --disabled-password --gecos '' user
RUN chown -R user:user /app
USER user

EXPOSE 7860

CMD ["python", "run.py", "--force-enable-xformers", "--ui-config-file", "ui-config.json", "--ui-settings-file", "config.json", "--disable-console-progressbars", "--cors-allow-origins", "huggingface.co,hf.space", "--no-progressbar-hiding", "--no-download-sd-model", "--api", "--skip-version-check"]
