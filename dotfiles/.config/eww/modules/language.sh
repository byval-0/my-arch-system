#!/bin/sh

setxkbmap -query 2>/dev/null | grep layout | awk '{print $2}'

