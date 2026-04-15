ARG BASE_IMAGE
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash \
    PATH="/usr/local/cuda/bin:${PATH}"

# Install TextGen
ARG INDEX_URL
ARG TORCH_VERSION
ARG TEXTGEN_VERSION
ENV INDEX_URL=${INDEX_URL}
ENV TORCH_VERSION=${TORCH_VERSION}
ENV TEXTGEN_VERSION=${TEXTGEN_VERSION}
#COPY oobabooga/requirements* ./
COPY --chmod=755 build/install.sh /install.sh
RUN /install.sh && rm /install.sh

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# Copy startup script for TextGen
COPY --chmod=755 scripts/start_textgen_server.sh /textgen/

# Copy scripts to download models
COPY fetch_model.py /textgen/
COPY download_model.py /textgen/

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Set the venv path
ARG VENV_PATH
ENV VENV_PATH=${VENV_PATH}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
