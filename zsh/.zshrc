##################### ZSH  ####################
#------------------------------------------------#
# Path to your oh-my-zsh installation.
# export ZSH="/usr/share/oh-my-zsh"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
export PATH=~/.local/bin:$PATH
export GOPATH=~/Desktop/sider/golang
# ZSH_THEME="fwalch"
plugins=(
  git
  colored-man-pages
  tmux
  rust
  yarn
  stack
)

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
alias mamp="cd /Applications/MAMP/htdocs"
alias zshconfig="vim ~/.zshrc"
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
alias tmux="env TERM=screen-256color tmux -u"
# alias tmux="env TERM=myterm-it tmux -u"
alias ta="tmux attach"
alias ht="ht-rust"
alias v="nvim"
alias hindent="~/builds/hindent"
alias a='echo "------------ Your aliases ---------------";alias;'
alias topdf="pandoc -f markdown -t pdf -o doc.pdf -V geometry:a4paper -V geometry:margin=2cm -V mainfont=\"[source code pro]\" $x --pdf-engine wkhtmltopdf"
alias sudov="sudo -E nvim"
alias xsetrate="xset r rate 300 40 && feh --bg-scale ~/.config/i3/background-2.jpg"


# Push personal diary to keybase
alias push-diary="cd ~/wikis/personal && keybase login -s dghaehre_ && pushall"
alias push-wikis="cd ~/wikis/work && pushall && push-diary"

# todo.txt
alias todo="todo.sh -d ~/Dropbox/todotxt/config"
# alias today="t lsp A-B"
alias work="todo ls @work"
alias worko="todo lsp O @work"
alias waiting="todo lsp W"
alias thisweek="todo lsp B C"
# Set and show 'now'
function now() {
  if [ -z "$1" ]; then
    todo lsp A
  else
    current=$(t lsp A | head -n 1 | awk '{print $1}')
    if [ $current != "--" ]; then
      number=$(echo $current | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | bc)
      todo -f p $number B
    fi
    todo -f p $1 A
  fi
}
# Complete 'now'
function dnow() {
  current=$(todo lsp A | head -n 1 | awk '{print $1}')
  if [ $current != "--" ]; then
    number=$(echo $current | sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g' | bc)
    todo do $number
  else
    echo "Nothing is registered as 'now'"
  fi
}

# taskwarrior
# alias t="task"
alias pushtask="cd ~/.task && keybase login -s dghaehre_ && pushall && push-task-website"
alias pulltask="cd ~/.task && keybase login -s dghaehre_ && git pull origin master"
alias synctask="pulltask && pushtask"

# Todoist
alias t="todoist --color"
alias inbox="todoist --color l --filter '#Inbox'"
alias today="todoist --color l --filter 'today'"

##################### Utilities ####################
#--------------------------------------------------#
function pushall() {
  branch=$(git branch --show-current)
  git add .
  git commit -a -m "update $(date +"%dth %B, %Y")"
  git push origin $branch
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






##################### File manager ####################
#-----------------------------------------------------#
export NNN_PLUG='v:-_bat $nnn*;e:fzopen;o:fzcd;'
export NNN_COLORS="6213"  # use a different color for each context
export NNN_BMS='d:~/Downloads/;s:~/Desktop/sider/;n:~/Desktop/tomb/;c:~/.dotfiles/;k:~/Desktop/keys/ssh/'
alias n="nn -eH"
function nn () {
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  # To cd on quit only on ^G, remove the "export" as in:
  #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  # NOTE: NNN_TMPFILE is fixed, should not be modified
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
  # stty start undef
  # stty stop undef
  # stty lwrap undef
  # stty lnext undef
  nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}




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
