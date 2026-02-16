##################### DEFAULTS ####################
#-------------------------------------------------#
# Mac specofic
eval "$(/opt/homebrew/bin/brew shellenv)"
# set -x SHELL /bin/bash in case of errors
setenv EDITOR 'nvim'
# setenv BROWSER 'Firefox'
set -e BROWSER
export KEYTIMEOUT 1
setenv PAGER 'bat --style=plain'
setenv REVIEW_BASE 'main'
fish_add_path ~/.local/bin
setenv GOPATH (go env GOPATH)
fish_add_path (go env GOPATH)/bin
source ~/.config/fish/git.fish
set -ag FZF_DEFAULT_OPTS '--color=bg+:24,gutter:-1'

setenv XDG_CONFIG_HOME "$HOME/.config" # Make configs work on macos

# Flyctl
setenv FLYCTL_INSTALL '~/.fly'
fish_add_path ~/.fly/bin

# Ruby on macos
fish_add_path /opt/homebrew/opt/ruby/bin

abbr -a clean-derived-data "rm -rf ~/Library/Developer/Xcode/DerivedData"


##################### Vim Keys  ########################
#------------------------------------------------------#
fish_vi_key_bindings
set -U fish_cursor_insert block
set -U fish_cursor_default block

##################### WorkTrunk  ########################
#------------------------------------------------------#
abbr -a wl wt list --full --progressive
abbr -a ws wt switch
abbr -a wc wt switch --create


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
abbr -a vim nvim

abbr -a rss newsboat --url-file ~/wikis/vimwiki/rss-urls --cache-file ~/wikis/vimwiki/rss.db
abbr -a view_pdf "pandoc -f markdown -t pdf --pdf-engine wkhtmltopdf input.md | zathura - "
abbr -a create_pdf "pandoc -f markdown -t pdf --pdf-engine wkhtmltopdf input.md --output test.pdf"
abbr -a test_microphone arecord -vvv -f dat /dev/null
abbr -a janet-server janet -e '"(import spork/netrepl) (netrepl/server)"'
# abbr -a lg lazygit
abbr -a todo rg -e \"- \\[ \\]\" ~/wikis/work/todo.md
abbr -a empty-lsp-log echo "" > ~/.cache/nvim/lsp.log
# abbr -a ts trans -shell

abbr -a fix-todo cursor-agent "Please look in the staged changes for any TODO comment. Please implement fix for the TODO comment. Be very short and concise. Dont make any other changes than what the TODO comment suggest. Be very sure your implementation is correct, if you need to research the project to be sure please do so."

# Screen cast laptop size from the left (without audio)
# https://wiki.archlinux.org/title/FFmpeg#Screen_capture
abbr -a screencast ffmpeg -f x11grab -video_size 1920x1200 -framerate 30 -i $DISPLAY -c:v libx264 -preset ultrafast -c:a aac screencast.mp4

alias hf="hledger -f ~/projects/personal/ledger/2022/felles.journal"
alias hd="hledger -f ~/projects/personal/ledger/2022/daniel.journal"

# Open remote note
abbr -a rnote nvim scp://pi@home.pi//home/pi/note.md

abbr -a jme "jira issue list -a(jira me) -s~Done -s~\"Won't Do\""
abbr -a jc jira issue create

# If I wanna stop using jj
abbr -a remove-jj git clean -xdf

function jj-branch
	set result (jj b list -r @ 2>/dev/null | string split -m1 ":" | head -n1)
	if test -z "$result"
			jj b list -r @- 2>/dev/null | string split -m1 ":" | head -n1 
	else
		echo $result
	end
end

function jj-review
	set -l path "$(pwd)-review"
	set -l name (basename $path)
	jj workspace add --name $name $path
	cd $path
	codex -a on-failure
end

# TODO
function jj-review-cleanup

end

abbr -a jjpr "gh pr create --web --fill --head (jj-branch)"

# Edit comlandline in editor
bind \ce edit_command_buffer
bind -M insert \ce edit_command_buffer
bind -M insert \cl accept-autosuggestion
bind -M insert \t  complete-and-search


if type -q docker
  abbr -a dockerrm docker rm (docker ps -q)
end

# Set keyboard layout (is set by i3, but nice to have)
function my-layout
  setxkbmap -option 'caps:ctrl_modifier' -option 'lv3:ralt_switch' -variant 'mac'
  xcape -e '#66=Escape'
  xset r rate 300 80
end

# set webcam to 50hz
abbr -a camflickering v4l2-ctl --set-ctrl power_line_frequency=1


##################### Taskwarrior ####################
#----------------------------------------------------#
abbr -a t task
abbr -a tui taskwarrior-tui
abbr -a ta task add
abbr -a tr task ready
abbr -a te task edit
abbr -a ti task rc.context=none inbox
abbr -a tm task mod
abbr -a ts task start
abbr -a tand task +LATEST mod
abbr -a td task done
abbr -a tp task plan
abbr -a tl task later
abbr -a tw task waiting
# task today
abbr -a tt task \""+READY (scheduled.before=eod or due.before=tom+48h)\""
# task scheduled none
abbr -a tsn task ready scheduled.none:
abbr -a plan task plan
abbr -a th task all status:completed end.after:

function tdd
  task (task ids +ACTIVE) done
end

function tss
  task (task ids +ACTIVE) stop
end

# function th -d "List all completed task since {days} ago, for given {project}"
#   if test -n "$argv[2]"
#     task all "(status:pending or status:completed)" end.after:-$argv[1]d $argv[2..-1] 
#   else 
#     task all "(status:pending or status:completed)" end.after:-$argv[1]d
#   end
# end

# Example usage:
#
# tpr but-1234 +name
# tpr but-1234 +name proj:project
function tpr -d "A task template for pr reviews"
  task add review PR $argv
end

function tprn -d "A task template for pr reviews to be review now"
  tpr $argv sch:tod
  task (task ids +ACTIVE) stop
  task (task ids +LATEST) start
end


# LazyGit

function lg
	echo "Starting LazyGit..."
	set -gx LAZYGIT_NEW_DIR_FILE "$HOME/.lazygit/newdir"
	lazygit $argv
	if test -f "$LAZYGIT_NEW_DIR_FILE"
			cd (cat "$LAZYGIT_NEW_DIR_FILE")
			rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
	end
end

function w
	set -l WK_NEW_DIR_FILE "$HOME/.wk-new-dir"
	wk
	if test -f "$WK_NEW_DIR_FILE"
			cd (cat "$WK_NEW_DIR_FILE")
			rm -f "$WK_NEW_DIR_FILE" > /dev/null
	else
		echo "no file"
	end
end


# Usage:
# checkpr main but-1234
function checkpr
  git fetch origin
  git checkout $argv[2]
  git reset --soft origin/$argv[1]
  git restore --staged .
end

function readinvim -d "read a url in vim"
  curl https://earthly-tools.com/text-mode\?url\=https://$argv[1] | nvim
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

# Taskwarrior
function add-project-fzf
  set -l selected (task _unique project | fzf -m --prompt="project> ")
  if test -n "$selected"
    commandline -i -- " project:$selected"
  end
end
# bind -M insert \cp 'add-project-fzf'

function add-tags-fzf
  set -l selected (task _unique tags | fzf -m --prompt="tags> ")
  if test -n "$selected"
    set -l tags (echo "$selected" | format-tags)
    commandline -i -- " $tags"
  end
end
# bind -M insert \ct 'add-tags-fzf'

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
  if test -d ./.jj
		echo -n ' (jj) '
	else
		printf '%s ' (__fish_git_prompt)
	end
  set_color brblack
  echo -n '| '
  set_color normal
end

# TODO: show time if there is no context!
function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold yellow
      echo -n "[N] "
    case insert
      set_color brblack
      echo -n "[I] "
    case replace_one
      set_color --bold blue
      echo -n "[R] "
    case visual
      set_color --bold brmagenta
      echo -n "[V] "
    case '*' # replace_something
      set_color --bold brmagenta
      echo -n "[R] "
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
set fish_color_selection '--background=666'
set fish_pager_color_description yellow


##################### Fish GIT Prompt ########################
#--------------------------------------------------------#
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_char_cleanstate ''
set __fish_git_prompt_color 'green'
set __fish_git_prompt_showstashstate ''
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
  xrandr --output DP2 --auto --$argv-of eDP1
end

function hmonitor
  xrandr --output HDMI1 --auto --$argv-of eDP1
end


##################### File manager ####################
#-----------------------------------------------------#
# To make cd work for lf
function lfcd
    set tmp (mktemp)
    lf -last-dir-path=$tmp $argv
    if test -f "$tmp"
        set dir (cat $tmp)
        rm -f $tmp
        if test -d "$dir"
            if test "$dir" != (pwd)
                cd $dir
            end
        end
    end
end
abbr -a n lfcd


# Stop and remove all running containers
function rad
	# Stop all containers
	docker stop (docker ps -aq) 2>/dev/null
	# Remove all containers
	docker rm (docker ps -aq) 2>/dev/null
	echo "All containers removed."
end


##################### Zoxide ####################
#-----------------------------------------------------#
if command -v zoxide > /dev/null
  zoxide init --cmd cd fish | source
end


##################### Secret ####################
#-----------------------------"-------------------#
if test -e ~/.config/fish/secret.fish
  source ~/.config/fish/secret.fish
end


##################### NVM ####################
#-----------------------------------------------------#
# function nvm
#     bash -c "source ~/.nvm/nvm.sh; nvm $argv"
# end
function nvm
	set -x current_path $(mktemp)
	bash -c "source ~/.nvm/nvm.sh --no-use; nvm $argv; dirname \$(nvm which current) >$current_path"
	fish_add_path -m $(cat $current_path)
	rm $current_path
end
# if type -q nvm
#   nvm use lts/gallium > /dev/null
# end
