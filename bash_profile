#
# ~/.bash_profile
#

export PATH=$PATH:~/bin
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

[[ -f ~/.bashrc ]] && . ~/.bashrc

#Use keychain to manage SSH.
eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	exec startx
	#Could use xinit instead of startx
	#exec xinit -- /usr/bin/X -nolisten tcp vt7
fi
