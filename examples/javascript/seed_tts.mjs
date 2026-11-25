// Seed TTS 3.0 on Muapi: submit, poll, print the audio URL. Node 18+.
const BASE = "https://api.muapi.ai/api/v1";
const headers = { "x-api-key": process.env.MUAPI_API_KEY, "Content-Type": "application/json" };

async function synthesize(text, voiceId = "stokie_en", options = {}) {
  const submit = await fetch(`${BASE}/seed-tts-3.0`, {
    method: "POST",
    headers,
    body: JSON.stringify({ prompt: text, voice_id: voiceId, ...options }),
  });
  if (!submit.ok) throw new Error(await submit.text());
  const { request_id } = await submit.json();
  for (;;) {
    const res = await fetch(`${BASE}/predictions/${request_id}/result`, { headers });
    const data = await res.json();
    if (data.status === "completed") return data.outputs[0];
    if (data.status === "failed") throw new Error(data.error || "generation failed");
    await new Promise((r) => setTimeout(r, 2000));
  }
}

const text = process.argv.slice(2).join(" ") || "Hello from Seed TTS 3.0.";
console.log(await synthesize(text, "stokie_en", { style_instructions: "Warm and natural" }));
