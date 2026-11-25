#!/usr/bin/env bash
# Seed TTS 3.0 on Muapi: submit, poll, print the audio URL.
set -euo pipefail
: "${MUAPI_API_KEY:?Set MUAPI_API_KEY}"
BASE=https://api.muapi.ai/api/v1

REQ=$(curl -sS -X POST "$BASE/seed-tts-3.0" \
  -H "x-api-key: $MUAPI_API_KEY" -H "Content-Type: application/json" \
  -d '{"prompt":"Welcome to the show. [laughs] Today we look at how voice models changed storytelling.","voice_id":"stokie_en","style_instructions":"Warm and natural"}' \
  | python3 -c 'import sys,json; print(json.load(sys.stdin)["request_id"])')

while true; do
  OUT=$(curl -sS "$BASE/predictions/$REQ/result" -H "x-api-key: $MUAPI_API_KEY")
  STATUS=$(echo "$OUT" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("status",""))')
  if [ "$STATUS" = "completed" ]; then echo "$OUT" | python3 -c 'import sys,json; print(json.load(sys.stdin)["outputs"][0])'; break; fi
  if [ "$STATUS" = "failed" ]; then echo "$OUT" >&2; exit 1; fi
  sleep 2
done
