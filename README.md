# Ansight for Claude Code

Let your agent build, test, and prove your app works. This plugin gives Claude Code runtime evidence from your mobile app through [Ansight CLI](https://www.ansight.ai): inspect logs, screenshots, visual trees, network activity, and app state; interact with a connected development build; verify changes against the running app; and author repeatable tests and tasks.

Maintained by Ansight. Plugin version `0.1.0`; the bundled skills describe the latest public Ansight CLI.

## What is included

- **27 skills** generated from Ansight’s public skill sources: CLI setup, session investigation, live app operation, remote app tools, annotations, automation readiness, workspace tests, and per-platform SDK installation, inspection, and remote-tool authoring for iOS, Android, .NET MAUI, React Native, Flutter, and Capacitor. Invoke one directly as `/ansight:<skill-name>`, for example `/ansight:ansight-investigate-session`, or let Claude select it from the request.
- **`ansight-verifier` subagent.** Delegates verification of a change to a focused agent that drives the connected app, sweeps the evidence window for errors and failed requests, and returns a `verified | failed | blocked` verdict with session id, UTC window, and exported screenshots. Ask for it as `@ansight:ansight-verifier` or say “verify this with Ansight”.
- **Session-start check.** A short read-only hook runs `ansight version`, `ansight host status`, and a connected-session count when a session starts, and adds one line of context such as “CLI 0.40.0 installed and host running; 1 connected app session”. It never installs, starts, or signs in to anything, and it mentions when `ansight update check` reports a newer CLI.

## Requirements

- Claude Code on the machine running Ansight, or with command execution on that machine.
- A current Ansight CLI installation, available as `ansight` on PATH.
- For live app workflows, a development or QA build with the Ansight SDK enabled and connected to the resident host.
- Device and framework dependencies reported by `ansight doctor --json`.
- Python 3 only when using the automation-readiness scoring helper.

Installing this plugin does not install the CLI, start a host, change your app’s SDK integration, or configure MCP. A remote workspace or cloud session does not automatically reach a host on your laptop.

## Install

From the marketplace in this repository:

```sh
claude plugin marketplace add ansight-ai/ansight-claude
claude plugin install ansight@ansight
```

Or inside Claude Code: `/plugin marketplace add ansight-ai/ansight-claude`, then `/plugin install ansight@ansight`. Restart Claude Code after installing so the session-start check and skills load.

To try a local checkout without installing:

```sh
claude --plugin-dir /path/to/ansight-claude
```

If you previously let the Ansight CLI installer copy skills into `~/.claude/skills`, remove those `ansight-*` directories after installing the plugin so each skill triggers once.

## Start using it

Open your app repository in Claude Code and try:

- “Use Ansight to check my CLI setup and show the connected apps.”
- “Use Ansight to investigate errors in this app’s latest recorded session.”
- “Verify with Ansight that the settings screen shows the new heading.”
- “Use Ansight to create a repeatable test for this flow.”

## Versioning and updates

The bundled skills always describe the latest public Ansight CLI, and the CLI keeps itself current with `ansight update apply`. Update the plugin with `claude plugin update ansight` whenever a new package version is published. `ansight <command> help` is the authority for the installed CLI wherever a skill and the CLI disagree.

## Local execution and data

Commands run through Claude Code’s Bash tool and the existing Ansight host on your machine. This package contains instructions, one shell probe, one subagent definition, and a Python scoring helper; it has no telemetry or hosted backend. Evidence returned to Claude becomes part of the agent’s context and is subject to your Claude Code configuration and data handling. See Ansight’s [data and privacy documentation](https://www.ansight.ai/docs/workspace/data-privacy-and-analysis) for CLI capture and processing behaviour. The skills preserve exact session selection, existing host state, and authorization boundaries for state-changing operations.

To disable the session-start check while keeping the skills, disable the plugin’s hook in Claude Code’s settings or remove `hooks/hooks.json` from a local copy.

## Maintenance

Every file in this repository is generated from Ansight’s public skill sources and the plugin templates in the Ansight source repository. `sources.json` records source and packaged SHA-256 hashes. Make workflow changes in the source skills, then regenerate:

```sh
node scripts/plugins/build-claude-plugin.mjs
node scripts/plugins/build-claude-plugin.mjs --check
node --test scripts/plugins/build-claude-plugin.test.mjs
```

## Support

Use [Ansight](https://www.ansight.ai) and the [CLI documentation](https://www.ansight.ai/docs/cli). Include the plugin version, CLI version, host version, and the failing command when reporting a problem; omit credentials and private session evidence.

## License

The skills, subagent, probe script, and scoring helper in this plugin are [MIT licensed](LICENSE). Ansight CLI, SDKs, services, and trademarks remain subject to their separate terms. The logo identifies Ansight and does not grant trademark rights.
