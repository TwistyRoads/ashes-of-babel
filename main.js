import { Story } from "./vendor/ink.mjs";
import { ACT_LABELS, IMAGE_ASSETS } from "./image-manifest.js";
import { collectStoryBeats } from "./story-engine.js";

const SAVE_KEY = "ashes-of-babel:fracture-point:v1";
const STORY_URL = "./story/story.json";

const ui = {
  app: document.querySelector("#app"),
  stage: document.querySelector("#image-stage"),
  backdrop: document.querySelector("#scene-backdrop"),
  image: document.querySelector("#scene-image"),
  sceneLabel: document.querySelector("#scene-label"),
  storyText: document.querySelector("#story-text"),
  controls: document.querySelector("#story-controls"),
  restart: document.querySelector("#restart-button"),
  fullscreen: document.querySelector("#fullscreen-button"),
  status: document.querySelector("#status-message"),
  loading: document.querySelector("#loading-screen")
};

let story;
let beats = [];
let beatIndex = 0;
let persistentMeta = {};
let currentImageKey = null;
let renderSequence = 0;

function announce(message) {
  ui.status.textContent = message;
}

function saveProgress() {
  if (!story || beats.length === 0) return;

  const payload = {
    version: 1,
    storyState: story.state.ToJson(),
    beats,
    beatIndex,
    persistentMeta
  };

  try {
    localStorage.setItem(SAVE_KEY, JSON.stringify(payload));
  } catch (error) {
    console.warn("Progress could not be saved.", error);
  }
}

function restoreProgress() {
  try {
    const rawSave = localStorage.getItem(SAVE_KEY);
    if (!rawSave) return false;

    const saved = JSON.parse(rawSave);
    if (saved.version !== 1 || !Array.isArray(saved.beats)) return false;

    story.state.LoadJson(saved.storyState);
    beats = saved.beats;
    beatIndex = Math.min(saved.beatIndex ?? 0, beats.length - 1);
    persistentMeta = saved.persistentMeta ?? {};
    announce("Progress restored.");
    return true;
  } catch (error) {
    console.warn("Saved progress was invalid and has been discarded.", error);
    localStorage.removeItem(SAVE_KEY);
    return false;
  }
}

function clearEffects() {
  for (const className of [...ui.app.classList]) {
    if (className.startsWith("effect--") || className.startsWith("transition--")) {
      ui.app.classList.remove(className);
    }
  }
}

async function setSceneImage(imageKey) {
  const sequence = ++renderSequence;
  const asset = imageKey ? IMAGE_ASSETS[imageKey] : null;

  if (!asset) {
    currentImageKey = null;
    ui.stage.classList.add("stage--empty");
    ui.image.removeAttribute("src");
    ui.backdrop.removeAttribute("src");
    ui.image.alt = "";
    return;
  }

  ui.stage.classList.remove("stage--empty");
  ui.image.alt = asset.alt;

  if (currentImageKey === imageKey) return;

  ui.stage.classList.add("stage--changing");

  const preloader = new Image();
  preloader.src = asset.src;

  try {
    await preloader.decode();
  } catch {
    // Browsers may reject decode while still loading a valid image.
  }

  if (sequence !== renderSequence) return;

  ui.image.src = asset.src;
  ui.backdrop.src = asset.src;
  currentImageKey = imageKey;

  requestAnimationFrame(() => {
    requestAnimationFrame(() => ui.stage.classList.remove("stage--changing"));
  });
}

function preloadUpcomingImage() {
  const nextBeat = beats[beatIndex + 1];
  const asset = nextBeat?.image ? IMAGE_ASSETS[nextBeat.image] : null;
  if (!asset || nextBeat.image === currentImageKey) return;

  const image = new Image();
  image.src = asset.src;
}

function renderDialogue(line) {
  const block = document.createElement("p");
  block.className = "dialogue";

  const speaker = document.createElement("span");
  speaker.className = "dialogue__speaker";
  speaker.textContent = line.speaker;

  const speech = document.createElement("span");
  speech.className = "dialogue__speech";
  speech.textContent = line.text;

  block.append(speaker, speech);
  return block;
}

function renderTelemetry(line) {
  const row = document.createElement("p");
  row.className = "telemetry-line";

  const label = document.createElement("span");
  label.className = "telemetry-line__label";
  label.textContent = line.label;

  const value = document.createElement("span");
  value.className = "telemetry-line__value";
  value.textContent = line.text;

  row.append(label, value);
  return row;
}

function renderLine(line) {
  if (line.type === "dialogue") return renderDialogue(line);
  if (line.type === "telemetry") return renderTelemetry(line);

  const element = document.createElement(line.type === "title" ? "h2" : "p");
  element.className = line.type;
  element.textContent = line.text;
  return element;
}

function createContinueButton() {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "continue-button";
  button.innerHTML = "<span>Continue</span><span aria-hidden=\"true\">→</span>";
  button.addEventListener("click", showNextBeat);
  return button;
}

function createChoiceButton(choice, displayIndex) {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "choice-button";
  button.dataset.choiceIndex = String(choice.index);

  const number = document.createElement("span");
  number.className = "choice-button__number";
  number.setAttribute("aria-hidden", "true");
  number.textContent = String(displayIndex + 1).padStart(2, "0");

  const text = document.createElement("span");
  text.className = "choice-button__text";
  text.textContent = choice.text;

  button.append(number, text);
  button.addEventListener("click", () => choose(choice.index));
  return button;
}

function applyBeatPresentation(beat) {
  clearEffects();
  ui.app.dataset.mood = beat.mood ?? "neutral";
  ui.app.dataset.telemetry = beat.telemetry ?? "none";
  ui.app.dataset.scene = beat.scene ?? "unknown";

  if (beat.transition) ui.app.classList.add(`transition--${beat.transition}`);
  for (const effect of beat.effects) ui.app.classList.add(`effect--${effect}`);
}

function renderBeat() {
  const beat = beats[beatIndex];
  if (!beat) return;

  applyBeatPresentation(beat);
  void setSceneImage(beat.image);

  ui.sceneLabel.textContent = ACT_LABELS[beat.scene] ?? "ASHES OF BABEL";
  ui.storyText.replaceChildren(...beat.lines.map(renderLine));
  ui.controls.replaceChildren();

  if (beatIndex < beats.length - 1) {
    ui.controls.append(createContinueButton());
  } else if (beat.choices.length > 0) {
    const group = document.createElement("div");
    group.className = "choice-group";
    group.setAttribute("role", "group");
    group.setAttribute("aria-label", "Choose Neba's response");
    beat.choices.forEach((choice, index) => group.append(createChoiceButton(choice, index)));
    ui.controls.append(group);
  } else if (beat.ended) {
    const ending = document.createElement("p");
    ending.className = "story-complete";
    ending.textContent = "The retained moment is closed.";
    ui.controls.append(ending);
  }

  ui.storyText.scrollTop = 0;
  ui.controls.querySelector("button")?.focus({ preventScroll: true });
  preloadUpcomingImage();
  saveProgress();
}

function collectNextPassage() {
  const result = collectStoryBeats(story, persistentMeta);
  beats = result.beats;
  persistentMeta = result.persistentMeta;
  beatIndex = 0;
  renderBeat();
}

function showNextBeat() {
  if (beatIndex >= beats.length - 1) return;
  beatIndex += 1;
  renderBeat();
}

function choose(choiceIndex) {
  story.ChooseChoiceIndex(choiceIndex);
  collectNextPassage();
}

function restartStory({ ask = true } = {}) {
  if (ask && !window.confirm("Restart Ashes of Babel from the opening telemetry?")) return;

  localStorage.removeItem(SAVE_KEY);
  window.location.reload();
}

async function toggleFullscreen() {
  try {
    if (document.fullscreenElement) {
      await document.exitFullscreen();
    } else {
      await document.documentElement.requestFullscreen();
    }
  } catch (error) {
    console.warn("Fullscreen mode is unavailable.", error);
  }
}

function handleKeyboard(event) {
  if (event.altKey || event.ctrlKey || event.metaKey) return;
  if (event.target instanceof HTMLButtonElement) return;

  const choiceButtons = [...ui.controls.querySelectorAll(".choice-button")];
  const number = Number(event.key);

  if (Number.isInteger(number) && number > 0 && number <= choiceButtons.length) {
    event.preventDefault();
    choiceButtons[number - 1].click();
    return;
  }

  if ((event.key === "Enter" || event.key === " ") && ui.controls.querySelector(".continue-button")) {
    event.preventDefault();
    showNextBeat();
  }
}

async function initialise() {
  try {
    const response = await fetch(STORY_URL);
    if (!response.ok) throw new Error(`Story request failed with ${response.status}.`);

    const storyContent = (await response.text()).replace(/^\uFEFF/, "");
    story = new Story(storyContent);

    if (!restoreProgress()) collectNextPassage();
    else renderBeat();

    ui.loading.hidden = true;
    ui.app.classList.add("app--ready");
  } catch (error) {
    console.error(error);
    ui.loading.innerHTML = `
      <p class="loading-screen__title">The retained moment could not be opened.</p>
      <p>Serve this directory through a local web server or GitHub Pages, then reload.</p>
    `;
  }
}

ui.restart.addEventListener("click", () => restartStory());
ui.fullscreen.addEventListener("click", toggleFullscreen);
document.addEventListener("keydown", handleKeyboard);
document.addEventListener("fullscreenchange", () => {
  ui.fullscreen.setAttribute("aria-pressed", String(Boolean(document.fullscreenElement)));
});

void initialise();
