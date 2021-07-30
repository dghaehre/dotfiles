##################### ZSH  ####################
#------------------------------------------------#
export PATH=~/.local/bin:$PATH
export GOPATH=~/projects/.golang
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load broot
if test -f "~/.config/broot/launcher/bash/br"; then
  source ~/.config/broot/launcher/bash/br
fi

if test -f "~/Desktop/tomb/.zshrc"; then
  source ~/Desktop/tomb/.zshrc
fi





##################### DEFAULTS ####################
#-------------------------------------------------#
export EDITOR='nvim'
export VISUAL='nvim'
bindkey -v # vim mode
export KEYTIMEOUT=1
export PAGER="less"






##################### Simple aliases ####################
#-------------------------------------------------------#
alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
alias desk="cd ~/Desktop"
alias projects="cd ~/projects"
alias dot="cd ~/dotfiles"
alias down="cd ~/Downloads"
alias backups="cd ~/Backups"
alias gl='git checkout'
alias please='sudo !!'
alias cpwd="pwd | xsel -b"
alias wiki="cd ~/wikis/personal && nvim -c VimwikiIndex"
alias dmenu="dmenu -b -nb '#2f343f' -sb '#2f343f'"
alias ls="exa"
alias spu="sudo pacman -Syu"
alias l="exa -la --git --group"
alias untar="tar -xvzf $x"
function dotar() {
  tar -czvf $1.tar.gz ./$1
}
# tmux
alias tmux="env TERM=screen-256color tmux -u -c \"open-tmux-session home\""
alias os="open-tmux-session"

alias v="nvim"
alias topdf="pandoc -f markdown -t pdf -o doc.pdf -V geometry:a4paper -V geometry:margin=2cm -V mainfont=\"[source code pro]\" $x --pdf-engine wkhtmltopdf"
alias sudov="sudo -E nvim"
alias xsetrate="xset r rate 300 40 && feh --bg-scale ~/.config/i3/background.jpg"
alias rss="newsboat --url-file ~/wikis/personal/rss-urls"
alias mail="cd ~/mail && neomutt -F ~/wikis/personal/mutt/muttrc"


# Push personal diary to keybase
alias push-diary="cd ~/wikis/personal && keybase login -s dghaehre_ && pushall"
alias pull-diary="cd ~/wikis/personal && keybase login -s dghaehre_ && pullall"
alias push-wikis="cd ~/wikis/work && pushall && push-diary"

# Todo.txt
export TODO_ACTIONS_DIR="/home/$USER/.todotxt/plugins"
export TODOTXT_FINAL_FILTER="$TODO_ACTIONS_DIR/futureTasks"
alias t="todo.sh -d ~/Dropbox/todotxt/config"
# Goals
alias g="todo.sh -d ~/Dropbox/todotxt/goal_config"


##################### Utilities ####################
#--------------------------------------------------#
function pushall() {
  branch=$(git branch --show-current)
  git add .
  git commit -a -m "update $(date +"%dth %B, %Y")"
  git push origin $branch
}

# TODO: handle merge conflict
function pullall() {
  branch=$(git branch --show-current)
  git pull origin $branch
}

# Dispaly status on the processes I need/want to monitor
function status() {
  echo "USER@1000"
  systemctl status user@1000
}

function makeKey() {
  if [ -z $2 ]; then
    echo "Usage: makeKey username password"
  else
    openssl sha256 -hmac "$2" -binary <(echo -n "$1") | base64
  fi
}

##################### FZF  ####################
#------------------------------------------------#
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
bindkey -v '^?' backward-delete-char
bindkey -v '^r' fzf-history-widget
bindkey -v '^f' fzf-cd-widget



##################### NNN #########################
#-------------------------------------------------#
# colors taken from https://github.com/jarun/nnn/wiki/Themes
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
# Bookmarks
export NNN_BMS="d:~/dotfiles;p:~/projects/personal;w:~/wikis/personal;j:~/projects/work"

n () { # Enable NNN to cd
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
      echo "nnn is already running"
      return
  fi
  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  # To cd on quit only on ^G, remove the "export" as in:
  #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  nnn "$@"
  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}


##################### BAT ########################
#------------------------------------------------#
export BAT_PAGER="less -R"
export BAT_THEME="zenburn"



##################### Display ####################
#------------------------------------------------#
# Display DP to either left or right
# USAGE: dmonitor right
function dmonitor() {
  xrandr --output DP1 --auto --$1-of eDP1
}

# Display DP and turn off laptop screen
function dmonitor-only() {
  xrandr --output DP1 --auto --primary
  xrandr --output eDP1 --off
}

# Display HDMI2 to either left or right
# USAGE: hmonitor right
function hmonitor() {
  xrandr --output HDMI2 --auto --$1-of eDP1
}


##################### GIT ####################
#--------------------------------------------#
function to-be-pushed() {
    branch=$(git branch | grep \* | cut -d ' ' -f2)
    git diff --stat --cached origin/$branch
}

function git-to-push() {
    branch=$(git branch | grep \* | cut -d ' ' -f2)
    git log origin/$branch...$branch
}

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
