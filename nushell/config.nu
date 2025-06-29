# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

alias ls = ls -a

$env.config.edit_mode = "vi"
$env.config.buffer_editor = "hx"
$env.config.show_banner = false
$env.GODOT_BIN = "godot-3.6"
$env.USERNAME = "calinp"
$env.ANGLER_PATH = "/home/calinp/.config/aseprite/scripts/angler_imp.lua"
$env.EDITOR = "hx"
# $env.LD_LIBRARY_PATH = ["/home/calinp/bin/cascadeur/cascadeur-linux/lib","/home/calinp/bin/cascadeur/lib","/home/calinp/bin/cascadeur/csc-lib"] | str join ":"

use std/util "path add"
path add "~/godot/"
path add "~/.cargo/bin/"
path add "~/.bun/bin/"

path add "~/bin"
path add "~/bin/cascadeur/"
path add ~/bin/cascadeur/cascadeur-linux/lib
path add ~/.local/bin/

# yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# ssh-agent
do --env {
    let ssh_agent_file = (
        $nu.temp-path | path join $"ssh-agent-($env.USER? | default $env.USERNAME).nuon"
    )

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}

# starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# zoxide
source ~/.zoxide.nu
use ./fzf.nu *
