#!/bin/bash
WINEPREFIX="$HOME/PhotoshopCC" wine "$HOME/PhotoshopCC/Photoshop-CC/Photoshop.exe" "$(winepath -w "$1")" </dev/null >/dev/null 2>&1