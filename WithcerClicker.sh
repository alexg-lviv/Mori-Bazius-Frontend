#!/bin/sh
echo -ne '\033c\033]0;WithcerClicker\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/WithcerClicker.x86_64" "$@"
