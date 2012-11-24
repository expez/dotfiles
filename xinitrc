#-*- shell-script -*-

xsetroot -cursor_name left_ptr

#setxkbmap -layout no -variant nodeadkeys -option ctrl:nocaps
setxkbmap -layout "us" -option ctrl:nocaps

xset r rate 330 25

# Apparently the order of these two matters.
xset s off
xset -dpms

xrdb ~/.Xresources

if [ -f $HOME/.Xmodmap ]; then
    /usr/bin/xmodmap $HOME/.Xmodmap
fi

xbindkeys &

urxvtd -q -f -o &

emacs --daemon &

#conkeror --daemon &

numlockx &

xmonad
