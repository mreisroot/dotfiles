#!/bin/sh

i3status &
xrdb .Xresources
exec i3
