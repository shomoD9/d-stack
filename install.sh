#!/usr/bin/env bash
# d-stack installer. Requires Bash, Git (streamed installs), and standard Unix tools.
set -euo pipefail

usage() {
  cat <<'HELP'
Usage: install.sh [--claude | --codex | --all] [--skill NAME] [--update | --uninstall]
Default: install all skills for both tools.
  --claude      Install into $HOME/.claude/skills
  --codex       Install into $HOME/.agents/skills
  --all         Install for both tools
  --skill NAME  Select one skill (plus internal dependencies on install)
  --update      Refresh selected skills from the source (same as reinstall)
  --uninstall   Remove only installer-owned selected skills; no network needed
  --help        Show this help
Set D_STACK_REF to a Git ref (default main) for streamed installs.
Existing unowned skills are never overwritten. Owned skill folders are replaced
on install/update and removed on uninstall, including edits inside those folders.
HELP
}
fail() { printf 'd-stack: %s\n' "$*" >&2; exit 1; }
target=all
skill=
action=install
while (($#)); do
  case "$1" in
    --claude) target=claude ;;
    --codex) target=codex ;;
    --all) target=all ;;
    --skill) shift; (($#)) || fail '--skill requires a name'; skill=$1 ;;
    --update|--uninstall)
      [[ $action == install ]] || fail 'choose only one of --update and --uninstall'
      action=${1#--} ;;
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
  shift
done
[[ -n ${HOME:-} && $HOME == /* && $HOME != / ]] || fail 'HOME must be an absolute, non-root directory'
[[ -z $skill || $skill =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail 'invalid skill name'
roots=()
[[ $target == codex ]] || roots+=("$HOME/.claude/skills")
[[ $target == claude ]] || roots+=("$HOME/.agents/skills")
marker=.d-stack-owned
owner='https://github.com/shomoD9/d-stack'
is_owned() {
  [[ -d $1 && ! -L $1 && -f $1/$marker && ! -L $1/$marker ]] &&
    [[ $(cat "$1/$marker") == "$owner" ]]
}
if [[ $action == uninstall ]]; then
  for root in "${roots[@]}"; do
    for dest in "$root"/*; do
      [[ -e $dest || -L $dest ]] || continue
      [[ -z $skill || ${dest##*/} == "$skill" ]] || continue
      if is_owned "$dest"; then
        rm -rf -- "$dest"
        printf 'Removed %s\n' "$dest"
      fi
    done
  done
  exit 0
fi
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
source_root=
# BASH_SOURCE is absent when the script arrives on standard input.
if [[ -n ${BASH_SOURCE[0]:-} ]]; then
  script_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
  [[ ! -d $script_root/skills ]] || source_root=$script_root
fi
if [[ -z $source_root ]]; then
  command -v git >/dev/null || fail 'Git is required for streamed installs'
  git clone --quiet --depth 1 --branch "${D_STACK_REF:-main}" \
    https://github.com/shomoD9/d-stack.git "$scratch/repo"
  source_root=$scratch/repo
fi
names=()
if [[ -n $skill ]]; then
  [[ -f $source_root/skills/$skill/SKILL.md ]] || fail "unknown skill: $skill"
  names+=("$skill")
  case "$skill" in
    grill-me|grill-with-docs|loop-me|wayfinder) names+=(grilling) ;;
  esac
else
  for folder in "$source_root"/skills/*; do
    [[ ! -f $folder/SKILL.md ]] || names+=("${folder##*/}")
  done
fi
((${#names[@]})) || fail 'no skills found'
# Check the whole selection before changing anything.
for root in "${roots[@]}"; do
  for name in "${names[@]}"; do
    dest=$root/$name
    if [[ -e $dest || -L $dest ]]; then
      is_owned "$dest" || fail "refusing to overwrite unowned skill: $dest"
    fi
  done
done
for root in "${roots[@]}"; do
  mkdir -p -- "$root"
  for name in "${names[@]}"; do
    stage=$(mktemp -d "$root/.d-stack-stage.XXXXXX")
    # Stage supporting files and notices before replacing the owned destination.
    if ! cp -R "$source_root/skills/$name/." "$stage/" ||
       ! cp "$source_root/LICENSE" "$source_root/THIRD_PARTY_NOTICES.md" "$stage/"; then
      rm -rf -- "$stage"
      fail "could not stage $name"
    fi
    printf '%s\n' "$owner" > "$stage/$marker"
    dest=$root/$name
    rm -rf -- "$dest"
    mv -- "$stage" "$dest"
    printf 'Installed %s\n' "$dest"
  done
done
if [[ -z $skill || $skill == grill-with-docs ]]; then
  printf '%s\n' 'Note: grill-with-docs also needs upstream domain-modeling; see README.'
fi
printf '%s\n' 'Start a new agent session to discover installed skills.'
