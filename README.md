# Seed TTS 3.0 API: Multilingual Text to Speech with 520 Voices, Chinese Dialects and Style Instructions on Muapi

An API guide and runnable examples for **Seed TTS 3.0**, ByteDance's text-to-speech model, called through [Muapi](https://muapi.ai). See the request and response schema, the voice and language options, pricing, and copy-paste cURL, Python and JavaScript examples. This guide covers the Muapi `seed-tts-3.0` endpoint only.

## Related Projects

- [MuAPI](https://muapi.ai) — Unified API for image, video, and audio generation across hundreds of AI models.
- [Seed TTS 3.0 on MuAPI](https://muapi.ai/seed-tts-api) — Landing page for the Seed TTS 3.0 API.
- [Text-to-Speech-API](https://github.com/Anil-matcha/Text-to-Speech-API) — compare every text-to-speech endpoint on Muapi.
- [Voice-Cloning-API](https://github.com/Anil-matcha/Voice-Cloning-API) — create a custom voice from a short sample.
- [Speech-to-Text-API](https://github.com/Anil-matcha/Speech-to-Text-API) — transcription endpoints.

## Overview

- [Seed TTS 3.0 API landing page](https://muapi.ai/seed-tts-api)
- [Seed TTS 3.0 playground](https://muapi.ai/playground/seed-tts-3.0)
- [Text to speech comparison](https://muapi.ai/text-to-speech)
- [Muapi API documentation](https://muapi.ai/docs/api-reference)
- [Create or manage an API key](https://muapi.ai/access-keys)

Requests go to `https://api.muapi.ai/api/v1/seed-tts-3.0` with an `x-api-key` header. A submission returns a `request_id`; poll `GET /api/v1/predictions/{request_id}/result` until the task is `completed`. The audio URL is in `outputs`. Pricing is **$0.025 per 1,000 characters** of text (a 4,000-character script costs $0.10). Audio tags such as `[laughs]` count toward the billed characters, and failed requests are refunded.

## What is Seed TTS 3.0?

Seed TTS 3.0 is ByteDance's text-to-speech model. It offers:

- **520 preset voices** across English, Chinese, Japanese, Korean, Indonesian, Spanish, French, German, Arabic, Thai, Vietnamese and more;
- **100+ languages**, including Cantonese and Chinese dialects such as Sichuanese, Shanghainese and Taiwanese;
- **style instructions**: plain-English direction for tone, emotion and pace;
- **audio tags** in the text, such as `[laughs]` or `[sighs]`, for non-verbal sounds;
- **speed, volume and pitch** controls;
- **MP3 (24 kHz) or Ogg Opus (48 kHz)** output, up to **10,000 characters** per request.

## Request schema

`POST https://api.muapi.ai/api/v1/seed-tts-3.0`

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `prompt` | string | Yes | — | Text to speak, 1 to 10,000 characters. Audio tags count toward billed characters. |
| `voice_id` | enum | No | `stokie_en` | One of the 520 preset voices. The suffix is the voice's primary language. |
| `language_code` | enum | No | `auto` | `auto`, a language such as `en`, `ja`, `es-MX`, or a dialect such as `zh-CN-x-sichuan`. |
| `style_instructions` | string | No | — | Direction for tone, emotion and pace, up to 1,000 characters. |
| `speed` | number | No | `1` | 0.5 to 2. |
| `volume` | number | No | `1` | 0.5 to 2. |
| `pitch` | integer | No | `0` | Semitones, -12 to 12. |
| `output_format` | enum | No | `mp3` | `mp3` or `ogg_opus`. |

Chinese dialect codes: `zh-CN-x-beijing`, `-changsha`, `-dongbei`, `-henan`, `-hubei`, `-kejia`, `-minnan`, `-nanchang`, `-nanjing`, `-shaanxi`, `-shandong`, `-shanghai`, `-sichuan`, `-taiwan`, `-tangshan`, `-tianjin`. Cantonese is `yue`.

## Voices

Voice IDs end with the voice's primary language. Counts below add up to 520; the full list is the `voice_id` enum in the [playground](https://muapi.ai/playground/seed-tts-3.0).

| Language | Suffix | Voices | Examples |
|---|---|---|---|
| English | `_en` | 110 | `owen_en`, `mason_en`, `zendaya_en` |
| Chinese | `_zh` | 79 | `pigsy_zh`, `zhuang_zhou_zh`, `lin_zhiya_zh` |
| Indonesian | `_id` | 74 | `ayu_id`, `bayu_id`, `citra_id` |
| Japanese | `_ja` | 49 | `kenta_ja`, `yusuke_ja`, `takumi_ja` |
| Korean | `_ko` | 20 | `jiwoo_ko`, `soyeon_ko`, `eunji_ko` |
| Malay | `_ms` | 22 | `amir_ms`, `qis_ms`, `haziq_ms` |
| Thai | `_th` | 20 | `chatri_th`, `tess_th`, `paran_th` |
| Filipino | `_fil` | 5 | `jonathan_fil`, `hervie_fil`, `ed_fil` |
| Vietnamese | `_vi` | 14 | `wumg_vi`, `wu_vi`, `ruan_vi` |
| Urdu | `_ur` | 1 | `sana_ur` |
| Turkish | `_tr` | 1 | `yilmaz_tr` |
| Telugu | `_te` | 2 | `ananya_te`, `kiran_te` |
| Marathi | `_mr` | 1 | `aditi_mr` |
| Gujarati | `_gu` | 2 | `hetal_gu`, `meera_gu` |
| German | `_de` | 7 | `sven_de`, `sammy_de`, `stella_de` |
| Spanish | `_es` | 25 | `alvaro_es`, `romina_es`, `nico_es` |
| French | `_fr` | 11 | `usseau_fr`, `mathieu_fr`, `elodie_fr` |
| Italian | `_it` | 4 | `luca_it`, `matteo_it`, `enzo_it` |
| Russian | `_ru` | 17 | `ksenia_ru`, `silas_ru`, `pavel_ru` |
| Swahili | `_sw` | 4 | `amani_sw`, `zuri_sw`, `neema_sw` |
| Spanish (Mexico) | `_es_mx` | 26 | `migu_es_mx`, `marcelo_es_mx`, `leslie_es_mx` |
| Portuguese (Brazil) | `_pt_br` | 18 | `rael_pt_br`, `toby_pt_br`, `camila_pt_br` |
| Spanish (Argentina) | `_es_ar` | 1 | `malena_es_ar` |
| Arabic | `_ar` | 7 | `youssef_ar`, `rmya_ar`, `fatma_ar` |
## Examples

### cURL

```bash
curl -X POST https://api.muapi.ai/api/v1/seed-tts-3.0 \
  -H "x-api-key: $MUAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"The lighthouse keeper climbed the last step, set his lantern on the sill, and listened.","voice_id":"owen_en","language_code":"en","style_instructions":"Slow, hushed storytelling, like reading a ghost story by candlelight."}'

# Response: {"request_id":"REQUEST_ID"}
curl https://api.muapi.ai/api/v1/predictions/REQUEST_ID/result -H "x-api-key: $MUAPI_API_KEY"
```

### Sichuanese dialect

```bash
curl -X POST https://api.muapi.ai/api/v1/seed-tts-3.0 \
  -H "x-api-key: $MUAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"老板，来碗担担面，多放点花椒，莫放香菜，要辣得巴适！","voice_id":"lin_zhiya_zh","language_code":"zh-CN-x-sichuan"}'
```

Runnable versions are in [`examples/`](examples): [`curl.sh`](examples/curl.sh), [`python/seed_tts.py`](examples/python/seed_tts.py) and [`javascript/seed_tts.mjs`](examples/javascript/seed_tts.mjs). Each reads `MUAPI_API_KEY` from the environment, submits a request, polls until completion and prints the audio URL. They follow the documented schema but have not been verified against a live call.

## Seed TTS 3.0 vs other Muapi speech models

| Endpoint | Best for | Price |
|---|---|---|
| `seed-tts-3.0` | Many languages, dialects and voices; style instructions | $0.025 / 1,000 chars |
| `elevenlabs-v4-turbo` | Fast English narration | $0.04 / 1,000 chars |
| `elevenlabs-v4` | Expressive English speech | $0.08 / 1,000 chars |

See the [text-to-speech comparison](https://muapi.ai/text-to-speech) for the full lineup.

## FAQ

**How long can the text be?** 1 to 10,000 characters per request.

**Do audio tags cost extra?** Tag characters count toward the 1,000-character billing unit; there is no separate fee.

**What if a request fails?** Failed requests are refunded.

**Which output formats are available?** MP3 (24 kHz) and Ogg Opus (48 kHz).

## License

MIT
