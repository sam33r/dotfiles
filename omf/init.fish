# Workaround described in https://github.com/fish-shell/fish-shell/issues/3535#issuecomment-259278388
function fish_vi_cursor; end


# Set environment variables.
set -gx BROWSER "w3m"

# budspencer options.
set -g theme_title_display_process yes
set -g theme_title_display_path yes
set -g theme_title_display_user no
set -g theme_title_use_abbreviated_path no
set -g theme_display_git yes
set -g theme_display_git_untracked no
set -g theme_display_git_ahead_verbose yes
set -g theme_git_worktree_support no
set -g theme_display_vagrant no
set -g theme_display_docker_machine yes
set -g theme_display_hg yes
set -g theme_display_virtualenv yes
set -g theme_display_ruby no
set -g theme_display_user no
set -g theme_display_vi yes
set -g theme_avoid_ambiguous_glyphs yes
set -g theme_powerline_fonts yes
set -g theme_nerd_fonts no
set -g theme_show_exit_status yes
# dark, light, solarized-light/dark, zenburn, gruvbox, base16-light/dark
set -g theme_color_scheme solarized-dark
set -g fish_prompt_pwd_dir_length 4
set -g theme_project_dir_length 1


source ~/fish-init.local.fish
