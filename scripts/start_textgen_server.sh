#!/usr/bin/env bash

ARGS=("$@" --listen --api --listen-port 3000 --api-port 5000 --trust-remote-code)

if [[ -f /workspace/textgen-model ]];
then
  ARGS=("${ARGS[@]}" --model "$(</workspace/textgen-model)")
fi

VENV_PATH=$(cat /workspace/textgen/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/textgen
export PYTHONUNBUFFERED=1
export HF_HOME="/workspace"

if [[ ${HF_TOKEN} ]];
then
    export HF_TOKEN="${HF_TOKEN}"
fi

echo "Starting TextGen: ${ARGS[@]}"
python3 server.py "${ARGS[@]}"
