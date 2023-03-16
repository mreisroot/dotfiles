#!/bin/sh

dwmblocks &
unclutter -idle 3 &
xrdb .Xresources
exec dwm
