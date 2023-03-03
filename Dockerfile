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

# Run app as non-root user
RUN adduser --disabled-password --gecos '' user
RUN chown -R user:user /app /opt/venv
USER user

# Installation of basic Python dependencies specified in pyproject.toml
WORKDIR /app
COPY pyproject.toml poetry.lock /app/
RUN poetry install

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
RUN /opt/venv/bin/python launch.py --exit --skip-torch-cuda-test --xformers

# Patch WebUI
RUN sed -i -e 's/                show_progress=False,/                show_progress=True,/g' modules/ui.py
RUN sed -i -e 's/shared.demo.launch/shared.demo.queue().launch/g' webui.py
RUN sed -i -e 's/ outputs=\[/queue=False, &/g' modules/ui.py
RUN sed -i -e 's/               queue=False,  /                /g' modules/ui.py

# Copy startup scripts
COPY run.py on_start.sh /app/stable-diffusion-webui/
RUN chmod +x on_start.sh

EXPOSE 7860

CMD ["/opt/venv/bin/python", "run.py", "--force-enable-xformers", "--xformers", "--listen", "--enable-insecure-extension-access", "--ui-config-file", "ui-config.json", "--ui-settings-file", "config.json", "--disable-console-progressbars", "--cors-allow-origins", "huggingface.co,hf.space", "--no-progressbar-hiding", "--enable-console-prompts", "--no-download-sd-model", "--api", "--skip-version-check"]
