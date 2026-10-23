#!/usr/bin/env bash
_init_log="/tmp/console_profile_d.log"
echo "$(date -Is) zz-00-php-invoke-trap.sh sourced (shell only, pid=$$)" >> "${_init_log}"

# Prefer already-on-PATH php; also check common Heroku PHP locations
_real_php="$(command -v php 2>/dev/null || true)"
if [[ -z "${_real_php}" ]]; then
  for c in "$HOME/.heroku/php/bin/php" /app/.heroku/php/bin/php "$(pwd)/.heroku/php/bin/php"; do
    if [[ -x "$c" ]]; then _real_php="$c"; break; fi
  done
fi

if [[ -n "${_real_php}" && -x "${_real_php}" ]]; then
  _wrap_dir="/tmp/php-wrap-bin"
  mkdir -p "${_wrap_dir}"
  cat > "${_wrap_dir}/php" << WRAP
#!/usr/bin/env bash
echo "\$(date -Is) php invoked argv=\$* ppid=\$PPID pwd=\$(pwd)" >> /tmp/php_invocations.log
exec ${_real_php} "\$@"
WRAP
  chmod +x "${_wrap_dir}/php"
  export PATH="${_wrap_dir}:${PATH}"
  echo "$(date -Is) wrapped php at ${_real_php} via ${_wrap_dir}/php" >> "${_init_log}"
else
  echo "$(date -Is) php binary not found during trap setup" >> "${_init_log}"
fi
