#-*- shell-script -*-
# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

TERM='rxvt-unicode'
COLORTERM='rxvt-unicode-256color'
LANG='en_US.UTF-8'

source /etc/profile

source ~/git/dotfiles/antigen/antigen.zsh

antigen-bundle zsh-users/zsh-syntax-highlighting

antigen-bundle zsh-users/zsh-completions

antigen-bundle zsh-users/zsh-history-substring-search

antigen-apply

autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

source ~/git/zsh-vcs-prompt/zshrc.sh
PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~%b%{$reset_color%} $(vcs_super_info)
$ '
RPROMPT='%(?..(%?%))'
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl:/home/expez/bin:/home/expez/.cabal/bin

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# enable completions
autoload -U compinit
compinit -i
zmodload -i zsh/complist
setopt completealiases
setopt complete_in_word
setopt always_to_end

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# use /etc/hosts and known_hosts for hostname completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

#Fuzzy matching for completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#Ignore completions for functions I don't have.
zstyle ':completion:*:functions' ignored-patterns '_*'

#Remove trailing slashes in directory arguments
zstyle ':completion:*' squeeze-slashes true

#Ignore parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Open current line in editor.
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# FAQ 3.10: Why does zsh not work in an Emacs shell mode any more?
# http://zsh.sourceforge.net/FAQ/zshfaq03.html#l26
[[ $EMACS = t ]] && unsetopt zle

# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd..:..:[ ]*"
export HISTSIZE=50000
export HISTFILE=~/.zsh_history
export SAVEHIST=30000
setopt INC_APPEND_HISTORY
setopt hist_ignore_dups
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt hist_allow_clobber
setopt hist_no_functions
setopt share_history

setopt no_beep
setopt auto_cd
setopt extended_glob
# Zsh spelling correction options
setopt CORRECT

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

#Don't send HUP to background jobs when the shell is closed
setopt no_hup
# Watch other user login/out
watch=notme
export LOGCHECK=60

# Don't use American date style
export TIME_STYLE="long-iso"

# Calculator
autoload zcalc

# PDF viewer (just type 'file.pdf')
if [[ -x `which kpdf` ]]; then
    alias -s 'pdf=kfmclient exec'
else
    if [[ -x `which gpdf` ]]; then
	alias -s 'pdf=gpdf'
    else
	if [[ -x `which evince` ]]; then
	    alias -s 'pdf=evince'
	fi
    fi
fi

# modified commands
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias less='less --ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init $1'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'
alias cd..='cd ..'

# new commands
alias tf='tail -f'
alias da='date "+%A, %B %d, %Y [%T], %V"'
alias du1='du --max-depth=1 | sort -n'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias psg='ps -Af | grep $1' # requires an argument
alias vnice='nice -n 20 ionice -c 3'
alias -g rmr='rm -rf'
alias pv='ping www.vg.no'
alias cls='clear'
alias pandora='sudo ssh -L 80:www.pandora.com:80 -L 443:www.pandora.com:443 expez@50.116.63.15'
# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors` ]]; then
	eval `dircolors -b`
	alias ls='ls -hF --color=auto'
    fi
fi

alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'
alias dugs='du1 | grep [0-9]G | sort -n'
# safety features
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias ald="echo \"echo 'alias name=\"command\"' >> ~/.zshrc && . ~/.zshrc\""

#Pacman aliases
alias pac="sudo pacman -S"                           # default action     - install one or more packages
alias pacu="sudo pacman -Syu"                        # '[u]pdate'         - upgrade all packages to their newest version
alias pacul="pacman -Qu"                             # List packages with updates available
alias pacli="pacman -Q"                              # [Li]st all installed packages.
alias pacg="sudo pacman -Syu"                        # 'up[g]rade'         - upgrade a package or install one created by makepg
alias pacs="pacman -Ss"                              # '[s]earch'         - search for a package using one or more keywords
alias paci="pacman -Si"                              # '[i]nfo'           - show information about a package
alias pacr="sudo pacman -R"                          # '[r]emove'         - uninstall one or more packages
alias pacl="pacman -Sl"                              # 'repository [l]ist' - list all packages of a repository
alias pacll="pacman -Qqm"                            # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
alias paclsorphans="pacman -Qdt"                     # '[l]ist [o]rphans' - list all packages which are orphaned
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)' #  Remove orphans
alias paco="pacman -Qo"                              # '[o]wner'          - determine which package owns a given file
alias pacf="pacman -Ql"                              # '[f]iles'          - list all files installed by a given package
alias pacc="sudo pacman -Sc"                         # '[c]lean cache'    - delete all not currently installed package files
alias pacm="makepkg -fcis"                           # '[m]ake'           - make package from PKGBUILD file in current directory

# edit file as root using emacs.
alias E="SUDO_EDITOR=\"emacsclient -c -a emacs\" sudoedit"
alias T="SUDO_EDITOR=\"emacsclient -t -a emacs\" sudoedit"
alias ec="emacsclient &"

alias src="source ~/.zshrc"
alias xevg="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias blkidc="sudo blkid -c /dev/null"
alias ssh='eval $(/usr/bin/keychain --eval --agents ssh -Q --quiet .ssh/id_rsa) && ssh'

# Global aliases (expand whatever their position)
#  e.g. find . ERR L
alias -g L='| less'
alias -g H='| head'
alias -g S='| sort'
alias -g TL='| tail'
alias -g N='> /dev/null'
alias -g ERR='2> /dev/null'
alias -g G='| grep -i $1'

alias rt='ssh -R 2222:localhost:22 expez@expez.com'

# Git aliases.
alias g='hub'
alias ga='git add'
alias gp='git push'
alias gl='git lg'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grh='git reset HEAD'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'

# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}

update-submodules() {
  git stash
  git submodule foreach "git remote update origin -p"
  git submodule foreach "git reset --hard origin/master"
  git commit -am "bump submodule"
  git stash pop
}

ignore() {
  if [ -z "$1" ] ; then
    cat .gitignore
  else
    if git status --porcelain | grep -vE '^[? ]' ; then
      echo "There is staged work, please commit or reset it"
      return 1
    fi

    echo "$1" >> .gitignore
    git add .gitignore
    git commit -m "ignore $1"
  fi

  return 0
}

eval "$(fasd --init auto)"
eval "$(hub alias -s)"

export AUTOJUMP_IGNORE_CASE=1
