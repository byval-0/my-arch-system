sync-hyprland:
	@echo "Sync hypland config at ~/.config/hypr/hyprland.conf"
	@cp ~/.config/hypr/hyprland.conf ./dotfiles/.config/hypr/hyprland.conf
	@echo "Sync complete!"

load-hyprland:
	@echo "Load hyprland config to ~/.config/hypr/hyprland.conf"
	@cp ./dotfiles/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
	@echo "Load complete!"
