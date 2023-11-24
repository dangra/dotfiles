[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

[[ -f "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"


. "$HOME/.cargo/env"
