#
# ~/.bash_profile
#

[[ -r /usr/local/etc/profile.d/bash_completion.sh ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[[ -f "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
[[ -x /opt/homebrew//bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -f ~/.bashrc ]] && . ~/.bashrc

type -p rbenv >/dev/null && eval "$(rbenv init - --no-rehash bash)"

[[ -d ~/.antigravity/antigravity/bin ]] && export PATH="~/.antigravity/antigravity/bin:$PATH"
[[ -d ~/.bun ]] && export BUN_INSTALL="$HOME/.bun" PATH="~/.bun/bin:$PATH"
