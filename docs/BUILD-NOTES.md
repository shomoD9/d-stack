# Build notes: d-stack 1.0.1

## Depth ambition

1. **What would a top dev-tools maintainer add?** Treat install behavior as a public contract: protect pre-existing skills, include internal dependencies for selected installs, preserve supporting files and license notices, test update/uninstall as well as first install, and distinguish CLI validation from hosted-directory approval. Record limitations rather than imply endorsement or untested compatibility.
2. **Rawest material:** Current publisher documentation fetched with `curl -fsSL` on 2026-10-16: [Claude plugins](https://code.claude.com/docs/en/plugins), [marketplaces](https://code.claude.com/docs/en/plugin-marketplaces), [manifest reference](https://code.claude.com/docs/en/plugins-reference), [publishing](https://code.claude.com/docs/en/plugins/publish), [Codex skills](https://developers.openai.com/codex/skills), [OpenAI packaging](https://developers.openai.com/plugins/build/plugins), and [submission](https://developers.openai.com/plugins/deploy/submission). Also inspect the actual catalogs in [anthropics/skills](https://github.com/anthropics/skills/blob/main/.claude-plugin/marketplace.json), [obra/superpowers](https://github.com/obra/superpowers/blob/main/.claude-plugin/marketplace.json), and the READMEs in [Anthropic's official marketplace](https://github.com/anthropics/claude-plugins-official), [openai/skills](https://github.com/openai/skills), and [openai/plugins](https://github.com/openai/plugins). Use Markdown endpoints where supplied, not search summaries. Local fetched source copies are outside the public repo at `/tmp/d-stack-sources`.
3. **Specific methods/tools:** Bash with strict error handling; a temporary Git checkout for downloaded installs; explicit ownership markers and collision checks; PyYAML frontmatter parsing and generated README catalog; JSON structure/path checks; isolated temporary HOME fixtures; Claude's own validator and marketplace commands; the published Vercel skills CLI; GitHub Actions in a clean container; GitHub release/tag verification.
4. **External proof:** `claude plugin validate . --strict`, installs through the actual Claude CLI into a clean HOME, byte comparisons of all installed skill assets, lifecycle and collision tests, the actual `npx skills` binary, and a hosted CI run on the pushed revision. Desktop plugin discovery requires a desktop session and is reported separately from CLI catalog registration.

## Rewritten prompt

Ship d-stack 1.0.1 as a documented, reversible skill distribution for Claude Code and Codex. Derive manifest formats and directory paths from fetched current publisher docs and compare them with maintained upstream repos. Keep a single canonical skills tree and generate its README catalog from parsed frontmatter. Implement a HOME-respecting Bash installer with explicit tool selection, dependency-aware single-skill installs, safe ownership checks, idempotent update, and uninstall that preserves unrelated user files. Provide Claude and Codex plugin catalogs only in documented formats. Prove the advertised paths using real CLIs and clean temporary homes, assert installed assets rather than exit codes alone, and automate lint and installer regression checks in a clean CI container. Preserve provenance and MIT notices. Document exact hosted-directory submission routes, contradictions between current sources, remaining requirements, and paste-ready text without submitting. Scan public content for excluded identifiers before logical commits, push main, tag v1.0.1, publish the release, and report evidence with any limitations.

## Source findings and decisions

- Claude discovers the root `skills/` automatically. A root plugin manifest plus a marketplace entry with `source: "./"` follows the documented layout and the superpowers catalog.
- Current Codex docs specify `$HOME/.agents/skills`; the installer uses that path. The current docs also support `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`; CLI marketplace registration is distinct from desktop installation.
- `openai/skills` now marks itself deprecated and points to `openai/plugins`. Do not propose a registry PR to the deprecated repository.
- Current Claude publishing docs and the official marketplace README describe different submission channels. Preserve that distinction in the submission guide.
- `grill-with-docs` references upstream `domain-modeling`, which is not bundled. Keep that dependency limitation visible; do not silently import extra workflows.
- LICENSE is MIT, copyright 2026 Shomo. The Matt Pocock MIT notice remains in THIRD_PARTY_NOTICES.md. A generic wording change in the original writing skill removes a public-content scan hit without changing its instruction.

## Historical 1.0.0 verification

All tests below used newly created temporary HOME directories, never the maintainer's live skill directories. Paths containing spaces are covered by the regression suite. Claude plugin tests use an isolated Claude config directory; Codex plugin tests use an isolated Codex home and create it first because CLI 0.162.1 requires an existing directory. The Codex CLI emits a harmless helper-alias warning for homes under `/tmp`; installation still succeeds and bytes are checked.

| Check / exact entry point | Result | Evidence |
| --- | --- | --- |
| `python3 scripts/lint.py` | PASS | 12 frontmatter records, 4 JSON manifests with identity/path checks, generated catalog matches |
| `bash -n install.sh scripts/test-install.sh` and ShellCheck | PASS | Both shell files parse and lint cleanly |
| `claude plugin validate . --strict` | PASS | Marketplace accepted by Claude Code 2.1.300 |
| `claude plugin validate .claude-plugin/plugin.json --strict` | PASS | Plugin accepted independently; no warnings |
| `bash scripts/test-install.sh` | PASS | Claude/Codex/all; complete supporting assets and notices compared; repeat/update/uninstall; single teach; grill-me dependency; unowned and symlink collisions; invalid arguments; HOME with spaces |
| Public installer verification | PASS | All twelve skills appear under both tool paths; byte comparison against canonical skill tree |
| Same installer with `bash install.sh --claude` | PASS | Claude skill files present; clean fixture |
| Same installer with `bash install.sh --codex` | PASS | Codex skill files present; clean fixture |
| Same installer with `bash install.sh --all` | PASS | Both destinations populated |
| Same installer with `bash install.sh --codex --skill research` | PASS | Selected skill present |
| Same installer with `--all --update`, then `--all --uninstall` | PASS | Reinstallation succeeds, owned skills removed |
| Downloaded installer with `D_STACK_REF=<full commit SHA>` | PASS after fix | Initial branch-only clone rejected SHA; replaced with init/fetch/detached checkout. Rechecked against commit 8e53c2f and added a remote-SHA regression fixture. Branch pins also pass. The documented release tag uses this same fetch path. |
| `claude plugin marketplace add shomoD9/d-stack`, then `claude plugin install d-stack@d-stack` | PASS | Actual public remote source; installed cache has all twelve skills and every supporting file byte-identical; uninstall also passes |
| `codex plugin marketplace add shomoD9/d-stack`, then `codex plugin add d-stack@d-stack` | PASS | Codex CLI 0.162.1 installs cache version 1.0.0; complete skills tree matches; remove also passes |
| `npx skills add shomoD9/d-stack --global --agent claude-code codex --skill '*' --yes` | PASS on Node 22 | skills CLI 1.7.2, Node 22.23.3; all twelve canonical skills and supporting assets match through both host paths |
| `npx skills add shomoD9/d-stack --global --agent codex --skill research --yes` | PASS on Node 22 | research present and byte-identical, teach absent |
| Latest npx route on Node 20.19.2 | FAIL: unsupported runtime | skills 1.7.2 requires Node >=22.20.0 and uses fs/promises glob. README states the requirement. No own npm package was invented. |
| `D_STACK_TEST_REMOTE=1 bash scripts/test-install.sh` | PASS | Public-source installer verification plus local lifecycle suite; ref regression added |
| GitHub Actions lint + clean Debian container install | PASS | [Hosted run on 8e53c2f](https://github.com/shomoD9/d-stack/actions/runs/38850821781); includes strict Claude validation, ShellCheck, and clean-container lifecycle suite. Subsequent revision runs appear under the CI badge. |
| Historical v1.0.0 release-pinned installer verification | PASS | Executed after tag push; both complete skill trees match the repository byte-for-byte |
| Desktop plugin discovery/activation | NOT RUN | No desktop session; CLI installation is verified separately |
| Hosted directory acceptance | NOT RUN | Preparation only; no submissions made |

There is no Docker binary in this editing environment. The real container verification ran successfully on GitHub Actions, rather than substituting a temporary HOME for a container. Conversation-level skill quality is outside these installation checks. The public-content scan and `git diff --check` pass before commits. MIT LICENSE and THIRD_PARTY_NOTICES.md remain unchanged.

## Historical 1.0.0 release verification

- Tagged code commit: `e18ff40cdae310fcc8f6df24016c638392cd0eff`. [CI on the exact tagged code](https://github.com/shomoD9/d-stack/actions/runs/38850956976) passed both lint/Claude validation and the clean Debian container lifecycle/ref tests.
- Published [d-stack v1.0.0](https://github.com/shomoD9/d-stack/releases/tag/v1.0.0), with notes extracted from CHANGELOG.md. The release-tag URL and tag-pinned installer were then tested successfully.
- This release-evidence documentation is recorded on main after publication; the immutable tag retains the tested code. No external directory submission was made.

## 1.0.1 validation

- Added matching 1024×1024 PNG icons using upright EB Garamond, with charcoal backgrounds and centered monograms. Each image is under 2 MB.
- Updated listing identity and version metadata, marketplace-first install instructions, and download-then-run examples.
- Strict Claude marketplace and plugin validation both pass without warnings. The installer lifecycle suite passes.
- Hosted directory review is separate from CLI validation; directory acceptance has not been rechecked here.
