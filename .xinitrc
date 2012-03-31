export GTK_IM_MODULE='ibus'
export XMODIFIERS=@im='ibus'
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
ibus-daemon -d -x
xmodmap .xmodmap
exec $HOME/.packages/bin/stumpwm
