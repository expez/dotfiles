#-*- shell-script -*-

#Set a cursor
xsetroot -cursor_name left_ptr

#Set keyboard layout: norwegian layout, no dead keys, turn caps lock into another ctrl.
setxkbmap -layout no -variant nodeadkeys -option ctrl:nocaps

#Cut keyboard repeat delay in half.
xset r rate 330 25

#Turn off dpms.
xset dpms 0 0 0

#Turn off screensaver.
xset s 0

#Parse xresources
xrdb ~/.Xresources

Load .xmodmap, if it exists
if [ -f $HOME/.Xmodmap ]; then
    /usr/bin/xmodmap $HOME/.Xmodmap
fi

#Start Xbindkeys
xbindkeys &

# Start urxvt daemon
urxvtd -q -f -o &

# Emacs daemon
emacs --daemon &

# Conkeror daemon
#conkeror --daemon &

# Turn on numlock
numlockx &

# Start window manager
xmonad
