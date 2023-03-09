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
        curl \
        vim \
        wget \
        git \
        git-lfs \
        tzdata \
        bash \
        ca-certificates \
        libreadline8 \
        bzip2 \
        psmisc \
        procps \
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

# OS timezone setting (UTC)
RUN echo "UTC" > /etc/timezone
ENV TZ=UTC

# Poetry for Python packages
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local/poetry python3 - --yes \
    && ln -s /usr/local/poetry/bin/poetry /usr/bin/poetry \
    \
    && poetry config virtualenvs.create false \
    && poetry config virtualenvs.in-project false

# Create non-root user
ENV ENV="/etc/profile"
RUN adduser --disabled-password --gecos '' user && \
    mkdir -p /app && \
    chown -R user:user /app && \
    printf "\n. /etc/profile\n" >> /home/user/.profile \
    printf "\n. /etc/profile\n" >> /home/user/.bashrc

# Sets up virtualenv for dependencies
ENV VIRTUAL_ENV="/opt/venv"
ENV VIRTUAL_ENV_DISABLE_PROMPT=1
ENV POETRY_ACTIVE=1
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN echo "export PATH=$PATH" >> /home/user/.bashrc \
    && python3 -m venv $VIRTUAL_ENV \
    && /opt/venv/bin/pip install --upgrade --no-cache-dir pip \
    && chown -R user:user /opt/venv

# Run as non-root user
USER user
WORKDIR /app

# Installation of basic Python dependencies specified in pyproject.toml
COPY --chown=user:user pyproject.toml poetry.lock /app/
RUN poetry install

# AUTOMATIC1111' WebUI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /app/stable-diffusion-webui \
    && (cd /app/stable-diffusion-webui && git checkout 0cc0ee1bcb4c24a8c9715f66cede06601bfc00c8)

# Deforum extension
RUN git clone https://github.com/deforum-art/deforum-for-automatic1111-webui /app/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui \
    && (cd /app/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui && git checkout b60d999202f0fd2b386150d0938c43e639db8643)

# Images Browser WebUI extension
RUN git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser /app/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser \
    && (cd /app/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser && git checkout a42c7a30181636a05815e62426d5eff4d3340529)

# CiviTAI Browser WebUI extension
RUN git clone https://github.com/Vetchems/sd-civitai-browser /app/stable-diffusion-webui/extensions/sd-civitai-browser \
    && (cd /app/stable-diffusion-webui/extensions/sd-civitai-browser && git checkout b25a5daf7df3f6340d3e243d533228d8ade5288d)

# Additional Networks WebUI extension
RUN git clone https://github.com/kohya-ss/sd-webui-additional-networks /app/stable-diffusion-webui/extensions/sd-webui-additional-networks \
    && (cd /app/stable-diffusion-webui/extensions/sd-webui-additional-networks && git checkout 822f2136fa6d63b85663597b03ef3edafab01187) \
    && mkdir -p /app/stable-diffusion-webui/extensions/sd-webui-additional-networks/models/LoRA

# ControlNet WebUI extension
RUN git clone https://github.com/Mikubill/sd-webui-controlnet /app/stable-diffusion-webui/extensions/sd-webui-controlnet \
    && (cd /app/stable-diffusion-webui/extensions/sd-webui-controlnet && git checkout 5c74f300c3ac04323963af80dd2b971a7c2b2b29) \
    && mkdir -p /app/stable-diffusion-webui/models/ControlNet

# Prepare WebUI environment
WORKDIR /app/stable-diffusion-webui
RUN /opt/venv/bin/python launch.py --exit --skip-torch-cuda-test --xformers

# Patch WebUI
RUN sed -i -e 's/                show_progress=False,/                show_progress=True,/g' modules/ui.py
RUN sed -i -e 's/shared.demo.launch/shared.demo.queue().launch/g' webui.py
RUN sed -i -e 's/ outputs=\[/queue=False, &/g' modules/ui.py
RUN sed -i -e 's/               queue=False,  /                /g' modules/ui.py

# Copy startup scripts
COPY --chown=user:user run.py on_start.sh config.json ui-config.json shared-config.json shared-ui-config.json /app/stable-diffusion-webui/
RUN chmod +x on_start.sh

EXPOSE 7860

CMD ["/opt/venv/bin/python", "run.py", "--force-enable-xformers", "--xformers", "--listen", "--enable-insecure-extension-access", "--ui-config-file", "ui-config.json", "--ui-settings-file", "config.json", "--disable-console-progressbars", "--cors-allow-origins", "huggingface.co,hf.space", "--no-progressbar-hiding", "--enable-console-prompts", "--no-download-sd-model", "--api", "--skip-version-check"]
