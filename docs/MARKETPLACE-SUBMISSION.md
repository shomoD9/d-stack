# Marketplace submission guide

Researched 2026-10-16 from current official documentation and registry READMEs, fetched with `curl -fsSL`. These are preparation instructions. No form, external pull request, or directory submission has been made. Installing from this repository does not require a directory listing.

## Anthropic: directory portal

The current [Claude Code publishing guide](https://code.claude.com/docs/en/plugins/publish#submit-to-anthropics-directory) directs public submissions to [Anthropic's developer portal](https://claude.ai/directory/manage). The [portal walkthrough](https://claude.com/docs/plugins/submit#submit-a-plugin) accepts a GitHub plugin bundle and describes these steps:

1. Use an eligible paid Claude plan. Pro/Max users can submit personally; Team/Enterprise require an Owner or the permitted Enterprise Directory role. Connect a GitHub account with push access to `shomoD9/d-stack` in the Claude organization that will submit.
2. Read the [pre-submission checklist](https://claude.com/docs/plugins/pre-submission-checklist), directory terms, and directory policy linked by the walkthrough. Review tool assumptions and the external `domain-modeling` dependency before presenting this bundle as usable across all Claude surfaces.
3. Run `claude plugin validate . --strict` and `claude plugin validate .claude-plugin/plugin.json --strict`; confirm CI passes on the intended commit. Local validation does not cover all directory rules.
4. At the portal, select **Submit new → Plugin bundle**. Repository: `https://github.com/shomoD9/d-stack`. Plugin path: leave blank (repo root). Branch or tag: `v1.0.1` for the reviewed release, or `main` if intentionally tracking future commits.
5. Select **Validate**. Fix blocking findings in the repo and validate the resulting commit again. Review **Listing details**, which comes from the manifest and README.
6. Answer **Data handling** from the actual skill behavior: the package is Markdown with no bundled connector or hosted service, but research asks the host to browse and some workflows create files or tracker issues. The shell installer is a separate user-invoked download. Do not claim the host never accesses personal data.
7. Complete **Compliance**, provide a monitored maintainer email privately, and review all attestations. Choose GitHub push webhook or scheduled checks under update settings. Only the maintainer should select **Submit for review**.
8. Follow status and findings in **Submissions / Versions**. After the version clears the required checks/review, use the portal's publication controls. A passing scan alone is not evidence that this repo is already listed.

### The official Claude Code marketplace is a separate route

The current [publishing guide](https://code.claude.com/docs/en/plugins/publish#submit-to-anthropics-directory) explicitly says `claude-plugins-official` does not take submissions through the directory portal and advises contacting an Anthropic partner contact about inclusion. The [official marketplace README](https://github.com/anthropics/claude-plugins-official#external-plugins) still directs third-party submissions to [this submission form](https://clau.de/plugin-directory-submission).

These sources differ. Use the newer portal walkthrough for the general directory. For the specific `claude-plugins-official` catalog, check the form's current destination and contact route before proceeding; no unambiguous public PR intake or guaranteed acceptance is established. Do not open an unsolicited registry PR based on examples in `external_plugins/`. Our own `.claude-plugin/marketplace.json` already makes the two-command install work independently.

## OpenAI: shared ChatGPT and Codex directory

OpenAI now documents a shared plugin directory with skills-only packages supported. Follow [Upload and submit your plugin](https://developers.openai.com/plugins/deploy/submission), [Package your plugin](https://developers.openai.com/plugins/build/plugins), and the [plugin guidelines](https://developers.openai.com/plugins/plugin-guidelines).

1. Select the owning organization/project. The submitter must be an organization owner or have **Apps Management Write**. Complete individual/business verification in [organization settings](https://platform.openai.com/settings/organization/general); ensure the verified name matches the publisher identity you intend to use.
2. Review `.codex-plugin/plugin.json`. It includes the documented identity, author, skills path, and listing interface. It intentionally omits MCP configuration and review credentials. Review the actual limitations in the long description. Add assets or other listing metadata if current portal validation requires them; no fabricated privacy policy, verified identity, or review recording is supplied here.
3. Create a public-only ZIP from the tested release, with `.codex-plugin/plugin.json` and `skills/` at its root, retaining the license, README, and third-party notices. For example, from a checkout with the release tag:

   ```sh
   git archive --format=zip --output=/tmp/d-stack-v1.0.1.zip v1.0.1 \
     .codex-plugin skills README.md LICENSE THIRD_PARTY_NOTICES.md CHANGELOG.md
   unzip -l /tmp/d-stack-v1.0.1.zip
   ```

4. Open [Plugins](https://platform.openai.com/plugins), select **Upload new or existing plugin**, choose the verified **Developer identity**, and upload the ZIP. No upload has been performed as part of this release.
5. Wait for **Metadata & Skills** checks. Read each finding, fix the package, and upload a corrected ZIP. Complete required scans. For a skills-only plugin, the official guide says to omit `review`, MCP configuration, and `mcpServers`; MCP connection, domain verification, test credentials, and MCP walkthrough requirements do not apply to this bundle. Skills-only metadata checks do not require all four MCP listing URLs.
6. Select the intended draft, **Submit for review**, and complete the portal's required attestations. Track **Review status** and respond to any reviewer requests. After approval, choose when to publish. Package metadata or skill updates require another ZIP.

The `.agents/plugins/marketplace.json` in this repo is a self-hosted catalog, not an OpenAI directory submission. `codex plugin marketplace add shomoD9/d-stack` registers it; current CLI 0.162.1 also supports `codex plugin add d-stack@d-stack`. Desktop plugin discovery still needs its own desktop verification.

### OpenAI repositories are examples, not an established submission registry

- [openai/skills](https://github.com/openai/skills) is marked deprecated and points to [openai/plugins](https://github.com/openai/plugins) and the plugin-building guide. Do not submit a new registry PR to the deprecated skills repository.
- [openai/plugins](https://github.com/openai/plugins) describes itself as curated plugin examples with a default marketplace. Its current README does not establish an open community submission process. Use the documented portal for a public directory listing; no inclusion promise follows from the example repo accepting ordinary GitHub contributions.

## Ready-to-paste submission text

This text describes the current main branch, including unreleased skills. When submitting the pinned release below, use its matching catalog and descriptions. Use this text after verifying the release and publisher account. Supply contact details only through the relevant portal.

**Name:** d-stack
**Publisher:** Shomo
**Category:** Productivity
**Short description:** Research, write, delegate
**Repository:** https://github.com/shomoD9/d-stack
**Release:** https://github.com/shomoD9/d-stack/releases/tag/v1.0.1
**Support:** https://github.com/shomoD9/d-stack/issues
**Claude plugin path:** repository root
**Version:** 1.0.1

**Description:**

> d-stack bundles thirteen skills for primary-source research, learning, questioning plans, finding reading material, writing clear prose, and operating Claude Code and Codex as services. Skills are Markdown workflows with supporting resources for Claude Code and Codex. No MCP server, service account, or credential is bundled. The operator workflow requires an authenticated coding-agent CLI and access to the tools its task needs. Some workflows require interactive question tools, and grill-with-docs additionally requires the upstream domain-modeling skill. Matt Pocock's upstream work and Felix Rieseberg's inspiration are credited in the repository; MIT notices are retained.

**Verification and reviewer notes:**

> The repository contains a generated catalog, metadata and manifest linting, and isolated-HOME installer tests. CI validates Claude manifests and runs the installer in a clean Debian container. The build notes distinguish successful file installation and CLI plugin installation from desktop activation and conversational workflow quality. See docs/BUILD-NOTES.md for exact tested commands and results. For a simple workflow review, invoke research with a public technical question; for a command-only skill, give a task and then invoke be-depth-ambitious. Use fictional inputs for interviewing or writing tests.

**Data handling draft, requiring maintainer review:**

> The bundle itself has no hosted backend or declared MCP connection. It relies on the host's existing tools and permissions; research can browse public sources, and some workflows write workspace files or tracker records. The operator workflow delegates to locally configured coding-agent services, which may perform authorized repository pushes, publishing, browser work, or video production. The separate shell installer downloads the public Git repository and writes selected skill folders under the user's home directory. Data retention and external tool handling depend on the host and services the user connects. The npx route uses the third-party Vercel skills CLI, whose telemetry controls are documented upstream.

Do not paste a blanket “no data access” answer into compliance fields. Confirm actual host behavior, any directory-required assets, contact details, target audience answers, and account eligibility before submitting.
