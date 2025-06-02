current=$(hyprctl activeworkspace -j | jq '.id')
max=10

if [ "$current" -lt "$max" ]; then
    next=$((current + 1))
    hyprctl dispatch workspace "$next"
fi
