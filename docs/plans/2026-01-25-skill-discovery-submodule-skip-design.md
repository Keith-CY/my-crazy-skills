# Fix skill discovery submodule skip logic

## Context
The `skills-discovery` workflow adds new skills as git submodules based on issue input and OpenCode categorization. A recent run skipped adding a tooling skill because the category directory `skills/tooling` already existed. That indicates the skip logic is treating the category directory as the skill path when the repo-derived path is invalid or missing, and the workflow currently skips on any filesystem existence at the target path.

## Problem
The workflow uses `[[ -e "$SKILL_PATH" ]]` to decide that a skill already exists. If `SKILL_PATH` collapses to a category directory, this check always succeeds and incorrectly skips new skills. It also does not verify that a path corresponds to a submodule for the requested repository, so path existence can mask conflicts or non-submodule directories.

## Goals
- Only skip when an existing submodule path matches the requested repo URL.
- Prevent invalid repo URLs from producing empty or malformed skill paths.
- Surface conflicts (path exists but is not a matching submodule) instead of silently skipping.
- Preserve current behavior for already-added repos by URL.

## Non-goals
- Changing how OpenCode categorizes skills.
- Adding new CI jobs or altering PR creation flow.
- Rewriting the entire discovery workflow.

## Proposed changes
1. Build a path-to-normalized-URL map from `.gitmodules` in the “Check existing submodules” step and emit:
   - `/tmp/existing_submodule_path_url.txt`
   - `/tmp/existing_submodule_paths.txt`
   - `/tmp/existing_submodule_urls.txt`
2. Validate that `REPO_URL_NORM` matches `https://github.com/<owner>/<repo>` before deriving `REPO_SLUG` and `SKILL_PATH` for repo items.
3. Replace the skip condition for submodules:
   - If `SKILL_PATH` is an existing submodule with the same URL, skip.
   - If `SKILL_PATH` exists as a submodule with a different URL, treat as a conflict.
   - If `SKILL_PATH` exists on disk but is not a submodule, treat as a conflict.
4. (Optional logging) Print gitlink SHA when skipping a matched submodule to show commit alignment in logs.

## Decision
Implement the new validation and path-aware skip logic. This prevents category directory existence from causing false skips and ensures the workflow checks for a matching skill submodule rather than a directory.

## Verification
- Trigger the workflow with a tooling repo URL that previously skipped (e.g., `https://github.com/resend/email-best-practices`).
- Confirm the log shows either “Adding” or “Skipping existing submodule (path+url match)” with the expected gitlink SHA.
- Confirm conflicts are clearly logged if a path is pre-existing but mismatched.
