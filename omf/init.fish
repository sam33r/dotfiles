# Workaround described in https://github.com/fish-shell/fish-shell/issues/3535#issuecomment-259278388
function fish_vi_cursor; end


# Set environment variables.
set -gx BROWSER "w3m"

source ~/fish-init.local.fish
