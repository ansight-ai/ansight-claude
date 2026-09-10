#!/bin/sh
# Ansight plugin SessionStart probe. Read-only: it never installs, updates,
# starts, stops, or signs in to anything. Its single line of output becomes
# session context so the agent knows whether live verification is possible.
# Generated from scripts/plugins/claude/scripts/session-status.sh; edit the
# template in the Ansight source repository, not this copy.

# Extract one scalar from pretty-printed JSON without jq (first match wins).
json_field() {
  sed -n "s/.*\"$1\":[[:space:]]*\"\{0,1\}\([^\",}]*\)\"\{0,1\}.*/\1/p" | head -n 1
}

if ! command -v ansight >/dev/null 2>&1; then
  echo "Ansight: CLI not found on PATH. Live app inspection and verification are unavailable until it is installed; use /ansight:ansight-install only when the user asks for that."
  exit 0
fi

version=$(ansight version --json 2>/dev/null | json_field version)
if [ -z "$version" ]; then
  echo "Ansight: 'ansight version --json' did not return a version. Run /ansight:ansight-cli-setup before relying on Ansight."
  exit 0
fi

# The skills describe the latest public CLI, so the useful signal is whether an update exists.
compat=""
update=$(ansight update check --json 2>/dev/null)
if [ "$(printf '%s' "$update" | json_field isUpdateAvailable)" = "true" ]; then
  latest=$(printf '%s' "$update" | json_field latestVersion)
  compat=" CLI update available ($version -> $latest); offer 'ansight update apply' with the user's approval before relying on newer options."
fi

running=$(ansight host status --json 2>/dev/null | json_field isRunning)
if [ "$running" != "true" ]; then
  echo "Ansight: CLI $version installed; resident host is not running. Live inspection needs 'ansight host run' in a persistent terminal.$compat"
  exit 0
fi

count=$(ansight session list --connected --limit 5 --json 2>/dev/null | json_field matchedCount)
if [ -z "$count" ]; then
  echo "Ansight: CLI $version installed and host running; connected-session discovery failed (sign-in or product access may be required). Run /ansight:ansight-cli-setup.$compat"
elif [ "$count" = "0" ]; then
  echo "Ansight: CLI $version installed and host running; 0 connected app sessions. Live verification needs a development build with the Ansight SDK connected.$compat"
else
  echo "Ansight: CLI $version installed and host running; $count connected app session(s). Use 'ansight session list --connected --json' to select one explicitly before live operations.$compat"
fi
exit 0
