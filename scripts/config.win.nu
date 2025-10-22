# config.nu
#
# Installed by:
# version = "0.107.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false
$env.config.buffer_editor = 'nvim'
$env.source = 'd:/Users/kinnar/source/'
$env.repos = 'd:/Users/kinnar/source/repos/'
$env.note = 'd:/Users/kinnar/iCloudDrive/Documents/Notes/'

$env.GD_USERNAME = 'ICT|IRIS'
$env.GD_PASSWORD = 'ICT4Geo'

# Load starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# ZOXIDE
# zoxide init nushell | save -f ~/.zoxide.nu
# source ~/.zoxide.nu
# alias cd = z
# alias cdi = zoxide query --interactive

# Load IRIS Sql Server function
source d:/Users/kinnar/source/repos/nu/scripts/sql-server-iris.nu

# Load IRIS load-dotenv function
source d:/Users/kinnar/source/repos/nu/scripts/load-dotenv.nu

# Load silent_spawn function
source d:/Users/kinnar/source/repos/nu/scripts/silent-spawn.nu

# Load go-to-repos function
source d:/Users/kinnar/source/repos/nu/scripts/go-to-repos.nu

# BAT alias
alias bat = bat --theme="Catppuccin Mocha"

# THUMB
alias thumb = wezterm imgcat --max-pixels 640000

# NOTE
alias note = nvim $'($env.note)/quicknote-(date now | format date '%Y%m%d-%H%M%S').md' -c "startinsert"
alias notes = nvim ($env.note)

# TYPORA
alias omd = silent-spawn typora
