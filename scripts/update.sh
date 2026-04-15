#!/usr/bin/env bash

echo "Updating TextGen"
source /workspace/venv/bin/activate
cd /workspace/textgen
git checkout main
git pull
pip3 install -r requirements.txt
echo "Update complete"
