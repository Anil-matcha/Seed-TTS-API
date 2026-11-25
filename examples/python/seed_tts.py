"""Seed TTS 3.0 on Muapi: submit, poll, print the audio URL. Requires `requests`."""
import os
import sys
import time

import requests

BASE = "https://api.muapi.ai/api/v1"
HEADERS = {"x-api-key": os.environ["MUAPI_API_KEY"], "Content-Type": "application/json"}


def synthesize(text: str, voice_id: str = "stokie_en", **options) -> str:
    body = {"prompt": text, "voice_id": voice_id, **options}
    r = requests.post(f"{BASE}/seed-tts-3.0", headers=HEADERS, json=body, timeout=60)
    r.raise_for_status()
    request_id = r.json()["request_id"]
    while True:
        res = requests.get(f"{BASE}/predictions/{request_id}/result", headers=HEADERS, timeout=60)
        res.raise_for_status()
        data = res.json()
        if data.get("status") == "completed":
            return data["outputs"][0]
        if data.get("status") == "failed":
            raise RuntimeError(data.get("error") or "generation failed")
        time.sleep(2)


if __name__ == "__main__":
    text = " ".join(sys.argv[1:]) or "Hello from Seed TTS 3.0."
    print(synthesize(text, style_instructions="Warm and natural", speed=1.0, pitch=0))
