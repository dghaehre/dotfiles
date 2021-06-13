##################### ZSH  ####################
#------------------------------------------------#
export PATH=~/.local/bin:$PATH
export GOPATH=~/Desktop/sider/golang
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
source ~/.config/broot/launcher/bash/br

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
alias c="clear"
alias desk="cd ~/Desktop/"
alias sider="cd ~/Desktop/sider"
alias down="cd ~/Downloads"
alias backups="cd ~/Backups"
alias keys="cd ~/Desktop/keys"
alias git='TZ=UTC git'
alias gl='git checkout'
alias please='sudo !!'
alias nmutt='cd ~/Desktop/mail && neomutt'
alias loadmail='cd ~/Desktop/mail && mbsync -a && notmuch new'
alias cpwd="pwd | xsel -b"
alias wiki="cd ~/wikis/personal && nvim -c VimwikiIndex"
alias pg="pget github"
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

alias ht="ht-rust"
alias v="nvim"
alias hindent="~/builds/hindent"
alias topdf="pandoc -f markdown -t pdf -o doc.pdf -V geometry:a4paper -V geometry:margin=2cm -V mainfont=\"[source code pro]\" $x --pdf-engine wkhtmltopdf"
alias sudov="sudo -E nvim"
alias xsetrate="xset r rate 300 40 && feh --bg-scale ~/.config/i3/background-2.jpg"
alias rss="newsboat --url-file ~/wikis/personal/rss-urls"
function dcd {
  br --only-folders --cmd "$1;:cd"
}
function b {
  cd ~
  dcd $1
}
alias mail="neomutt -F ~/wikis/personal/mutt/muttrc"


# Push personal diary to keybase
alias push-diary="cd ~/wikis/personal && keybase login -s dghaehre_ && pushall"
alias pull-diary="cd ~/wikis/personal && keybase login -s dghaehre_ && pullall"
alias push-wikis="cd ~/wikis/work && pushall && push-diary"

# Todo.txt
export TODO_ACTIONS_DIR="/home/$USER/.todotxt/plugins"
export TODOTXT_FINAL_FILTER="$TODO_ACTIONS_DIR/futureTasks"
alias t="todo.sh -d ~/Dropbox/todotxt/config"
alias work="t ls @work"
alias waiting="t lsp W"

# Set and show 'now'
function now() {
  if [ -z "$1" ]; then
    t lsp A
  else
    current=$(t lsp A | head -n 1 | awk '{print $1}')
    if [ $current != "--" ]; then
      number=$(echo $current | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | bc)
      t -f p $number B
    fi
    t -f p $1 A
  fi
}

# Complete 'now'
function dnow() {
  current=$(t lsp A | head -n 1 | awk '{print $1}')
  if [ $current != "--" ]; then
    number=$(echo $current | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | bc)
    t do $number
  else
    echo "Nothing is registered as 'now'"
  fi
}

# Clear 'now'
function cnow() {
  current=$(t lsp A | head -n 1 | awk '{print $1}')
  if [ $current != "--" ]; then
    number=$(echo $current | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | bc)
    t -f p $number B
  else
    echo "Nothing is registered as 'now'"
  fi
}

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





##################### BAT ########################
#------------------------------------------------#
export BAT_PAGER="less -R"
export BAT_THEME="zenburn"



##################### SSH  #######################
#------------------------------------------------#

function sshdaniel() {
    echo Trying ssh with current folder data
    host=$(ls | grep @)
    key=$(ls | grep .pem)
    isport=$(ls | grep port.txt)
    if [ -z "$isport" ]; then
      port=""
    else
      port="-p $(cat port.txt)"
    fi
    if [ -z "$key" ]; then
        ispassowrd=$( ls | grep password.txt)
        if [ -z "$ispassword" ]; then
            echo password copied to clipboard
            cat password.txt | tr -d '\n' | xsel -b
            ssh -o PasswordAuthentication=yes -o IdentitiesOnly=yes $host $port
        else
            echo Found no .pem key or password.txt file
        fi
    else
        ssh -i $key -o IdentitiesOnly=yes $host $port
    fi
}

function logind() {
  s=$(ls ~/Desktop/keys/ssh | dmenu -l 30 -p ':SSH')
  if [ ! -z "$s" ]; then
    cd ~/Desktop/keys/ssh/$s
    sshdaniel
  fi
}




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




##################### Rust ####################
#---------------------------------------------#
function musl-build() {
  docker run \
    -v cargo-cache:/root/.cargo \
    -v "$PWD:/volume" \
    --rm -it clux/muslrust cargo build --release
}

eval "$(starship init zsh)"
