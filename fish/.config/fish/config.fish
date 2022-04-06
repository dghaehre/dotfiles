##################### DEFAULTS ####################
#-------------------------------------------------#
setenv EDITOR 'nvim'
setenv BROWSER 'firefox'
export KEYTIMEOUT 1
setenv PAGER 'bat --style=plain'
fish_add_path ~/.local/bin
setenv GOPATH (go env GOPATH)
fish_add_path (go env GOPATH)/bin


##################### Vim Keys  ########################
#------------------------------------------------------#
fish_vi_key_bindings
set -U fish_cursor_insert block
set -U fish_cursor_default block


##################### Abbr and aliases ####################
#------------------------------------------------#
abbr -a v 'nvim'
abbr -a tmux 'tmux -u -c "open-tmux-session home"'
abbr -a spu sudo pacman -Syu
abbr -a sp sudo pacman
abbr -a ss sudo systemctl
abbr -a untar tar -xvzf
abbr -a dotar tar -czvf
abbr -a sudov sudo -E nvim
abbr -a t task
abbr -a tui taskwarrior-tui
abbr -a ta task add
abbr -a tr task ready
abbr -a te task edit
abbr -a tm task mod
abbr -a ts task start
abbr -a tss task stop
abbr -a td task done
abbr -a tp task plan
abbr -a tl task log
abbr -a tw task waiting
abbr -a trw task add project:work
abbr -a rss newsboat --url-file ~/wikis/vimwiki/rss-urls
abbr -a view_pdf "pandoc -f markdown -t pdf --pdf-engine wkhtmltopdf input.md | zathura - "
abbr -a create_pdf "pandoc -f markdown -t pdf --pdf-engine wkhtmltopdf input.md --output test.pdf"
abbr -a test_microphone arecord -vvv -f dat /dev/null

if type -q docker
  abbr -a dockerrm docker rm (docker ps -q)
end

# set webcam to 50hz
abbr -a camflickering v4l2-ctl --set-ctrl power_line_frequency=1

function ttw
  task mod $argv[1] sch:tomorrow
end

function ttt
  task mod $argv[1] sch:today
end

# Usage:
# checkpr main but-1234
function checkpr
  git fetch origin
  git checkout $argv[2]
  git reset --soft origin/$argv[1]
  git restore --staged .
end

function gb
  if git rev-parse HEAD > /dev/null 2>&1
      set branch (git branch -a --sort=committerdate --color=always |
        fzf --height 100% --ansi --tac --preview-window=right,70% --preview 'echo {} | awk \'{print $1}\' | xargs git lg --color=always -n 10' | sed 's/^..//' | awk '{print $1}' |
        sed 's#^remotes/[^/]*/##')
      git checkout $branch
  else
    echo "Not in a git repo"
  end
end

alias ..="cd .."
alias ...="cd ../.."

function s
  if [ -z "$2" ]
    grep -rn ./ -e "$1"
  else
    grep -rn $argv -e "$2"
  end
end

function cdir
  mkdir -p $argv[1]
  cd $argv[1]
end


if command -v exa > /dev/null
  abbr -a l 'exa -la'
	abbr -a ls 'exa'
	abbr -a ll 'exa -la --git --group'
  abbr -a ds 'exa -D --tree --level 4'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end


##################### BAT ########################
#------------------------------------------------#
export BAT_PAGER="less -R"
export BAT_THEME="zenburn"



##################### FZF ########################
#------------------------------------------------#
if type -q fzf_configure_bindings
  fzf_configure_bindings --git_log=\cg --git_status=\cs --directory=\cf
end



############## Fish Prompt and Colors ####################
#--------------------------------------------------------#
function fish_prompt
  if [ $PWD != $HOME ]
    set_color blue
    echo -n (basename $PWD)
  else
    set_color blue
    echo -n '~'
  end
  set_color green
  printf '%s ' (__fish_git_prompt)
  set_color brblack
  echo -n '| '
  set_color normal
end

function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold yellow
      echo -n "["(date "+%H:%M")"] "
    case insert
      set_color brblack
      echo -n "["(date "+%H:%M")"] "
    case replace_one
      set_color --bold blue
      echo -n "["(date "+%H:%M")"] "
    case visual
      set_color --bold brmagenta
      echo -n "["(date "+%H:%M")"] "
    case '*'
      set_color --bold red
      echo '? '
    end
    set_color normal
end

function fish_greeting
end

set fish_color_error red --bold
set fish_color_command cyan --bold
set fish_color_param blue
set fish_color_search_match '--background=666'
set fish_color_autosuggestion '888'
set fish_color_comment '999'
set fish_pager_color_description yellow


##################### Fish GIT Prompt ########################
#--------------------------------------------------------#
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3



##################### Man page ########################
#-----------------------------------------------------#
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline



##################### Display ####################
#------------------------------------------------#
# Display DP to either left or right
# USAGE: dmonitor right
function dmonitor
  xrandr --output DP1 --auto --$argv-of eDP1
end

function hmonitor
  xrandr --output HDMI1 --auto --$argv-of eDP1
end

##################### GIT ####################
#--------------------------------------------#
abbr -a g git
abbr -a gs git status
abbr -a ga git add -u
abbr -a gd git diff
abbr -a gl git checkout
alias gps="git push -u origin (git rev-parse --abbrev-ref HEAD)"
alias gpl="git pull origin (git rev-parse --abbrev-ref HEAD)"
abbr -a gal git add .
abbr -a gc "git commit"
abbr -a gcm "git commit -m"
abbr -a gcf "git commit -m fixup"
abbr -a gca "git commit --amend"
abbr -a gsl "git-stash-fzf"
abbr -a gwl git worktree list
abbr -a gwa git worktree add
abbr -a gwr git worktree remove

function to-be-pushed
    set branch (git branch | grep \* | cut -d ' ' -f2)
    git diff --stat --cached origin/$branch
end

function git-to-push
    set branch (git branch | grep \* | cut -d ' ' -f2)
    git log origin/$branch...$branch
end


##################### File manager ####################
#-----------------------------------------------------#
export NNN_PLUG='v:-_bat $nnn*;e:fzopen;o:fzcd;'
export NNN_COLORS="6213"  # use a different color for each context
export NNN_BMS='d:~/Downloads/;'
if test -n "$XDG_CONFIG_HOME"
 set sessions_dir $XDG_CONFIG_HOME/.config/nnn/sessions
else
 set sessions_dir $HOME/.config/nnn/sessions
end

complete -c nnn -s A    -d 'disable dir auto-select'
complete -c nnn -s b -r -d 'bookmark key to open' -x -a '(echo $NNN_BMS | awk -F: -v RS=\; \'{print $1"\t"$2}\')'
complete -c nnn -s c    -d 'cli-only opener'
complete -c nnn -s d    -d 'start in detail mode'
complete -c nnn -s e    -d 'open text files in $VISUAL/$EDITOR/vi'
complete -c nnn -s E    -d 'use EDITOR for undetached edits'
complete -c nnn -s f    -d 'use readline history file'
complete -c nnn -s F    -d 'show fortune'
complete -c nnn -s g    -d 'regex filters'
complete -c nnn -s H    -d 'show hidden files'
complete -c nnn -s K    -d 'detect key collision'
complete -c nnn -s n    -d 'start in type-to-nav mode'
complete -c nnn -s o    -d 'open files only on Enter'
complete -c nnn -s p -r -d 'copy selection to file' -a '-\tstdout'
complete -c nnn -s Q    -d 'disable quit confirmation'
complete -c nnn -s r    -d 'show cp, mv progress (Linux-only)'
complete -c nnn -s R    -d 'disable rollover at edges'
complete -c nnn -s s -r -d 'load session by name' -x -a '@\t"last session" (ls $sessions_dir)'
complete -c nnn -s S    -d 'start in disk usage analyzer mode'
complete -c nnn -s t -r -d 'timeout in seconds to lock'
complete -c nnn -s T -r -d 'a d e r s t v'
complete -c nnn -s V    -d 'show program version and exit'
complete -c nnn -s x    -d 'notis, sel to system clipboard'
complete -c nnn -s h    -d 'show program help'

alias n="nn -eH"
function nn --description 'support nnn quit and change directory'
  # Block nesting of nnn in subshells
  if test -n NNNLVL
    if [ (expr $NNNLVL + 0) -ge 1 ]
      echo "nnn is already running"
      return
    end
  end

  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  # To cd on quit only on ^G, remove the "-x" as in:
  #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
  # NOTE: NNN_TMPFILE is fixed, should not be modified
  if test -n "$XDG_CONFIG_HOME"
    set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
  else
    set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
  end

  # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
  # stty start undef
  # stty stop undef
  # stty lwrap undef
  # stty lnext undef
  nnn $argv

  if test -e $NNN_TMPFILE
    source $NNN_TMPFILE
    rm $NNN_TMPFILE
  end
end

## Zoxide
if command -v zoxide > /dev/null
  zoxide init --cmd cd fish | source
end

##################### Secret ####################
#-----------------------------"-------------------#
if test -e ~/.config/fish/secret.fish
  source ~/.config/fish/secret.fish
end
