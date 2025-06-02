current=$(hyprctl activeworkspace -j | jq '.id')

if [ "$current" -gt 1 ]; then
  hyprctl dispatch workspace e-1
fi
