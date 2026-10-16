# Contributing

Report reproducible install failures with your OS, agent version, command, and sanitized output. Use the issue templates; keep private workspace details and credentials out of reports.

For a skill change, explain its trigger, expected behavior, dependencies, and provenance. Keep `skills/<name>/SKILL.md` frontmatter valid YAML with a matching kebab-case `name` and a nonempty `description`. Put supporting resources in that skill's directory. Preserve upstream notices and identify edits to copied material.

Run these checks before opening a pull request:

```sh
python3 -m venv .venv
. .venv/bin/activate
pip install -r scripts/requirements.txt
python3 scripts/lint.py --write-catalog
python3 scripts/lint.py
bash -n install.sh scripts/test-install.sh
shellcheck install.sh scripts/test-install.sh
bash scripts/test-install.sh
claude plugin validate . --strict
claude plugin validate .claude-plugin/plugin.json --strict
```

ShellCheck and the Claude CLI are separate developer tools. CI runs these checks and exercises installation in a clean Debian container. `D_STACK_TEST_REMOTE=1 bash scripts/test-install.sh` additionally tests a streamed installer against the public `main` branch; run it after publishing installer changes.

Test real agent behavior for workflow changes and include the prompt, expected result, and observed result using fictional inputs. Installer tests prove files and lifecycle behavior, not the quality of model responses.

Keep changes focused and add user-visible changes to CHANGELOG.md. Update the generated README catalog when metadata changes. For releases, keep both plugin versions and the Claude catalog version aligned, run CI, tag the tested commit, and attach release notes. Review [the submission guide](docs/MARKETPLACE-SUBMISSION.md) before any directory submission; repository publication does not imply directory approval.
