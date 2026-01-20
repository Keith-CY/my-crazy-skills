---
name: agent-browser
description: Use when a task needs headless browser automation (navigate, click, fill forms, extract text, take screenshots) and Playwright-based tooling should be avoided; prefer the agent-browser CLI.
---

# agent-browser

## Overview

Use `agent-browser` (CLI) for deterministic, scriptable headless browser automation via snapshots and stable element refs (`@e1`, `@e2`, ...).

## Core Workflow

1. Open a page: `agent-browser open <url>`
2. Get a ref-based accessibility snapshot: `agent-browser snapshot -i`
3. Interact using refs (preferred) or selectors:
   - Click: `agent-browser click @e2`
   - Fill: `agent-browser fill @e3 "text"`
   - Press: `agent-browser press Enter`
4. Extract info:
   - Visible text: `agent-browser get text @e1`
   - URL/title: `agent-browser get url` / `agent-browser get title`
5. Capture artifacts:
   - Screenshot: `agent-browser screenshot --full path/to.png`
   - Trace: `agent-browser trace start` / `agent-browser trace stop path/to-trace.json.gz`

## Quick Reference

### Common Flags

- Reuse a session across commands: `--session <name>` (or `AGENT_BROWSER_SESSION=<name>`)
- Machine-readable output: `--json`
- Debug output: `--debug`
- Run with a visible window (debugging): `--headed`

### Playwright → agent-browser Mapping

| Intent | Playwright concept | `agent-browser` command |
| --- | --- | --- |
| Navigate | `page.goto(url)` | `agent-browser open <url>` |
| Snapshot | a11y snapshot / locator discovery | `agent-browser snapshot -i` |
| Click | `locator.click()` | `agent-browser click <sel>` or `agent-browser click @eN` |
| Fill | `locator.fill()` | `agent-browser fill <sel> <text>` or `agent-browser fill @eN <text>` |
| Type | `locator.type()` | `agent-browser type <sel> <text>` |
| Press key | `page.keyboard.press()` | `agent-browser press <key>` |
| Wait for element | `page.waitForSelector()` | `agent-browser wait <sel>` |
| Read text | `locator.innerText()` | `agent-browser get text <sel>` |
| Screenshot | `page.screenshot()` | `agent-browser screenshot [--full] [path]` |
| Evaluate JS | `page.evaluate()` | `agent-browser eval <js>` |

## Examples

### Login/Form Flow (ref-first)

```bash
export AGENT_BROWSER_SESSION="acme-login"
agent-browser open "https://example.com/login"
agent-browser snapshot -i
agent-browser fill @e12 "user@example.com"
agent-browser fill @e13 "correct horse battery staple"
agent-browser click @e14
agent-browser wait @e20
agent-browser get text @e20
```

### Auth Headers (origin-scoped)

```bash
agent-browser open "https://example.com"
agent-browser --headers '{"Authorization":"Bearer YOUR_TOKEN"}' open "https://example.com/protected"
agent-browser snapshot -i --json
```

## Common Mistakes

- Not using `--session` when a multi-step flow spans multiple commands.
- Clicking with brittle CSS selectors when a `snapshot -i` ref is available.
- Forgetting `--json` when downstream steps require structured parsing.
- In sandboxed environments, the `agent-browser` daemon may fail to start due to restricted writes to user cache/home; rerun with the necessary filesystem permissions.
- If the browser can’t launch, run `agent-browser install` (may require network access).
