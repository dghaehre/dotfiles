##################### GIT ####################
#--------------------------------------------#


abbr -a g git
abbr -a gs git status
abbr -a ga git add -u
abbr -a gd git diff
abbr -a gds git diff --staged
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



############################################

function git_currentbranch
  git rev-parse --abbrev-ref HEAD
end

function git_havechanges --description "are there any changes to the current git repo?"
  set -l st (git status | tail -n 1)
  if test "$st" = "nothing to commit, working tree clean"
    echo "no"
  else
    echo "yes"
  end
end

function git_haveremotechanges --description "are there any remote changes to the current branch?"
  set -l currentbranch (git_currentbranch)
  git fetch origin $currentbranch 2&> /dev/null
  set -l st (git status | rg "Your branch is behind" | wc -l)
  if test "$st" = "1"
    echo "yes"
      else
    echo "no"
  end
end


function git_push --description "add, commit and push to origin"
  if test (git_havechanges) = "yes"
    git add .
    git commit -m "update"
    git push origin (git_currentbranch)
  else
    echo "no changes"
  end
end

function git_pull --description "pull and merge"
  set -l remotechanges (git_haveremotechanges)
  if test (git_havechanges) = "yes" -a "$remotechanges" = "yes"
    read -P "You have uncommited local changes. Discard local changes? (N/y): " restore
    echo $restore
    if test "$restore" = "y"
      git restore .
    end
  end
  if test "$remotechanges" = "yes"
    git pull origin (git_currentbranch) --ff-only
  else
    echo "no remote changes"
  end
end

function git_tobepushed
    set branch (git branch | grep \* | cut -d ' ' -f2)
    git diff --stat --cached origin/$branch
end

function git_topush
    set branch (git branch | grep \* | cut -d ' ' -f2)
    git log origin/$branch...$branch
end



##################### SYNC ######################
#-----------------------------------------------#

function sy --description "My sync :)"
  set -l originaldir (pwd)
  if test -z "$argv[1]"
    set_color red
    echo "Missing argument: push | pull"
    set_color normal
    echo ""

  else if test "$argv[1]" = "pull"
    set_color yellow
    echo "-- pulling taskwarrior"
    set_color normal
    cd ~/.task
    git_pull

    echo ""
    set_color yellow
    echo "-- pulling vimwiki"
    set_color normal
    cd ~/wikis/vimwiki
    git_pull

  else if test "$argv[1]" = "push"
    set_color yellow
    echo "-- pushing taskwarrior"
    set_color normal
    cd ~/.task
    git_push

    echo ""
    set_color yellow
    echo "-- pushing vimwiki"
    set_color normal
    cd ~/wikis/vimwiki
    git_push

  else
    set_color red
    echo "Wrong argument. Expects: push | pull"
    set_color normal
    echo ""
  end
  cd $originaldir
end
