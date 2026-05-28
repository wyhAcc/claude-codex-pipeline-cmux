# Claude Codex Pipeline for cmux

This tool runs a three-phase local workflow:

1. Claude Code creates an architecture plan.
2. Codex implements the plan in the current working directory.
3. Claude Code reviews the result against the original plan.

The executable entry point is:

```bash
claude-codex-pipeline-cmux [--mode exec|tui] "<task description>"
```

## Install

From this repository:

```bash
./install.sh
```

Make sure `~/.local/bin` is on `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Requirements

Install and log in to:

- cmux
- Claude Code CLI, available as `claude`
- Codex CLI, available as `codex`

Also required:

- `python3`
- `git`
- `realpath`
- standard Unix commands: `bash`, `find`, `grep`, `head`, `tee`, `sed`, `cut`, `sleep`

Optional:

- Google Chrome or a default browser, used only when the target directory contains `index.html`.

## Preflight

The script checks requirements before starting:

- cmux is installed and reachable.
- The current shell can be identified by cmux.
- `claude` and `codex` are installed and usable.
- `python3`, `git`, and supporting shell commands exist.
- The current directory git status is understood.

If cmux is installed somewhere non-standard, set `CMUX`:

```bash
CMUX=/path/to/cmux claude-codex-pipeline-cmux --mode exec "build a static todo app"
```

## Usage

Run from the project directory you want Codex to edit:

```bash
cd /path/to/project
claude-codex-pipeline-cmux --mode exec "implement the feature described in README.md"
```

Use quotes around the task description. The script now accepts multi-word tasks, but quoting keeps shell parsing predictable.

### Modes

`exec` mode runs Codex automatically and continues to review when Codex exits:

```bash
claude-codex-pipeline-cmux --mode exec "create index.html, style.css, and app.js for a calculator"
```

`tui` mode opens the interactive Codex UI in the cmux split. When done, type `/exit` in Codex to trigger review:

```bash
claude-codex-pipeline-cmux --mode tui "refactor the dashboard UI"
```

If `--mode` is omitted, the script asks interactively when stdin is a terminal.

## Git Guidance

Use a git repository for real work:

```bash
cd /path/to/project
git status
claude-codex-pipeline-cmux --mode exec "your task"
git diff
```

Recommended team workflow:

1. Start from a clean working tree.
2. Run the pipeline.
3. Read the review file printed at the end.
4. Inspect `git diff`.
5. Commit only after reviewing the changes.

If the current directory is not a git repo, `exec` mode uses `--skip-git-repo-check`. In `tui` mode, the script may initialize git in the target directory because interactive Codex expects a repo.

## Outputs

Each run writes temporary files:

- Plan: `/tmp/pipeline-plan-<pid>.md`
- Review: `/tmp/pipeline-review-<pid>.md`

The review prints a compact PASS/WARN/FAIL summary at the end.

## Safety Notes

- Run only in directories where Codex is allowed to write.
- Do not run in directories containing secrets, customer data, or production-only configuration unless that data is safe to send to Claude/Codex.
- The script sends directory listings, file tree summaries, diffs, and file excerpts to Claude/Codex.
- Review generated code before committing or shipping it.

## Troubleshooting

`cmux is installed but this shell is not identifiable by cmux`

Run the command from a cmux terminal/session.

`claude CLI is installed but not usable`

Check that Claude Code is installed, on `PATH`, and logged in.

`codex CLI is installed but not usable`

Check that Codex is installed, on `PATH`, and logged in.

`Current directory is not a git repo`

This is a warning for `exec` mode. For team use, prefer initializing git first:

```bash
git init
git add .
git commit -m "initial state"
```
