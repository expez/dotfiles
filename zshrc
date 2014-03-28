#-*- shell-script -*-

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

LANG='en_US.UTF-8'
TERM='rxvt-unicode'
COLORTERM='rxvt-unicode-256color'
[ -n "$TMUX" ] && export TERM=screen-256color

export GOBIN=~/lib/go/bin
export GOROOT=/usr/lib/go
export GOPATH=~/lib/go/
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GITHUB_USER=expez
source /etc/profile
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH
export PATH=/usr/bin/core_perl:$PATH
export PATH=/home/expez/bin:$PATH
export PATH=$HOME/.cask/bin:$PATH
export PATH=/home/expez/.cabal/bin:$PATH
export PATH=/home/expez/vendor/intellij/bin:$PATH
export PATH=/home/expez/.gem/ruby/2.0.0/bin:$PATH
source ~/vendor/antigen/antigen.zsh
if [ -f secrets.sh ]; then
  source secrets.sh
fi

antigen-bundle zsh-users/zsh-syntax-highlighting

antigen-bundle zsh-users/zsh-completions

antigen-bundle zsh-users/zsh-history-substring-search

antigen-apply

autoload -U colors
colors

autoload -U zmv
autoload -U zrecompile
[[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc >/dev/null 2>&1

# Allow for functions in the prompt.
setopt PROMPT_SUBST

source ~/vendor/zsh-vcs-prompt/zshrc.sh
PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~%b%{$reset_color%} $(vcs_super_info)
$ '
RPROMPT='%(?..(%?%))'

zstyle :compinstall filename '/home/expez/.zshrc'

zmodload -i zsh/complist
setopt completealiases
setopt complete_in_word
setopt always_to_end
setopt interactive_comments
unsetopt nomatch

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
export HISTCONTROL=removedups
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
        else
            if [[ -x `which zathura` ]]; then
                alias -s 'pdf=zathura'
            fi
        fi
    fi
fi

# modified commands
command -v colordiff >/dev/null 2>&1 && alias diff='colordiff'
command -v pacman-color >/dev/null 2>&1 && alias pacman='pacman-color'
alias grep='grep --color=auto'
alias less='less --ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init $1'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias cd..='cd ..'
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"
alias halt="sudo halt"
alias ssh='eval $(/usr/bin/keychain --eval --agents ssh -Q --quiet .ssh/id_rsa) && ssh'

# new commands
alias tf='tail -f'
alias da='date "+%A, %B %d, %Y [%T], %V"'
alias du1='du --max-depth=1 | sort -n'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias psg='ps aux | grep $1' # requires an argument
alias vnice='nice -n 20 ionice -c 3'
alias -g rmr='rm -rf'
alias -g cpr='cp -r'
alias pv='ping www.vg.no'
alias cls='clear'
alias blkidc="sudo blkid -c /dev/null"
alias xevg="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias src="source ~/.zshrc"
# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors` ]]; then
        eval `dircolors ~/git/dotfiles/dircolors.256dark`
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
alias lsd='ll | grep "^d"'
alias dugs='du1 | grep "[0-9]G" | sort -n'
# safety features
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias magit='ec -e "(magit-status \"$(pwd)\")"'

alias freq='cut -f1 -d" " ~/.zsh_history | sort | uniq -c | sort -nr | head -n 30'

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

alias -g L='| less'
alias -g H='| head'
alias -g S='| sort'
alias -g T='| tail'
alias -g N='> /dev/null'
alias -g ERR='2> /dev/null'
alias -g G='| egrep -Hni $1'

alias active='grep -v -e "^$" -e"^ *#"'

alias g='hub'
alias git='hub'
alias ga='git add'
alias gp='git push'
alias gl='git lg'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gbd='git branch -d'
alias gch='git checkout'
alias gc='git commit'
alias gcan='git commit --amend --no-edit'
alias gra='git remote add'
alias grh='git reset HEAD'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'

fin() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}

update-submodules() {
    git stash
    git submodule foreach "git remote update origin -p"
    git submodule foreach "git reset --hard origin/master"
    git commit -am "Update submodule"
    git stash pop
}

ignore() {
    if [ -z "$1" ] ; then
        cat .gitignore
    else
        if git status --porcelain | grep -vE '^[? ]' ; then
            echo "There is staged work, please commit or reset it."
            return 1
        fi

        echo "$1" >> .gitignore
        git add .gitignore
        git commit -m "Ignore $1."
    fi

    return 0
}

sssh (){ ssh -t "$1" 'tmux attach || tmux new || screen -DR'; }

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function mcd() {
    mkdir -p "$1" && cd "$1";
}

eval "$(fasd --init auto)"
eval "$(hub alias -s)"

fpath=(~/.zsh/completion $fpath)

mwiki () { blah=`echo $@ | sed -e 's/ /_/g'`; dig +short txt $blah.wp.dg.cx; }

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

function fgr() {
    find . -iname $1 -exec egrep -Hni $2 '{}' \;
}

function scrots() {
    [ -z $1 ] && return 1
    scrot -s "$HOME/screens/$1.png"
}

# added by travis gem
[ -f /home/expez/.travis/travis.sh ] && source /home/expez/.travis/travis.sh

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/git
[ -f /usr/bin/virtualenvwrapper.sh ] && source /usr/bin/virtualenvwrapper.sh
