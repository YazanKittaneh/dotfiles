#!/usr/bin/env sh
# 1Password-backed secret loading. NOTHING secret is stored here — only op:// refs.
#
# Two auth modes:
#   * UNATTENDED (agents/CLIs): a scoped service-account token in
#     $OP_SERVICE_ACCOUNT_TOKEN (set in ~/.config/dotfiles/local.sh). No prompts.
#     Create it with ~/setup-1password-service-account.sh.
#   * INTERACTIVE (fallback): a normal `op signin` session (biometric).
#
# Because local.sh sets the token, this file MUST be sourced AFTER local.sh.
# When a token is present, secrets auto-load once per login shell; child processes
# (including agents you launch) inherit the exported keys for free.
#
# Item layout: op://$OP_VAULT/$OP_ITEM/<field>
#   vault: cli-keys   item: api-keys
#   fields: openai-personal, openai-route, openai, openrouter, anthropic, sweet

: "${OP_VAULT:=cli-keys}"
: "${OP_ITEM:=api-keys}"

load_secrets() {
  if ! command -v op >/dev/null 2>&1; then
    echo "load_secrets: 1Password CLI (op) not found" >&2
    return 1
  fi
  # A service-account token authenticates non-interactively; otherwise we need a
  # signed-in session, or op read would block on a biometric prompt.
  if [ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ] && ! op account get >/dev/null 2>&1; then
    echo "load_secrets: no 1Password auth — set OP_SERVICE_ACCOUNT_TOKEN (run ~/setup-1password-service-account.sh) or: eval \"\$(op signin)\"" >&2
    return 1
  fi

  export OPENAI_API_KEY_PERSONAL="$(op read "op://${OP_VAULT}/${OP_ITEM}/openai-personal" 2>/dev/null)"
  export OPENAI_API_KEY_ROUTE="$(op read "op://${OP_VAULT}/${OP_ITEM}/openai-route" 2>/dev/null)"
  export OPENAI_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/openai" 2>/dev/null)"
  export OPENROUTER_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/openrouter" 2>/dev/null)"
  export ANTHROPIC_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/anthropic" 2>/dev/null)"
  export SWEET_OPENAI_API_KEY="$(op read "op://${OP_VAULT}/${OP_ITEM}/sweet" 2>/dev/null)"
  export _DOTFILES_SECRETS_LOADED=1
}

# Auto-load once per session. With a service-account token this is fully unattended
# (no prompt). The marker skips reloading in child shells that already inherited keys.
if [ -z "${_DOTFILES_SECRETS_LOADED:-}" ]; then
  if [ -n "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]; then
    load_secrets
  elif [ "${DOTFILES_AUTOLOAD_SECRETS:-0}" = "1" ] && command -v op >/dev/null 2>&1 && op account get >/dev/null 2>&1; then
    load_secrets
  fi
fi
