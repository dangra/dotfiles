#
# ~/.bash_profile
#

[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[[ -f "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
[[ -x /opt/homebrew//bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Added by `rbenv init` on Thu Jan 16 06:17:24 PM -03 2025
eval "$(rbenv init - --no-rehash bash)"
