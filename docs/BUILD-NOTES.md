# Build notes: d-stack 1.0.0

## Depth ambition

1. **What would a top dev-tools maintainer add?** Treat install behavior as a public contract: protect pre-existing skills, include internal dependencies for selected installs, preserve supporting files and license notices, test update/uninstall as well as first install, and distinguish CLI validation from hosted-directory approval. Record limitations rather than imply endorsement or untested compatibility.
2. **Rawest material:** Current publisher documentation fetched with `curl -fsSL` on 2026-10-16: [Claude plugins](https://code.claude.com/docs/en/plugins), [marketplaces](https://code.claude.com/docs/en/plugin-marketplaces), [manifest reference](https://code.claude.com/docs/en/plugins-reference), [publishing](https://code.claude.com/docs/en/plugins/publish), [Codex skills](https://developers.openai.com/codex/skills), [OpenAI packaging](https://developers.openai.com/plugins/build/plugins), and [submission](https://developers.openai.com/plugins/deploy/submission). Also inspect the actual catalogs in [anthropics/skills](https://github.com/anthropics/skills/blob/main/.claude-plugin/marketplace.json), [obra/superpowers](https://github.com/obra/superpowers/blob/main/.claude-plugin/marketplace.json), and the READMEs in [Anthropic's official marketplace](https://github.com/anthropics/claude-plugins-official), [openai/skills](https://github.com/openai/skills), and [openai/plugins](https://github.com/openai/plugins). Use Markdown endpoints where supplied, not search summaries. Local fetched source copies are outside the public repo at `/tmp/d-stack-sources`.
3. **Specific methods/tools:** Bash with strict error handling; a temporary Git checkout for streamed installs; explicit ownership markers and collision checks; PyYAML frontmatter parsing and generated README catalog; JSON structure/path checks; isolated temporary HOME fixtures; Claude's own validator and marketplace commands; the published Vercel skills CLI; GitHub Actions in a clean container; GitHub release/tag verification.
4. **External proof:** `claude plugin validate . --strict`, installs through the actual Claude CLI into a clean HOME, byte comparisons of all installed skill assets, lifecycle and collision tests, the actual `npx skills` binary, and a hosted CI run on the pushed revision. Desktop plugin discovery requires a desktop session and is reported separately from CLI catalog registration.

## Rewritten prompt

Ship d-stack 1.0.0 as a documented, reversible skill distribution for Claude Code and Codex. Derive manifest formats and directory paths from fetched current publisher docs and compare them with maintained upstream repos. Keep a single canonical skills tree and generate its README catalog from parsed frontmatter. Implement a HOME-respecting Bash installer with explicit tool selection, dependency-aware single-skill installs, safe ownership checks, idempotent update, and uninstall that preserves unrelated user files. Provide Claude and Codex plugin catalogs only in documented formats. Prove the advertised paths using real CLIs and clean temporary homes, assert installed assets rather than exit codes alone, and automate lint and installer regression checks in a clean CI container. Preserve provenance and MIT notices. Document exact hosted-directory submission routes, contradictions between current sources, remaining requirements, and paste-ready text without submitting. Scan public content for excluded identifiers before logical commits, push main, tag v1.0.0, publish the release, and report evidence with any limitations.

## Source findings and decisions

- Claude discovers the root `skills/` automatically. A root plugin manifest plus a marketplace entry with `source: "./"` follows the documented layout and the superpowers catalog.
- Current Codex docs specify `$HOME/.agents/skills`; the installer uses that path. The current docs also support `.codex-plugin/plugin.json` and `.agents/plugins/marketplace.json`; CLI marketplace registration is distinct from desktop installation.
- `openai/skills` now marks itself deprecated and points to `openai/plugins`. Do not propose a registry PR to the deprecated repository.
- Current Claude publishing docs and the official marketplace README describe different submission channels. Preserve that distinction in the submission guide.
- `grill-with-docs` references upstream `domain-modeling`, which is not bundled. Keep that dependency limitation visible; do not silently import extra workflows.
- LICENSE is MIT, copyright 2026 Shomo. The Matt Pocock MIT notice remains in THIRD_PARTY_NOTICES.md. A generic wording change in the original writing skill removes a public-content scan hit without changing its instruction.

## Verification

Results are recorded below after execution.
