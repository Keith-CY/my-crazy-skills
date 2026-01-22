# Skills.sh Popular Sync Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a GitHub Action that periodically (and manually) syncs skills.sh popular skills (installs >= 1000) into this repo as git submodules.

**Architecture:** Fetch and parse skills.sh homepage payload, extract unique GitHub `owner/repo` sources for popular skills, then `git submodule add` any missing repos under `skills/popular/` and commit changes back to `main`.

**Tech Stack:** GitHub Actions, Bash, Python 3 (stdlib-only).

### Task 1: Add skills.sh parser script

**Files:**
- Create: `scripts/skills-sh-popular-sources.py`

**Steps:**
1. Fetch `https://skills.sh/` HTML.
2. Parse Next.js inline payload (`self.__next_f.push`) to extract `allTimeSkills` / `trendingSkills`.
3. Filter to `installs >= 1000`.
4. Output unique `source` repositories (`owner/repo`) for downstream automation.

**Quick check:**
- Run: `python3 scripts/skills-sh-popular-sources.py --view all-time --min-installs 1000 --format json | python3 -m json.tool | head`

### Task 2: Add repo sync script (submodules)

**Files:**
- Create: `scripts/sync-skills-from-skills-sh.sh`

**Steps:**
1. Call the parser script to get a list of sources.
2. Skip sources already present in `.gitmodules`.
3. Add missing sources as submodules under `skills/popular/<owner>--<repo>`.

**Quick check:**
- Run: `bash scripts/sync-skills-from-skills-sh.sh` (requires git repo + network to clone submodules)

### Task 3: Add GitHub Action workflow

**Files:**
- Create: `.github/workflows/update-skills-from-skills-sh.yml`

**Steps:**
1. Run on `schedule` and `workflow_dispatch`.
2. Execute sync script.
3. Commit + push if `.gitmodules` / `skills/popular/` changed.

