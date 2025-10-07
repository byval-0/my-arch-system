workspaces=$(hyprctl workspaces -j | jq -r '.[] | "\(.id):\(.name)"')
focused=$(hyprctl activeworkspace -j | jq -r '.id')

buf=""

for ws in $workspaces; do
    id="${ws%%:*}"
    name="${ws#*:}"

    if [ "$id" -eq "$focused" ]; then
        icon=""
        class="focused"
    else
        icon=""
        class="empty"
    fi

    buf="$buf (eventbox :cursor \"hand\" (button :class \"$class\" :onclick \"hyprctl dispatch workspace $id\" \"$icon\"))"
done

echo "(box :class \"workspaces\" :halign \"center\" :valign \"center\" :vexpand true :hexpand true $buf)"

