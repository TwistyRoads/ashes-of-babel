# Anonymous telemetry deployment

The collector is a Cloudflare Worker backed by D1. It stores only random browser and session UUIDs, event type, an optional ending category, and server time. It does not read or store IP addresses, user agents, referrers, fingerprints, names, email addresses, or story choice text.

Cloudflare necessarily processes connection metadata such as IP addresses to deliver requests, but this Worker does not access that metadata. Worker observability is disabled in the supplied configuration so request logs are not retained for this application.

## Deploy once

You need a free Cloudflare account and Node.js.

```bash
cd telemetry-worker
cp wrangler.toml.example wrangler.toml
npx wrangler@latest login
npx wrangler@latest d1 create ashes-of-babel-telemetry
```

Copy the returned database ID into `wrangler.toml`, then initialise and deploy:

```bash
npx wrangler@latest d1 execute ashes-of-babel-telemetry --remote --file=schema.sql
npx wrangler@latest secret put ADMIN_TOKEN
npx wrangler@latest deploy
```

Use a long unique value for `ADMIN_TOKEN`. It is not committed to Git.

Wrangler prints the Worker URL after deployment. Append `/collect` and place that complete HTTPS URL in the repository-root `telemetry-config.js`:

```js
export const TELEMETRY_ENDPOINT = "https://YOUR-WORKER.workers.dev/collect";
```

Commit that one configuration change to enable collection. Until then, telemetry is inert and the consent notice remains hidden.

## View private aggregates

Open the Worker's `/admin` URL. The browser will request HTTP Basic credentials:

- Username: anything (for example `admin`)
- Password: the `ADMIN_TOKEN` value

The dashboard shows unique browsers, sessions, completions, completion rate, and ending distribution. No event-level data is exposed.

## Definitions

- **Unique browser:** one consented random UUID stored in that browser's local storage.
- **Session:** one opened or resumed story session. Restarting creates a new session.
- **Completion:** one terminal story state per session.
- **Completion rate:** completed sessions divided by started sessions.

Deleting site data removes the browser ID. A later visit then appears as a new anonymous browser.
