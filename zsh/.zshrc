##################### ZSH  ####################
#------------------------------------------------#
# Path to your oh-my-zsh installation.
export ZSH="/usr/share/oh-my-zsh"
export PATH=~/.local/bin:$PATH
# alias tmux="env TERM=screen-256color tmux"
alias tmux="env TERM=myterm-it tmux"
# ZSH_THEME="fwalch"
plugins=(
  git
  colored-man-pages
  tmux
  rust
  yarn
  stack
)
source $ZSH/oh-my-zsh.sh
# source /usr/share/nvm/init-nvm.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/Desktop/tomb/.zshrc





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
alias go='git checkout'
alias please='sudo !!'
alias cpwd="pwd | xsel -b"
alias wiki="cd ~/vimwiki && nvim -c VimwikiIndex"
alias pg="pget github"
alias dmenu="dmenu -b -nb '#2f343f' -sb '#2f343f'"
alias wiki="cd ~/vimwiki && nvim -c VimwikiIndex"
alias ls="exa"
alias spu="sudo pacman -Syu"
alias l="exa -la --git"
alias untar="tar -xvzf $x"
alias ta="tmux attach"
alias v="nvim"
alias hindent="~/builds/hindent"
alias a='echo "------------ Your aliases ---------------";alias;'
alias topdf="pandoc -f markdown -t pdf -o doc.pdf -V mainfont=\"[source code pro]\" $x --pdf-engine wkhtmltopdf"
alias sudov="sudo -E nvim"
# Push personal diary to keybase
alias push-diary="cd ~/wikis/personal && keybase login -s dghaehre_ && pushall"
alias push-wikis="cd ~/wikis/work && pushall && push-diary"






##################### Utilities ####################
#--------------------------------------------------#
function s() {
  if [ -z "$2" ]; then
    grep -rn ./ -e "$1"
  else
    grep -rn $1 -e "$2"
  fi
}

function pushall() {
  branch=$(git branch --show-current)
  git add .
  git commit -a -m "update $(date +"%dth %B, %Y")"
  git push origin $branch
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
