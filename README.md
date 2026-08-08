# Ashes of Babel: The Fracture Point

A cinematic branching narrative from the *Harvest Knights* universe.

The player joins Cain and Neba inside a retained moment at the destruction of Babel. The visible history is fixed; its meaning is not. Investigation, judgement, and counterfactual replay determine what Neba is able to recognise about the boundary surrounding their reality.

## Story origins

The interactive narrative was adapted from an earlier prose story. The original source story and a short explanation of how the linear fiction was transformed into a branching narrative are preserved under [`story-origins/`](story-origins/).

## Play locally

The project is a static site, but it must be served over HTTP because the browser loads the compiled Ink story with `fetch`.

From the repository root:

```bash
python3 -m http.server 8000
```

Then open <http://localhost:8000>.

Progress is saved automatically in the browser. The restart control in the upper-right clears that save.

## Anonymous telemetry

Optional, consent-based telemetry can count unique browsers, sessions, completions, completion rate, and ending distribution. It never records identity, contact details, IP addresses, browser fingerprints, referrers, or story choice text. Collection failures are deliberately ignored by the player so they cannot interrupt the story.

The browser client is disabled until a collector URL is added to `telemetry-config.js`. Deployment and private-dashboard instructions are in [`telemetry-worker/README.md`](telemetry-worker/README.md).

## GitHub Pages

The checked-in files are ready to serve from the repository root. In GitHub:

1. Open **Settings → Pages**.
2. Choose **Deploy from a branch**.
3. Select the public branch and `/ (root)`.
4. Save and wait for the deployment URL.

All asset paths are relative, so the site works under a GitHub Pages project subdirectory.

## Project structure

```text
.
├── index.html                 Browser shell
├── style.css                  Responsive cinematic presentation
├── main.js                    Player UI, persistence, and controls
├── story-engine.js            Ink output → visual beat adapter
├── telemetry.js               Consent and failure-isolated event client
├── telemetry-config.js        Serverless collector URL (blank = disabled)
├── telemetry-worker/          Collector, D1 schema, and private dashboard
├── image-manifest.js          Image paths, alt text, and act labels
├── assets/images/             Web-optimised WebP assets used at runtime
├── images/                    Original PNG masters
├── src/                       Authoritative Ink source
├── story/story.json           Compiled Ink story
├── story-origins/             Original prose source and adaptation context
├── vendor/                    Pinned inkjs browser runtime and licence
├── scripts/                   Build audits
└── tests/                     Runtime smoke test
```

## Rebuild and verify

The deployed site does not require Node.js. Node is needed only when recompiling the Ink source or running repository checks.

```bash
npm install
npm run build
```

`npm run build` recompiles the Ink source, runs a complete smoke route, and verifies that every `# image:` cue agrees with both the manifest and the WebP assets on disk.

## Presentation contract

Ink remains presentation-independent. Tags emitted by the story drive the browser layer:

```ink
# scene:frozen_babel
# image:frozen_babel
# mood:suspended
# effect:freeze
```

Whenever a new image tag appears, the browser creates a new visual beat. This prevents consecutive cinematic moments from being consumed before the screen paints them. Actual Ink choices remain the only branching controls; visual beats use a neutral **Continue** action.

## Rights

Story, characters, world, and original artwork © Joseph Kristiansen. All rights reserved.

The bundled inkjs runtime is distributed under its MIT licence; see `vendor/INKJS_LICENSE.md`.
