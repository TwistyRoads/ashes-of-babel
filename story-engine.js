const PERSISTENT_TAGS = new Set(["image", "scene", "mood"]);

export function parseTags(rawTags = []) {
  const parsed = {};

  for (const rawTag of rawTags) {
    const separator = rawTag.indexOf(":");
    const key = (separator === -1 ? rawTag : rawTag.slice(0, separator)).trim();
    const value = (separator === -1 ? true : rawTag.slice(separator + 1)).trim();

    if (!key) continue;

    if (key === "effect") {
      parsed.effects ??= [];
      parsed.effects.push(value);
    } else {
      parsed[key] = value;
    }
  }

  return parsed;
}

export function parseLine(rawLine) {
  const text = rawLine.trim();
  const dialogue = text.match(/^([A-Z][A-Z ]+):\s*(.+)$/);

  if (dialogue) {
    return {
      type: "dialogue",
      speaker: dialogue[1],
      text: dialogue[2]
    };
  }

  if (/^END OF ACT [IVX]+$/.test(text)) {
    return { type: "act-break", text };
  }

  if (/^(SYSTEM TIMESTAMP|VR INSTANCE|RULESET|MEMORY INTEGRITY STATUS|ENTROPY BALANCE|NOVELTY INDEX|TRIGGER STATUS):/.test(text)) {
    const separator = text.indexOf(":");
    return {
      type: "telemetry",
      label: text.slice(0, separator),
      text: text.slice(separator + 1).trim()
    };
  }

  if (text === "HARVEST KNIGHTS" || text === "UNSEEN WAR") {
    return { type: "title", text };
  }

  return { type: "prose", text };
}

function makeBeat(meta) {
  return {
    image: meta.image ?? null,
    scene: meta.scene ?? null,
    mood: meta.mood ?? null,
    telemetry: null,
    transition: null,
    effects: [],
    ending: null,
    lines: [],
    choices: [],
    ended: false
  };
}

function updatePersistentMeta(meta, tags) {
  const next = { ...meta };

  for (const key of PERSISTENT_TAGS) {
    if (tags[key] !== undefined) next[key] = tags[key];
  }

  return next;
}

function shouldStartNewBeat(current, tags) {
  if (!current || current.lines.length === 0) return false;

  const imageChanges = tags.image && tags.image !== current.image;
  const telemetryBegins = tags.telemetry && tags.telemetry !== current.telemetry;
  const titleCardBegins = tags.transition === "title_card";

  return Boolean(imageChanges || telemetryBegins || titleCardBegins);
}

function applyTransientTags(beat, tags) {
  if (tags.telemetry) beat.telemetry = tags.telemetry;
  if (tags.transition) beat.transition = tags.transition;
  if (tags.ending) beat.ending = tags.ending;

  if (tags.effects) {
    beat.effects = [...new Set([...beat.effects, ...tags.effects])];
  }
}

export function collectStoryBeats(story, initialMeta = {}) {
  const beats = [];
  let persistentMeta = { ...initialMeta };
  let current = null;

  while (story.canContinue) {
    const rawLine = story.Continue();
    const tags = parseTags(story.currentTags);
    const nextMeta = updatePersistentMeta(persistentMeta, tags);

    if (shouldStartNewBeat(current, tags)) {
      beats.push(current);
      current = null;
    }

    if (!current) current = makeBeat(nextMeta);

    current.image = nextMeta.image ?? current.image;
    current.scene = nextMeta.scene ?? current.scene;
    current.mood = nextMeta.mood ?? current.mood;
    applyTransientTags(current, tags);

    const text = rawLine.trim();
    if (text) current.lines.push(parseLine(text));

    persistentMeta = nextMeta;
  }

  if (!current) current = makeBeat(persistentMeta);

  current.choices = story.currentChoices.map((choice) => ({
    index: choice.index,
    text: choice.text.trim()
  }));
  current.ended = current.choices.length === 0 && !story.canContinue;
  beats.push(current);

  return { beats, persistentMeta };
}
