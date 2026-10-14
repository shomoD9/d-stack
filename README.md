# shomo-stack

A set of agent skills that Shomo uses with Claude Code and Codex. They cover interviewing and stress-testing plans, researching and learning, finding reading material, and writing prose without generic AI patterns.

Each skill is a folder under `skills/` with a `SKILL.md` file, and some have supporting files.

## Skills

| Skill | Description |
|---|---|
| [grilling](skills/grilling) | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| [grill-me](skills/grill-me) | A relentless interview to sharpen a plan or design. |
| [grill-with-docs](skills/grill-with-docs) | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| [loop-me](skills/loop-me) | Grill me about specs for the workflows I want to build, within this workspace. |
| [wayfinder](skills/wayfinder) | Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear. |
| [research](skills/research) | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. |
| [teach](skills/teach) | Teach the user a new skill or concept, within this workspace. |
| [need-reading-material](skills/need-reading-material) | The user is in need for inspiration. Find them high quality sources to read. |
| [write-without-ai-slop](skills/write-without-ai-slop) | Draft original expository and analytical prose that is clear, neutral, specific, human, and free of generic AI-writing patterns. |

`grill-me`, `grill-with-docs`, `wayfinder` and `loop-me` invoke `grilling`, so install it alongside them. `grill-with-docs` also refers to a `domain-modeling` skill from the upstream repository, which is not included here.

## Credit

Most of the grilling and planning skills come from Matt Pocock's [mattpocock/skills](https://github.com/mattpocock/skills), released under the MIT License.

- `grill-me`, `grill-with-docs`, `wayfinder`, `research` and `teach` are copied from that repository without changes.
- `grilling` is an edited version of the upstream skill. `loop-me` is derived from it.

`need-reading-material` and `write-without-ai-slop` are Shomo's own. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the upstream copyright notice and license text.

## Install

Clone the repository, then copy the skill folders into your agent's skills directory.

Claude Code:

```sh
git clone https://github.com/shomoD9/shomo-stack.git
mkdir -p ~/.claude/skills
cp -r shomo-stack/skills/* ~/.claude/skills/
```

Codex:

```sh
mkdir -p ~/.codex/skills
cp -r shomo-stack/skills/* ~/.codex/skills/
```

To install a single skill, copy only that folder, for example `skills/research`.

## License

[MIT](LICENSE) for Shomo's own work. Upstream material keeps its own copyright notice, listed in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
