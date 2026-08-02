import worker from "../telemetry-worker/src/worker.js";

const browserId = "c2a80a47-f075-4fc5-9341-9a15245b2133";
const sessionId = "268378da-2367-410a-b6e8-3432de385c2a";
const origin = "https://twistyroads.github.io";
const writes = [];

function statement(sql) {
  return {
    sql,
    values: [],
    bind(...values) {
      this.values = values;
      return this;
    },
    async first() {
      if (sql.includes("FROM browsers")) return { count: 7 };
      if (sql.includes("FROM sessions")) return { count: 11 };
      if (sql.includes("story_start")) return { count: 10 };
      if (sql.includes("story_completion")) return { count: 6 };
      return null;
    },
    async all() {
      return { results: [{ ending_category: "rigged_reality", count: 4 }] };
    }
  };
}

const env = {
  SITE_ORIGIN: origin,
  ADMIN_TOKEN: "test-secret",
  DB: {
    prepare: statement,
    async batch(statements) {
      writes.push(...statements);
      return statements.map(() => ({ success: true }));
    }
  }
};

function collectRequest(payload, requestOrigin = origin) {
  return new Request("https://collector.example/collect", {
    method: "POST",
    headers: { "Content-Type": "application/json", Origin: requestOrigin },
    body: JSON.stringify(payload)
  });
}

const accepted = await worker.fetch(collectRequest({ browserId, sessionId, event: "story_start" }), env);
if (accepted.status !== 202 || writes.length !== 3) throw new Error("Valid story_start was not accepted.");

const completion = await worker.fetch(collectRequest({
  browserId,
  sessionId,
  event: "story_completion",
  endingCategory: "rigged_reality"
}), env);
if (completion.status !== 202) throw new Error("Valid completion was not accepted.");

const invalidEnding = await worker.fetch(collectRequest({
  browserId,
  sessionId,
  event: "story_completion",
  endingCategory: "free_text"
}), env);
if (invalidEnding.status !== 400) throw new Error("Unknown ending category was accepted.");

const foreignOrigin = await worker.fetch(
  collectRequest({ browserId, sessionId, event: "story_start" }, "https://example.com"),
  env
);
if (foreignOrigin.status !== 403) throw new Error("Foreign origin was accepted.");

const unauthorised = await worker.fetch(new Request("https://collector.example/admin"), env);
if (unauthorised.status !== 401) throw new Error("Private dashboard did not require authentication.");

const credentials = Buffer.from("admin:test-secret").toString("base64");
const authorised = await worker.fetch(new Request("https://collector.example/admin", {
  headers: { Authorization: `Basic ${credentials}` }
}), env);
const dashboard = await authorised.text();
if (authorised.status !== 200 || !dashboard.includes("60.0%") || !dashboard.includes("rigged reality")) {
  throw new Error("Private dashboard aggregates were not rendered correctly.");
}

const workerSource = await (await import("node:fs/promises")).readFile(
  new URL("../telemetry-worker/src/worker.js", import.meta.url),
  "utf8"
);
for (const forbidden of ["CF-Connecting-IP", "request.cf", "User-Agent"]) {
  if (workerSource.includes(forbidden)) throw new Error(`Collector accesses forbidden metadata: ${forbidden}`);
}

console.log("Telemetry worker test passed: schema validation, origin gate, aggregate authentication, and privacy contract.");
