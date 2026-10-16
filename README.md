# d-stack

[![CI](https://github.com/shomoD9/d-stack/actions/workflows/ci.yml/badge.svg)](https://github.com/shomoD9/d-stack/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/shomoD9/d-stack)](https://github.com/shomoD9/d-stack/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Skills for sharper questions, primary-source research, learning, and clear writing — in Claude Code and Codex.**

Twelve workflows, plain Markdown, and supporting resources. Install the whole stack or choose a skill.

## Install

| Tool | Recommended path | Alternative |
| --- | --- | --- |
| Claude Code | Plugin marketplace commands below | Shell installer into `~/.claude/skills` |
| Codex | Shell installer into `~/.agents/skills` | Codex plugin marketplace; install through the desktop Plugins Directory |
| Both | Shell installer with `--all` | Vercel's `skills` CLI |

In Claude Code:

```text
/plugin marketplace add shomoD9/d-stack
/plugin install d-stack@d-stack
```

Or use the shell installer (Bash and Git required):

```sh
curl -fsSL https://raw.githubusercontent.com/shomoD9/d-stack/main/install.sh | bash
# Choose a tool:
curl -fsSL https://raw.githubusercontent.com/shomoD9/d-stack/main/install.sh | bash -s -- --claude
curl -fsSL https://raw.githubusercontent.com/shomoD9/d-stack/main/install.sh | bash -s -- --codex
curl -fsSL https://raw.githubusercontent.com/shomoD9/d-stack/main/install.sh | bash -s -- --all
# One skill, including any bundled dependencies:
curl -fsSL https://raw.githubusercontent.com/shomoD9/d-stack/main/install.sh | bash -s -- --codex --skill research
```

To inspect the script before running it, download `install.sh`, read it, then run `bash install.sh --all`. Streamed installs clone `main`; set `D_STACK_REF=v1.0.0` on the Bash process to pin a release:

```sh
curl -fsSL https://raw.githubusercontent.com/shomoD9/d-stack/v1.0.0/install.sh | D_STACK_REF=v1.0.0 bash -s -- --all
```

The installer respects `HOME`, preserves unowned skill directories, and includes license notices and supporting files. Repeating a command refreshes the same selection. Edits inside installer-owned skill folders are replaced on update and removed on uninstall; keep custom skills in separate folders. Use one install method per tool to avoid duplicate skills.

```sh
# From a local checkout; these flags also work with bash -s -- in the curl command:
bash install.sh --all --update
bash install.sh --codex --skill research --update
bash install.sh --all --uninstall
bash install.sh --claude --skill research --uninstall
```

Uninstall needs no network and only removes folders carrying this installer's ownership marker. Removing a single skill leaves shared dependencies in place. Plugin installs use the host's update/uninstall commands instead:

```text
/plugin marketplace update d-stack
/plugin update d-stack@d-stack
/plugin uninstall d-stack@d-stack
```

### Codex plugin option

Current [Codex skill docs](https://developers.openai.com/codex/skills) use `~/.agents/skills` for personal skills. Older setups may use `~/.codex/skills`; this installer targets the current documented directory.

The repository also ships the [documented Codex plugin format](https://developers.openai.com/plugins/build/plugins):

```sh
codex plugin marketplace add shomoD9/d-stack
codex plugin marketplace list
```

With Codex CLI 0.162.1 or later, you can also install directly:

```sh
codex plugin add d-stack@d-stack
```

Catalog registration and CLI installation are tested. The [packaging guide](https://developers.openai.com/plugins/build/plugins) also describes desktop installation: restart the ChatGPT desktop app, open the Plugins Directory in Codex, choose **d-stack**, and install. Desktop discovery and activation need a desktop session and are not verified here. The standalone shell path works without that step.

### With npx

Use the independently maintained [Vercel skills CLI](https://github.com/vercel-labs/skills) (Node.js 22.20+ and npm required):

```sh
npx skills add shomoD9/d-stack --global --agent claude-code codex --skill '*' --yes
# Select a skill explicitly:
npx skills add shomoD9/d-stack --global --agent codex --skill research --yes
```

The CLI manages its own links and metadata. Use its `remove` and `update` commands for that installation. Single-skill selection through this CLI does not resolve d-stack's internal dependencies; include `--skill grilling` for the workflows listed below.

## Usage

Start a new agent session after installing. Claude plugin skills use the `d-stack:` namespace; standalone Claude skills use their folder name. Codex skills can be selected with `$` or its skills picker.

| Goal | Claude plugin example | Codex example |
| --- | --- | --- |
| Investigate a question | `/d-stack:research Compare the primary sources for this design.` | `$research Compare the primary sources for this design.` |
| Stress-test a plan | `/d-stack:grill-me Review this migration plan.` | `$grill-me Review this migration plan.` |
| Learn a topic | `/d-stack:teach Explain database indexes through exercises.` | `$teach Explain database indexes through exercises.` |
| Deepen a task | Give a task, then `/d-stack:be-depth-ambitious` | Give a task, then select `$be-depth-ambitious` |

Skills may assume host-specific tools. In Codex, treat Claude's `Skill` calls as requests to load the named skill, and use an available interactive question tool when requested. Tool availability and workflow quality depend on the host; file installation alone does not verify every conversational workflow.

## Skill catalog

Generated from `skills/*/SKILL.md` frontmatter by `python3 scripts/lint.py --write-catalog`.

<!-- skills:start -->

| Skill | When to use it |
| --- | --- |
| [be-altitude-ambitious](skills/be-altitude-ambitious) | Invoked as /be-altitude-ambitious AFTER the user has already given the agent a task; it applies to the task just prompted. Rewrites that task to be higher, not bigger, by asking what goal sits behind it and what the owner of that outcome would do. |
| [be-depth-ambitious](skills/be-depth-ambitious) | Invoked as /be-depth-ambitious AFTER the user has already given the agent a task; it applies to the task just prompted. Rewrites that task to be deeper, not bigger, by asking what a top professional would do, starting from raw material, with specific methods and independent verification. |
| [be-range-ambitious](skills/be-range-ambitious) | Invoked as /be-range-ambitious AFTER the user has already given the agent a task; it applies to the task just prompted. Rewrites that task to be wider, not bigger, by bringing in specialists from other fields, including one who attacks the result. |
| [grill-me](skills/grill-me) | A relentless interview to sharpen a plan or design. |
| [grill-with-docs](skills/grill-with-docs) | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| [grilling](skills/grilling) | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| [loop-me](skills/loop-me) | Grill me about specs for the workflows I want to build, within this workspace. |
| [need-reading-material](skills/need-reading-material) | The user is in need for inspiration. Find them high quality sources to read. |
| [research](skills/research) | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. |
| [teach](skills/teach) | Teach the user a new skill or concept, within this workspace. |
| [wayfinder](skills/wayfinder) | Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear. |
| [write-without-ai-slop](skills/write-without-ai-slop) | Draft original expository and analytical prose that is clear, neutral, specific, human, and free of generic AI-writing patterns. Use when writing a new essay, article, post, newsletter, speech, script, memo, guide, syllabus, research summary, literature review, explanation, or argument from a prompt, brief, outline, notes, facts, or source material rather than editing an existing draft. |

<!-- skills:end -->

`grill-me`, `grill-with-docs`, `wayfinder`, and `loop-me` invoke `grilling`; the shell installer includes it automatically for those selections. `grill-with-docs` additionally calls `domain-modeling` from [Matt Pocock's skills](https://github.com/mattpocock/skills), which is not bundled. Install that upstream skill separately before using the complete documentation workflow.

## Development

```sh
python3 -m venv .venv
. .venv/bin/activate
pip install -r scripts/requirements.txt
python3 scripts/lint.py
bash scripts/test-install.sh
claude plugin validate . --strict
claude plugin validate .claude-plugin/plugin.json --strict
```

See [CONTRIBUTING.md](CONTRIBUTING.md), [CHANGELOG.md](CHANGELOG.md), [build evidence](docs/BUILD-NOTES.md), and [marketplace submission instructions](docs/MARKETPLACE-SUBMISSION.md).

## Credit

Most of the grilling and planning skills come from Matt Pocock's [mattpocock/skills](https://github.com/mattpocock/skills), released under the MIT License.

- `grill-me`, `grill-with-docs`, `wayfinder`, `research` and `teach` are copied from that repository without changes.
- `grilling` is an edited version of the upstream skill. `loop-me` is derived from it.

`need-reading-material` and `write-without-ai-slop` are Shomo's own. `be-depth-ambitious`, `be-altitude-ambitious` and `be-range-ambitious` are inspired by Felix Rieseberg's essay [How to be more ambitious: a tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/).

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the upstream copyright notice and license text.

## License

[MIT](LICENSE) for Shomo's own work. Upstream material keeps its own copyright notice, listed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
