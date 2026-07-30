#!/usr/bin/env sh
# 1Password-backed secret loading. NOTHING secret is stored here — only op:// refs.
#
# Prerequisites (per machine):
#   1. Install the 1Password CLI (`op`) and enable the desktop-app / CLI integration.
#   2. Sign in once per session: `eval "$(op signin)"`  (or biometric unlock).
#   3. Create a 1Password item holding your ROTATED keys, one field per key:
#        vault: "$OP_VAULT" (default: Private)
#        item:  "$OP_ITEM"  (default: cli-keys)
#        fields: openai-personal, openai-route, openai, openrouter, anthropic, sweet
#
# Usage: secrets are NOT loaded at shell startup (keeps startup fast and avoids a
# forced unlock). Run `load_secrets` when you need them, then use the air/aime/
# claudekey/etc. aliases. Set DOTFILES_AUTOLOAD_SECRETS=1 in ~/.config/dotfiles/local.sh
# to auto-load on startup when an op session is already active.

: "${OP_VAULT:=Private}"
: "${OP_ITEM:=cli-keys}"

load_secrets() {
  if ! command -v op >/dev/null 2>&1; then
    echo "load_secrets: 1Password CLI (op) not found" >&2
    return 1
  fi
  # Verify an active session; op read will otherwise block on a prompt.
  if ! op account get >/dev/null 2>&1; then
    echo "load_secrets: no active 1Password session — run: eval \"\$(op signin)\"" >&2
    return 1
  fi

  export OPENAI_API_KEY_PERSONAL="$(op read "op://${OP_VAULT}/${OP_ITEM}/openai-personal" 2>/dev/null)"
  export OPENAI_API_KEY_ROUTE="$(op read "op://${OP_VAULT}/${OP_ITEM}/openai-route" 2>/dev/null)"
  export OPENAI_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/openai" 2>/dev/null)"
  export OPENROUTER_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/openrouter" 2>/dev/null)"
  export ANTHROPIC_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/anthropic" 2>/dev/null)"
  export SWEET_OPENAI_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/sweet" 2>/dev/null)"

  echo "load_secrets: exported keys from op://${OP_VAULT}/${OP_ITEM}" >&2
}

# Optional eager load (only if explicitly enabled AND a session is already active,
# so it never blocks a new shell on an unlock prompt).
if [ "${DOTFILES_AUTOLOAD_SECRETS:-0}" = "1" ] && command -v op >/dev/null 2>&1 && op account get >/dev/null 2>&1; then
  load_secrets
fi
