#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
export HOME="$fixture/home with spaces"
mkdir -p "$HOME"
run() { bash "$repo/install.sh" "$@" > /dev/null; }
verify() {
  local root=$1 name
  for folder in "$repo"/skills/*; do
    name=${folder##*/}
    diff -r "$folder" "$root/$name" --exclude=.d-stack-owned --exclude=LICENSE --exclude=THIRD_PARTY_NOTICES.md
    cmp "$repo/LICENSE" "$root/$name/LICENSE"
    cmp "$repo/THIRD_PARTY_NOTICES.md" "$root/$name/THIRD_PARTY_NOTICES.md"
  done
}
for tool in claude codex all; do
  run "--$tool"
  [[ $tool == codex ]] || verify "$HOME/.claude/skills"
  [[ $tool == claude ]] || verify "$HOME/.agents/skills"
  run "--$tool"
  run "--$tool" --update
  run "--$tool" --uninstall
  [[ $tool == codex ]] || test ! -e "$HOME/.claude/skills/research"
  [[ $tool == claude ]] || test ! -e "$HOME/.agents/skills/research"
  run "--$tool" --uninstall
done
run --codex --skill teach
test -f "$HOME/.agents/skills/teach/MISSION-FORMAT.md"
test ! -e "$HOME/.claude/skills/teach"
run --codex --skill teach --uninstall
run --claude --skill grill-me
test -f "$HOME/.claude/skills/grilling/SKILL.md"
run --claude --skill grill-me --uninstall
test -f "$HOME/.claude/skills/grilling/SKILL.md"
run --all --uninstall
# An unowned collision fails before any selected skill is written.
mkdir -p "$HOME/.agents/skills/research"
printf 'keep\n' > "$HOME/.agents/skills/research/custom.txt"
if run --all 2>/dev/null; then echo 'Collision was overwritten' >&2; exit 1; fi
test ! -e "$HOME/.claude/skills/teach"
run --all --uninstall
test "$(cat "$HOME/.agents/skills/research/custom.txt")" = keep
rm -r "$HOME/.agents/skills/research"
# A symlink collision must also be left alone.
mkdir -p "$fixture/foreign"
ln -s "$fixture/foreign" "$HOME/.agents/skills/research"
if run --codex --skill research 2>/dev/null; then exit 1; fi
run --codex --uninstall
test -L "$HOME/.agents/skills/research"
rm "$HOME/.agents/skills/research"
for args in '--skill ../escape' '--skill missing' '--unknown' '--skill' '--update --uninstall'; do
  # Intentional splitting: each fixture is a sequence of CLI arguments.
  if run $args 2>/dev/null; then echo "Accepted invalid arguments: $args" >&2; exit 1; fi
done
# A streamed script must fetch the real public source into an isolated HOME.
if [[ ${D_STACK_TEST_REMOTE:-0} == 1 ]]; then
  bash -s -- --all < "$repo/install.sh" > /dev/null
  for tool_root in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
    test -f "$tool_root/research/SKILL.md"
    test -f "$tool_root/teach/MISSION-FORMAT.md"
  done
  run --all --uninstall
  # Exercise commit pins too: clone --branch cannot handle a commit hash.
  remote_sha=$(git ls-remote https://github.com/shomoD9/d-stack.git HEAD | cut -f1)
  test -n "$remote_sha"
  D_STACK_REF="$remote_sha" bash -s -- --codex --skill research < "$repo/install.sh" > /dev/null
  test -f "$HOME/.agents/skills/research/SKILL.md"
  test ! -e "$HOME/.claude/skills/research"
  run --all --uninstall
fi
printf '%s\n' 'PASS: tool selection, assets/notices, repeat/update/uninstall, dependencies, collisions, symlinks, invalid arguments'
