import { createTelemetry } from "../telemetry.js";

class MemoryStorage {
  constructor() {
    this.values = new Map();
  }

  getItem(key) {
    return this.values.get(key) ?? null;
  }

  setItem(key, value) {
    this.values.set(key, String(value));
  }

  removeItem(key) {
    this.values.delete(key);
  }
}

function button() {
  return {
    click: null,
    addEventListener(type, handler) {
      if (type === "click") this.click = handler;
    }
  };
}

globalThis.window = { location: { href: "https://twistyroads.github.io/ashes-of-babel/" } };
globalThis.localStorage = new MemoryStorage();
globalThis.sessionStorage = new MemoryStorage();

const requests = [];
globalThis.fetch = async (url, options) => {
  requests.push({ url, options, payload: JSON.parse(options.body) });
  return { ok: true };
};

const notice = { hidden: true };
const allowButton = button();
const declineButton = button();
const telemetry = createTelemetry({
  notice,
  allowButton,
  declineButton,
  endpoint: "https://collector.example/collect"
});

telemetry.startSession();
if (notice.hidden || requests.length !== 0) throw new Error("Telemetry ran before consent.");

allowButton.click();
await new Promise((resolve) => setTimeout(resolve, 0));
if (!notice.hidden || requests.length !== 2) throw new Error("Consent did not create first-visit and start events.");

const [firstVisit, storyStart] = requests.map((request) => request.payload.event);
if (firstVisit !== "first_visit" || storyStart !== "story_start") {
  throw new Error("Initial telemetry event sequence was incorrect.");
}

for (const request of requests) {
  const keys = Object.keys(request.payload).sort().join(",");
  if (keys !== "browserId,event,sessionId") throw new Error(`Unexpected telemetry fields: ${keys}`);
  if (request.options.credentials !== "omit" || request.options.referrerPolicy !== "no-referrer") {
    throw new Error("Privacy-preserving fetch options were not applied.");
  }
}

telemetry.trackCompletion("rigged_reality");
telemetry.trackCompletion("governance_failure");
await new Promise((resolve) => setTimeout(resolve, 0));
if (requests.length !== 3 || requests[2].payload.endingCategory !== "rigged_reality") {
  throw new Error("Completion was not constrained to one ending category per session.");
}

telemetry.resetSession();
if (sessionStorage.getItem("ashes-of-babel:session-id:v1")) throw new Error("Restart did not rotate the session.");

globalThis.fetch = async () => {
  throw new Error("collector unavailable");
};
const failureSafe = createTelemetry({
  notice: { hidden: true },
  allowButton: button(),
  declineButton: button(),
  endpoint: "https://collector.example/collect"
});
failureSafe.startSession();
failureSafe.trackCompletion("epistemic_restraint");
await new Promise((resolve) => setTimeout(resolve, 0));

console.log("Telemetry client test passed: consent gate, minimal payload, session rotation, and failure isolation.");
