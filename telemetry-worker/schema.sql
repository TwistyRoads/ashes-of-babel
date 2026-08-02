PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS browsers (
  browser_id TEXT PRIMARY KEY,
  first_seen TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  session_id TEXT PRIMARY KEY,
  browser_id TEXT NOT NULL,
  started_at TEXT NOT NULL,
  FOREIGN KEY (browser_id) REFERENCES browsers(browser_id)
);

CREATE TABLE IF NOT EXISTS events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  browser_id TEXT NOT NULL,
  session_id TEXT NOT NULL,
  event_type TEXT NOT NULL CHECK (event_type IN ('first_visit', 'story_start', 'story_completion')),
  ending_category TEXT CHECK (
    ending_category IS NULL OR ending_category IN (
      'consequence_and_memory',
      'epistemic_restraint',
      'governance_failure',
      'existential_cost',
      'rigged_reality'
    )
  ),
  recorded_at TEXT NOT NULL,
  FOREIGN KEY (browser_id) REFERENCES browsers(browser_id),
  FOREIGN KEY (session_id) REFERENCES sessions(session_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS one_first_visit_per_browser
  ON events(browser_id)
  WHERE event_type = 'first_visit';

CREATE UNIQUE INDEX IF NOT EXISTS one_start_per_session
  ON events(session_id)
  WHERE event_type = 'story_start';

CREATE UNIQUE INDEX IF NOT EXISTS one_completion_per_session
  ON events(session_id)
  WHERE event_type = 'story_completion';

CREATE INDEX IF NOT EXISTS events_by_type ON events(event_type);
CREATE INDEX IF NOT EXISTS sessions_by_browser ON sessions(browser_id);
