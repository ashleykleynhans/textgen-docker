#!/usr/bin/env bash

ARGS=("$@" --listen --api --listen-port 3001 --api-port 5000 --trust-remote-code)

if [[ -f /workspace/textgen-model ]];
then
  ARGS=("${ARGS[@]}" --model "$(</workspace/textgen-model)")
fi

VENV_PATH=$(cat /workspace/textgen/venv_path)
source ${VENV_PATH}/bin/activate
cd /workspace/textgen
export PYTHONUNBUFFERED=1
export HF_HOME="/workspace"

# nvidia-* packages installed at system level (not in venv) won't be on
# torch's .so search path - add them all so libcusparseLt and friends resolve
for nvidia_lib in /usr/local/lib/python*/dist-packages/nvidia/*/lib; do
    [[ -d "${nvidia_lib}" ]] && export LD_LIBRARY_PATH="${nvidia_lib}:${LD_LIBRARY_PATH:-}"
done

if [[ ${HF_TOKEN} ]];
then
    export HF_TOKEN="${HF_TOKEN}"
fi

echo "Starting TextGen: ${ARGS[@]}"
python3 server.py "${ARGS[@]}"
