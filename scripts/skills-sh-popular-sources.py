#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
import sys
import urllib.request
from collections import defaultdict
from dataclasses import dataclass
from typing import Any, Iterable


@dataclass(frozen=True)
class Skill:
    source: str
    skill_id: str
    name: str
    installs: int


def _fetch_text(url: str, timeout_seconds: int) -> str:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": "my-crazy-skills/skills-sh-sync (+https://github.com/Keith-CY/my-crazy-skills)",
            "Accept": "text/html,*/*",
        },
    )
    with urllib.request.urlopen(request, timeout=timeout_seconds) as response:
        charset = response.headers.get_content_charset() or "utf-8"
        return response.read().decode(charset, errors="replace")


def _iter_next_push_strings(html: str) -> Iterable[str]:
    # Next.js inlines RSC payload chunks like:
    #   self.__next_f.push([1,"<JSON-escaped string>"])
    pattern = re.compile(r'self\.__next_f\.push\(\[1,"((?:\\.|[^"\\])*)"\]\)')
    for match in pattern.finditer(html):
        escaped = match.group(1)
        yield json.loads(f"\"{escaped}\"")


def _find_skills_payload(push_strings: Iterable[str]) -> dict[str, Any] | None:
    for push_string in push_strings:
        if "allTimeSkills" not in push_string and "trendingSkills" not in push_string:
            continue
        if ":" not in push_string:
            continue
        _, payload = push_string.split(":", 1)
        try:
            data = json.loads(payload)
        except json.JSONDecodeError:
            continue

        skills_object = _walk_find_dict_with_keys(data, {"allTimeSkills", "trendingSkills"})
        if skills_object is not None:
            return skills_object
    return None


def _walk_find_dict_with_keys(value: Any, required_keys: set[str]) -> dict[str, Any] | None:
    if isinstance(value, dict):
        if required_keys.issubset(value.keys()):
            return value
        for child in value.values():
            found = _walk_find_dict_with_keys(child, required_keys)
            if found is not None:
                return found
        return None

    if isinstance(value, list):
        for item in value:
            found = _walk_find_dict_with_keys(item, required_keys)
            if found is not None:
                return found
        return None

    return None


def _parse_skills(items: list[dict[str, Any]]) -> list[Skill]:
    skills: list[Skill] = []
    for item in items:
        source = item.get("source")
        skill_id = item.get("skillId")
        name = item.get("name")
        installs = item.get("installs", 0)
        if not isinstance(source, str) or not isinstance(skill_id, str) or not isinstance(name, str):
            continue
        if not isinstance(installs, int):
            try:
                installs = int(installs)
            except (ValueError, TypeError):
                installs = 0
        skills.append(Skill(source=source, skill_id=skill_id, name=name, installs=installs))
    return skills


def main() -> int:
    parser = argparse.ArgumentParser(description="Extract popular skill sources from skills.sh")
    parser.add_argument("--url", default="https://skills.sh/", help="Base URL to fetch (default: https://skills.sh/)")
    parser.add_argument(
        "--html-path",
        default="",
        help="Read skills.sh HTML from a local file (or '-' for stdin) instead of fetching --url",
    )
    parser.add_argument("--view", choices=["trending", "all-time"], default="all-time")
    parser.add_argument("--min-installs", type=int, default=1000)
    parser.add_argument("--max-sources", type=int, default=0, help="0 means no limit")
    parser.add_argument("--format", choices=["slug", "url", "json"], default="slug")
    parser.add_argument("--timeout", type=int, default=30)
    args = parser.parse_args()

    if args.html_path:
        if args.html_path == "-":
            html = sys.stdin.read()
        else:
            with open(args.html_path, "r", encoding="utf-8", errors="replace") as handle:
                html = handle.read()
    else:
        html = _fetch_text(args.url, timeout_seconds=args.timeout)
    skills_payload = _find_skills_payload(_iter_next_push_strings(html))
    if skills_payload is None:
        print("ERROR: Could not locate skills payload in skills.sh HTML", file=sys.stderr)
        return 2

    skills_key = "trendingSkills" if args.view == "trending" else "allTimeSkills"
    raw_items = skills_payload.get(skills_key)
    if not isinstance(raw_items, list):
        print(f"ERROR: Missing expected key {skills_key}", file=sys.stderr)
        return 2

    skills = [skill for skill in _parse_skills(raw_items) if skill.installs >= args.min_installs]

    skills_by_source: dict[str, list[Skill]] = defaultdict(list)
    for skill in skills:
        skills_by_source[skill.source].append(skill)

    peak_installs_by_source = {
        source: max(source_skills, key=lambda s: s.installs).installs for source, source_skills in skills_by_source.items()
    }
    sources = sorted(peak_installs_by_source, key=peak_installs_by_source.get, reverse=True)
    if args.max_sources and args.max_sources > 0:
        sources = sources[: args.max_sources]

    if args.format == "json":
        json.dump(
            [
                {
                    "source": source,
                    "peak_installs": peak_installs_by_source[source],
                    "skills": [
                        {"skillId": skill.skill_id, "name": skill.name, "installs": skill.installs}
                        for skill in sorted(
                            skills_by_source[source],
                            key=lambda s: s.installs,
                            reverse=True,
                        )
                    ],
                }
                for source in sources
            ],
            sys.stdout,
            ensure_ascii=False,
        )
        sys.stdout.write("\n")
        return 0

    for source in sources:
        if args.format == "url":
            print(f"https://github.com/{source}")
        else:
            print(source)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
