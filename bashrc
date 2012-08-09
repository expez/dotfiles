#-*- shell-script -*-
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
#PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\]'

TERM='rxvt-unicode'
COLORTERM='rxvt-unicode-256color'
LANG='en_US.UTF-8'

#Don't treat ! as a special character
set +H

 ##################################################
 # Fancy PWD display function
 ##################################################
 # The home directory (HOME) is replaced with a ~
 # The last pwdmaxlen characters of the PWD are displayed
 # Leading partial directory names are striped off
 # /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

if [ `/usr/bin/whoami` = "root" ] ; then
  # root has a red prompt
  export PS1="\[\033[1;31m\]\u@\h \w \$ \[\033[0m\]"
elif [ `hostname` = "puyo" -o `hostname` = "enigma" -o `hostname` = "Biffel" ] ; then
  # the hosts I use on a daily basis have blue
  export PS1="\[\033[1;36m\]\u@\h \w \$ \[\033[0m\]"
elif [ `hostname` == domU* -o `hostname` = "lucid" -o `hostname` = "vagrant" ]; then
  # green on VMs (EC2, vbox, etc)
  export PS1="\[\033[1;32m\]\u@\h \w \$ \[\033[0m\]"
else
  # purple for unknown hosts
  export PS1="\[\033[1;35m\]\u@\h \w \$ \[\033[0m\]"
fi

#Add completions
complete -cf sudo
complete -cf man

# modified commands
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'

# new commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias psg='ps -Af | grep $1' # requires an argument
alias wc='weechat-curses'
# ls
alias ls='ls -hF --color=auto'
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

alias ald="echo \"echo 'alias name=\"command\"' >> ~/.bashrc && . ~/.bashrc\""

# pacman aliases (if applicable, replace 'pacman' with 'yaourt'/'pacaur'/whatever)
alias pac="sudo pacman -S"      # default action     - install one or more packages
alias pacu="sudo pacman -Syu"   # '[u]pdate'         - upgrade all packages to their newest version
alias pacul="pacman -Qu"        #List packages with updates available
alias pacli="pacman -Q"          #[Li]st all installed packages.
alias pacg="sudo pacman -Syu"   # 'up[g]rade'         - upgrade a package or install one created by makepg
alias pacs="pacman -Ss"    # '[s]earch'         - search for a package using one or more keywords
alias paci="pacman -Si"    # '[i]nfo'           - show information about a package
alias pacr="sudo pacman -R"     # '[r]emove'         - uninstall one or more packages
alias pacl="pacman -Sl"    # 'repository [l]ist'           - list all packages of a repository
alias pacll="pacman -Qqm"  # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
alias paclo="pacman -Qdt"  # '[l]ist [o]rphans' - list all packages which are orphaned
alias paco="pacman -Qo"    # '[o]wner'          - determine which package owns a given file
alias pacf="pacman -Ql"    # '[f]iles'          - list all files installed by a given package
alias pacc="sudo pacman -Sc"    # '[c]lean cache'    - delete all not currently installed package files
alias pacm="makepkg -fci"  # '[m]ake'           - make package from PKGBUILD file in current directory

# edit file as root using emacs.
alias E="SUDO_EDITOR=\"emacsclient -c -a emacs\" sudoedit"
alias T="SUDO_EDITOR=\"emacsclient -t -a emacs\" sudoedit"

alias src="source ~/.bashrc"

alias xevg="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

alias blkidc="sudo blkid -c /dev/null"

function update-submodules {
  git stash
  git submodule foreach "git remote update origin -p"
  git submodule foreach "git reset --hard origin/master"
  git commit -am "bump submodule"
  git stash pop
}

function ignore {
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
