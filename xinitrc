#-*- shell-script -*-

xsetroot -cursor_name left_ptr

setxkbmap -layout "us,no" -option ctrl:nocaps

xset -dpms s noblank s off m 0 0 r rate 330 20
xset -b

xrdb ~/.Xresources

if [ -f $HOME/.Xmodmap ]; then
    /usr/bin/xmodmap $HOME/.Xmodmap
fi

xbindkeys &

urxvtd -q -f -o &

emacs --daemon &

numlockx &

if command -v  extMonitor >/dev/null 2>&1; then
    extMonitor
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xmonad
