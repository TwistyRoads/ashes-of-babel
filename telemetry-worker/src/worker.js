const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const EVENT_TYPES = new Set(["first_visit", "story_start", "story_completion"]);
const ENDING_CATEGORIES = new Set([
  "consequence_and_memory",
  "epistemic_restraint",
  "governance_failure",
  "existential_cost",
  "rigged_reality"
]);

function corsHeaders(origin, allowedOrigin) {
  return {
    "Access-Control-Allow-Origin": origin === allowedOrigin ? origin : allowedOrigin,
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Max-Age": "86400",
    Vary: "Origin"
  };
}

function json(data, status = 200, headers = {}) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json; charset=utf-8", ...headers }
  });
}

function validPayload(payload) {
  if (!payload || typeof payload !== "object") return false;
  if (!UUID_PATTERN.test(payload.browserId) || !UUID_PATTERN.test(payload.sessionId)) return false;
  if (!EVENT_TYPES.has(payload.event)) return false;

  if (payload.event === "story_completion") {
    return ENDING_CATEGORIES.has(payload.endingCategory);
  }

  return payload.endingCategory === undefined || payload.endingCategory === null;
}

function authorised(request, secret) {
  const header = request.headers.get("Authorization") || "";
  if (!header.startsWith("Basic ") || !secret) return false;

  try {
    const decoded = atob(header.slice(6));
    const separator = decoded.indexOf(":");
    return separator !== -1 && decoded.slice(separator + 1) === secret;
  } catch {
    return false;
  }
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

async function collect(request, env) {
  const origin = request.headers.get("Origin") || "";
  const headers = corsHeaders(origin, env.SITE_ORIGIN);

  if (origin !== env.SITE_ORIGIN) return json({ ok: false }, 403, headers);

  const contentLength = Number(request.headers.get("Content-Length") || 0);
  if (contentLength > 1024) return json({ ok: false }, 413, headers);

  let payload;
  try {
    payload = await request.json();
  } catch {
    return json({ ok: false }, 400, headers);
  }

  if (!validPayload(payload)) return json({ ok: false }, 400, headers);

  const timestamp = new Date().toISOString();
  const ending = payload.event === "story_completion" ? payload.endingCategory : null;

  await env.DB.batch([
    env.DB.prepare("INSERT OR IGNORE INTO browsers (browser_id, first_seen) VALUES (?, ?)")
      .bind(payload.browserId, timestamp),
    env.DB.prepare("INSERT OR IGNORE INTO sessions (session_id, browser_id, started_at) VALUES (?, ?, ?)")
      .bind(payload.sessionId, payload.browserId, timestamp),
    env.DB.prepare(
      "INSERT OR IGNORE INTO events (browser_id, session_id, event_type, ending_category, recorded_at) VALUES (?, ?, ?, ?, ?)"
    ).bind(payload.browserId, payload.sessionId, payload.event, ending, timestamp)
  ]);

  return json({ ok: true }, 202, headers);
}

async function dashboard(env) {
  const [browserRow, sessionRow, startRow, completionRow, endings] = await Promise.all([
    env.DB.prepare("SELECT COUNT(*) AS count FROM browsers").first(),
    env.DB.prepare("SELECT COUNT(*) AS count FROM sessions").first(),
    env.DB.prepare("SELECT COUNT(*) AS count FROM events WHERE event_type = 'story_start'").first(),
    env.DB.prepare("SELECT COUNT(*) AS count FROM events WHERE event_type = 'story_completion'").first(),
    env.DB.prepare(
      "SELECT ending_category, COUNT(*) AS count FROM events WHERE event_type = 'story_completion' GROUP BY ending_category ORDER BY count DESC"
    ).all()
  ]);

  const uniqueBrowsers = Number(browserRow?.count || 0);
  const sessions = Number(sessionRow?.count || 0);
  const starts = Number(startRow?.count || 0);
  const completions = Number(completionRow?.count || 0);
  const completionRate = starts === 0 ? 0 : (completions / starts) * 100;
  const endingRows = endings.results || [];

  const endingMarkup = endingRows.length
    ? endingRows.map((row) => {
        const count = Number(row.count || 0);
        const share = completions === 0 ? 0 : (count / completions) * 100;
        const label = String(row.ending_category || "unknown").replaceAll("_", " ");
        return `<tr><td>${escapeHtml(label)}</td><td>${count}</td><td>${share.toFixed(1)}%</td></tr>`;
      }).join("")
    : '<tr><td colspan="3">No completed stories yet.</td></tr>';

  return new Response(`<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow"><title>Ashes of Babel — Private Telemetry</title>
<style>body{margin:0;background:#07090d;color:#d8d4ca;font:16px/1.5 system-ui,sans-serif}main{width:min(960px,calc(100% - 2rem));margin:4rem auto}h1{font:2rem Georgia,serif;color:#e6d3a7}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:1rem}.card,table{border:1px solid #4b402a;background:#0d1016}.card{padding:1.25rem}.value{display:block;font-size:2rem;color:#e6d3a7}table{width:100%;margin-top:2rem;border-collapse:collapse}th,td{text-align:left;padding:.8rem;border-bottom:1px solid #29261f}th{color:#b99756}footer{margin-top:2rem;color:#777}</style>
</head><body><main><h1>Ashes of Babel telemetry</h1><section class="cards">
<div class="card"><span class="value">${uniqueBrowsers}</span>unique browsers</div>
<div class="card"><span class="value">${sessions}</span>sessions</div>
<div class="card"><span class="value">${completions}</span>completions</div>
<div class="card"><span class="value">${completionRate.toFixed(1)}%</span>completion rate</div>
</section><table><thead><tr><th>Ending category</th><th>Completions</th><th>Share</th></tr></thead><tbody>${endingMarkup}</tbody></table>
<footer>Aggregate counts only. Refresh for current totals.</footer></main></body></html>`, {
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      "Cache-Control": "no-store",
      "X-Robots-Tag": "noindex, nofollow",
      "Content-Security-Policy": "default-src 'none'; style-src 'unsafe-inline'; base-uri 'none'; frame-ancestors 'none'; form-action 'none'",
      "X-Content-Type-Options": "nosniff",
      "Referrer-Policy": "no-referrer"
    }
  });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (request.method === "OPTIONS" && url.pathname === "/collect") {
      const origin = request.headers.get("Origin") || "";
      if (origin !== env.SITE_ORIGIN) return new Response(null, { status: 403 });
      return new Response(null, { status: 204, headers: corsHeaders(origin, env.SITE_ORIGIN) });
    }

    if (request.method === "POST" && url.pathname === "/collect") {
      return collect(request, env);
    }

    if (request.method === "GET" && url.pathname === "/admin") {
      if (!authorised(request, env.ADMIN_TOKEN)) {
        return new Response("Authentication required.", {
          status: 401,
          headers: { "WWW-Authenticate": 'Basic realm="Ashes of Babel telemetry", charset="UTF-8"' }
        });
      }
      return dashboard(env);
    }

    if (request.method === "GET" && url.pathname === "/health") {
      return json({ ok: true });
    }

    return new Response("Not found.", { status: 404 });
  }
};
