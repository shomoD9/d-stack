#!/usr/bin/env python3
"""Validate skill metadata, distribution manifests, and the generated catalog."""
import argparse
import json
import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]
START, END = '<!-- skills:start -->', '<!-- skills:end -->'


def check(condition, message):
    if not condition:
        raise ValueError(message)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write-catalog', action='store_true')
    args = parser.parse_args()
    rows = ['| Skill | When to use it |', '| --- | --- |']
    skills = sorted((ROOT / 'skills').glob('*/SKILL.md'))
    check(bool(skills), 'No skills found')
    for path in skills:
        text = path.read_text()
        check(text.startswith('---\n'), f'{path}: missing frontmatter')
        parts = text.split('---\n', 2)
        check(len(parts) == 3, f'{path}: unclosed frontmatter')
        meta = yaml.safe_load(parts[1])
        check(isinstance(meta, dict), f'{path}: expected a metadata map')
        name = meta.get('name')
        check(name == path.parent.name and bool(re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', name)), f'{path}: invalid name')
        desc = meta.get('description')
        check(isinstance(desc, str) and 0 < len(desc) <= 1024, f'{path}: invalid description')
        check(bool(parts[2].strip()), f'{path}: empty instructions')
        if 'disable-model-invocation' in meta:
            check(isinstance(meta['disable-model-invocation'], bool), f'{path}: expected boolean')
        desc = ' '.join(desc.split()).replace('|', '\\|')
        rows.append(f'| [{name}](skills/{name}) | {desc} |')
    manifests = {}
    for folder in ['.claude-plugin', '.codex-plugin', '.agents/plugins']:
        for path in (ROOT / folder).glob('*.json'):
            manifests[str(path.relative_to(ROOT))] = json.loads(path.read_text())
    claude = manifests['.claude-plugin/plugin.json']
    codex = manifests['.codex-plugin/plugin.json']
    for meta in [claude, codex]:
        check(meta['name'] == 'd-stack' and meta['version'] == '1.0.0', 'Plugin identity/version mismatch')
        check(isinstance(meta['description'], str), 'Missing description')
    check(codex['skills'] == './skills/', 'Codex skills path mismatch')
    check(codex['author']['name'] == 'Shomo', 'Codex publisher missing')
    for key in ['displayName', 'shortDescription', 'longDescription', 'developerName', 'category', 'capabilities']:
        check(bool(codex['interface'].get(key)), f'Codex interface missing {key}')
    check(len(codex['interface']['shortDescription']) <= 30, 'Codex subtitle too long')
    market = manifests['.claude-plugin/marketplace.json']
    check(market['name'] == 'd-stack' and market['owner']['name'] == 'Shomo', 'Claude marketplace identity mismatch')
    check(len(market['plugins']) == 1, 'Expected one Claude plugin')
    entry = market['plugins'][0]
    check(entry['name'] == claude['name'] and entry['version'] == claude['version'], 'Claude catalog mismatch')
    check(entry['source'] == './', 'Claude source must resolve to repo root')
    market = manifests['.agents/plugins/marketplace.json']
    check(market['name'] == 'd-stack' and len(market['plugins']) == 1, 'Codex marketplace mismatch')
    entry = market['plugins'][0]
    check(entry['name'] == codex['name'], 'Codex catalog name mismatch')
    check(entry['source'] == {'source': 'local', 'path': './'}, 'Codex source mismatch')
    check(entry['policy'] == {'installation': 'AVAILABLE', 'authentication': 'ON_INSTALL'}, 'Codex policy mismatch')
    check(entry['category'] == 'Productivity', 'Codex category mismatch')
    readme = ROOT / 'README.md'
    text = readme.read_text()
    check(text.count(START) == text.count(END) == 1, 'README catalog markers missing or duplicated')
    before, rest = text.split(START)
    current, after = rest.split(END)
    generated = '\n\n' + '\n'.join(rows) + '\n\n'
    if args.write_catalog:
        readme.write_text(before + START + generated + END + after)
    else:
        check(current == generated, 'Catalog stale: run python3 scripts/lint.py --write-catalog')
    print(f'PASS: {len(skills)} skills, {len(manifests)} manifests, README catalog')


if __name__ == '__main__':
    main()
