import { TELEMETRY_ENDPOINT } from "./telemetry-config.js";

const CONSENT_KEY = "ashes-of-babel:telemetry-consent:v1";
const BROWSER_ID_KEY = "ashes-of-babel:browser-id:v1";
const FIRST_VISIT_KEY = "ashes-of-babel:first-visit-sent:v1";
const SESSION_ID_KEY = "ashes-of-babel:session-id:v1";

const ENDING_CATEGORIES = new Set([
  "consequence_and_memory",
  "epistemic_restraint",
  "governance_failure",
  "existential_cost",
  "rigged_reality"
]);

function safeStorage(storage, operation, fallback = null) {
  try {
    return operation(storage);
  } catch {
    return fallback;
  }
}

function getStored(storage, key) {
  return safeStorage(storage, (target) => target.getItem(key));
}

function setStored(storage, key, value) {
  return safeStorage(storage, (target) => {
    target.setItem(key, value);
    return true;
  }, false);
}

function removeStored(storage, key) {
  safeStorage(storage, (target) => target.removeItem(key));
}

function makeUuid() {
  try {
    return crypto.randomUUID();
  } catch {
    return null;
  }
}

function endpointIsConfigured(endpoint) {
  if (!endpoint) return false;

  try {
    const url = new URL(endpoint, window.location.href);
    return url.protocol === "https:" || url.hostname === "localhost" || url.hostname === "127.0.0.1";
  } catch {
    return false;
  }
}

export function createTelemetry({ notice, allowButton, declineButton, endpoint = TELEMETRY_ENDPOINT }) {
  let sessionActive = false;
  let completionSent = false;

  function consent() {
    return getStored(localStorage, CONSENT_KEY);
  }

  function browserId() {
    const existing = getStored(localStorage, BROWSER_ID_KEY);
    if (existing) return existing;

    const created = makeUuid();
    if (!created || !setStored(localStorage, BROWSER_ID_KEY, created)) return null;
    return created;
  }

  function sessionId() {
    const existing = getStored(sessionStorage, SESSION_ID_KEY);
    if (existing) return existing;

    const created = makeUuid();
    if (!created || !setStored(sessionStorage, SESSION_ID_KEY, created)) return null;
    return created;
  }

  function post(event, endingCategory = null) {
    if (!endpointIsConfigured(endpoint) || consent() !== "allowed") return Promise.resolve(false);

    const currentBrowserId = browserId();
    const currentSessionId = sessionId();
    if (!currentBrowserId || !currentSessionId) return Promise.resolve(false);

    return fetch(endpoint, {
      method: "POST",
      mode: "cors",
      credentials: "omit",
      cache: "no-store",
      keepalive: true,
      referrerPolicy: "no-referrer",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        browserId: currentBrowserId,
        sessionId: currentSessionId,
        event,
        ...(endingCategory ? { endingCategory } : {})
      })
    })
      .then((response) => response.ok)
      .catch(() => false);
  }

  function recordSession() {
    if (!sessionActive || consent() !== "allowed") return;

    if (getStored(localStorage, FIRST_VISIT_KEY) !== "yes") {
      void post("first_visit").then((sent) => {
        if (sent) setStored(localStorage, FIRST_VISIT_KEY, "yes");
      });
    }

    void post("story_start");
  }

  function hideNotice() {
    notice.hidden = true;
  }

  function allow() {
    if (!endpointIsConfigured(endpoint)) {
      hideNotice();
      return;
    }

    setStored(localStorage, CONSENT_KEY, "allowed");
    hideNotice();
    recordSession();
  }

  function decline() {
    setStored(localStorage, CONSENT_KEY, "declined");
    removeStored(localStorage, BROWSER_ID_KEY);
    removeStored(localStorage, FIRST_VISIT_KEY);
    removeStored(sessionStorage, SESSION_ID_KEY);
    hideNotice();
  }

  allowButton.addEventListener("click", allow);
  declineButton.addEventListener("click", decline);

  return {
    startSession() {
      sessionActive = true;

      if (!endpointIsConfigured(endpoint)) return;
      if (consent() === "allowed") recordSession();
      else if (consent() !== "declined") notice.hidden = false;
    },

    trackCompletion(endingCategory) {
      if (!sessionActive || completionSent || !ENDING_CATEGORIES.has(endingCategory)) return;
      completionSent = true;
      void post("story_completion", endingCategory);
    },

    resetSession() {
      sessionActive = false;
      completionSent = false;
      removeStored(sessionStorage, SESSION_ID_KEY);
    }
  };
}
