#Set a cursor
xsetroot -cursor_name left_ptr

#Set keyboard layout: norwegian layout, no dead keys, turn caps lock into another ctrl.
setxkbmap -layout no -variant nodeadkeys -option ctrl:nocaps

#Set cut keyboard repeat delay in half.
xset r rate 330 25

#Parse xresources
xrdb ~/.Xresources

#Rebind the menu button to Hyper_L to use as xbindkeys modifier.
xmodmap -e 'keycode 135=Hyper_L'

# Start urxvt daemon
urxvtd -q -f -o &

# Emacs daemon
emacs --daemon &

# Conkeror daemon
conkeror --daemon &

# Turn on numlock
numlockx &

# Start window manager
xmonad
