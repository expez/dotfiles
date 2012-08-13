#-*- shell-script -*-
# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

TERM='rxvt-unicode'
COLORTERM='rxvt-unicode-256color'
LANG='en_US.UTF-8'

# from http://skinwalker.wordpress.com/2012/01/24/stderr-zsh/ adds red std err.
exec 2>>( while read X; do print "\e[91m${X}\e[0m" > /dev/tty; done & )

source ~/git/dotfiles/antigen/antigen.zsh

# Load the oh-my-zsh's library.
# antigen-lib

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen-bundle battery
antigen-bundle extract
antigen-bundle git
antigen-bundle dircycle

# # Syntax highlighting bundle.
antigen-bundle zsh-users/zsh-syntax-highlighting

# #additional completions
antigen-bundle zsh-users/zsh-completions

# #history substring search
antigen-bundle zsh-users/zsh-history-substring-search

# # Tell antigen that you're done.
antigen-apply

source ~/git/dotfiles/zsh-git-prompt/zshrc.sh
PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~%b%{$reset_color%}$(git_super_status)
$ '

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl:/home/expez/bin

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#enable completions
autoload -U compinit
compinit -i

setopt completealiases

#zstyle ':completion:*' menu select

# FAQ 3.10: Why does zsh not work in an Emacs shell mode any more?
# http://zsh.sourceforge.net/FAQ/zshfaq03.html#l26
[[ $EMACS = t ]] && unsetopt zle

# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd..:.."
export HISTSIZE=50000
export HISTFILE=~/.zsh_history
export SAVEHIST=30000
setopt INC_APPEND_HISTORY
#setopt HIST_IGNORE_ALL_DUPS # Leaving this off so I can use the history to determine new aliases to create.
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Zsh spelling correction options
setopt CORRECT

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

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
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1 | sort -n'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias psg='ps -Af | grep $1' # requires an argument
alias wc='weechat-curses'
alias 'vnice=nice -n 20 ionice -c 3'

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
alias pacm="makepkg -fci"                            # '[m]ake'           - make package from PKGBUILD file in current directory

# edit file as root using emacs.
alias E="SUDO_EDITOR=\"emacsclient -c -a emacs\" sudoedit"
alias T="SUDO_EDITOR=\"emacsclient -t -a emacs\" sudoedit"

alias src="source ~/.zshrc"
alias xevg="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias blkidc="sudo blkid -c /dev/null"
alias ssh='eval $(/usr/bin/keychain --eval --agents ssh -Q --quiet .ssh/id_rsa) && ssh'

# Global aliases (expand whatever their position)
#  e.g. find . E L
alias -g L='| less'
alias -g H='| head'
alias -g S='| sort'
alias -g T='| tail'
alias -g N='> /dev/null'
alias -g E='2> /dev/null'


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
