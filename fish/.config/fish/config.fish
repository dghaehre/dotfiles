##################### DEFAULTS ####################
#-------------------------------------------------#
setenv EDITOR 'vim'
export KEYTIMEOUT 1
setenv PAGER 'less'



##################### Vim Keys  ########################
#------------------------------------------------------#
fish_vi_key_bindings
set -U fish_cursor_insert block
set -U fish_cursor_default block



##################### BAT ########################
#------------------------------------------------#
export BAT_PAGER="less -R"
export BAT_THEME="zenburn"



##################### Fish Prompt ########################
#--------------------------------------------------------#
function fish_prompt
  set_color brblack
  echo -n "["(date "+%H:%M")"] "
    set_color blue
  echo -n (hostname)
    if [ $PWD != $HOME ]
    set_color brblack
    echo -n ':'
    set_color yellow
  echo -n (basename $PWD)
    end
    set_color green
    printf '%s ' (__fish_git_prompt)
    set_color red
    echo -n '| '
    set_color normal
end

function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold red
      echo 'N '
    case insert
      set_color --bold green
      echo ''
    case replace_one
      set_color --bold green
      echo 'R '
    case visual
      set_color --bold brmagenta
      echo 'V '
    case '*'
      set_color --bold red
      echo '?'
    end
    set_color normal
end

set fish_color_error red --bold
set fish_color_command cyan --bold
set fish_color_param cyan
set fish_color_param cyan



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




function s
  if [ -z "$2" ]
    grep -rn ./ -e "$1"
  else
    grep -rn $argv -e "$2"
  end
end

abbr -a view-pdf "pandoc -f markdown -t pdf --pdf-engine wkhtmltopdf input.md | zathura - "
abbr -a create-pdf "pandoc -f markdown -t pdf --pdf-engine wkhtmltopdf input.md --output test.pdf" 


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




##################### SSH  #######################
#------------------------------------------------#

function sshdaniel
  echo Trying ssh with current folder data
  set host (ls | grep @)
  set key (ls | grep .pem)
  set isport (ls | grep port.txt)
  if [ -z "$isport" ]
    set port ""
  else
    set p (cat port.txt)
    set port "-p $p"
  end
  if [ -z "$key" ]
      set ispassowrd ( ls | grep password.txt)
      if [ -z "$ispassword" ]
          echo password copied to clipboard
          cat password.txt | tr -d '\n' | xsel -b
          ssh -o PasswordAuthentication=yes -o IdentitiesOnly=yes $host $port
      else
          echo Found no .pem key or password.txt file
      end
  else
      ssh -i $key -o IdentitiesOnly=yes $host $port
  end
end

function logind
  set s (ls ~/Desktop/keys/ssh | dmenu -p 'SSH:')
  if [ ! -z "$s" ]
    cd ~/Desktop/keys/ssh/$s
    sshdaniel
  end
end




##################### Display ####################
#------------------------------------------------#
# Display DP to either left or right
# USAGE: dmonitor right
function dmonitor
  xrandr --output DP1 --auto --$argv-of eDP1
end


##################### GIT ####################
#--------------------------------------------#
function to-be-pushed
    set branch (git branch | grep \* | cut -d ' ' -f2)
    git diff --stat --cached origin/$branch
end

function git-to-push
    set branch (git branch | grep \* | cut -d ' ' -f2)
    git log origin/$branch...$branch
end


##################### Rust ####################
#---------------------------------------------#
function musl-build
  docker run \
    -v cargo-cache:/root/.cargo \
    -v "$PWD:/volume" \
    --rm -it clux/muslrust cargo build --release
end


##################### Fix bugs ####################
#-----------------------------"-------------------#
abbr -a tmux 'tmux -u'
abbr -a  vim 'vim -S ~/.vimrc'
