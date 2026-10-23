#!/usr/bin/env bash
# Runs as shell during CNB launcher init (sourced). Must not invoke PHP itself.
_init_log="/tmp/console_profile_d.log"
echo "$(date -Is) 00-php-invoke-trap.sh sourced (shell only, pid=$$)" >> "${_init_log}"

_real_php="$(command -v php 2>/dev/null || true)"
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
  echo "$(date -Is) php not on PATH yet during this profile script" >> "${_init_log}"
fi
