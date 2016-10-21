set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

function _pwd_with_tilde
  echo $PWD | sed 's|^'$HOME'\(.*\)$|~\1|'
end

function _print_in_color
  set -l string $argv[1]
  set -l color  $argv[2]

  set_color $color
  printf $string
  set_color normal
end

function _prompt_color_for_status
  if test $argv[1] -eq 0
    echo magenta
  else
    echo red
  end
end


function _git --description 'git'
        set -l branch (__fish_git_prompt | sed 's/^ (//g;s/)$//g')
        if [ -n "$branch" ]
            set -l ret
            set -l end "$NO_COL"

            if [ (git status 2> /dev/null | grep "# Untracked") ]
                set end "$LP_COLOR_CHANGES""$LP_MARK_UNTRACKED""$end"
            end
            if [ (git stash list 2> /dev/null) ]
                set end "$LP_COLOR_COMMITS""$LP_MARK_STASH""$end"
            end

            set -l remote (git config --get branch.{$branch}.remote 2> /dev/null)
            set -l has_commit 0

            if [ -n "$remote" ]
                set -l remote_branch (git config --get branch.{$branch}.merge)
                if [ -n "$remote_branch" ]
                    set -l tmp_string (echo $remote_branch | sed "s/refs\/heads/refs\/remotes\/$remote/")
                    set has_commit (git rev-list --no-merges --count {$tmp_string}..HEAD 2> /dev/null)
                    if [ -z "$has_commit" ]
                        set has_commit 0
                    end
                end
            end

            set -l shortstat (git diff --shortstat 2> /dev/null)
            if [ -n "$shortstat" ]
                set -l has_lines (echo "$shortstat" | sed 's/^.*changed, //;s/ insert.*, /\/-/;s/ delet.*$//')
                if [ (echo "$shortstat" | grep "insertion") ]
                    set has_lines "+""$has_lines"
                else
                    set has_lines "-""$has_lines"
                end

                if [ "$has_commit" -gt 0 ]
                    set ret "$LP_COLOR_CHANGES""$branch""$NO_COL""(""$LP_COLOR_DIFF""$has_lines""$NO_COL"",""$LP_COLOR_COMMITS""$has_commit""$NO_COL"")"
                else
                    set ret "$LP_COLOR_CHANGES""$branch""$NO_COL""(""$LP_COLOR_DIFF""$has_lines""$NO_COL"")"
                end
            else
                if [ "$has_commit" -gt 0 ]
                    set ret "$LP_COLOR_COMMITS""$branch""$NO_COL""(""$LP_COLOR_COMMITS""$has_commit""$NO_COL"")"
                else
                    set ret "$LP_COLOR_UP""$branch""$NO_COL"
                end
            end

            echo "$ret""$end"" "
        end
    end




function fish_prompt
  set -l last_status $status
        
  _print_in_color "\n"(date "+$c2%H$c0:$c2%M$c0:$c2%S ") blue
  _print_in_color (_pwd_with_tilde) blue 

  if [ (__fish_git_prompt) ]
    printf ' %s ' (_git)
  end

  _print_in_color "\n❯ " (_prompt_color_for_status $last_status)
end


