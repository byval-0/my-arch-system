sync-hyprland:
	@echo "Sync hypland config at ~/.config/hypr/hyprland.conf"
	@cp ~/.config/hypr/hyprland.conf ./dotfiles/.config/hypr/hyprland.conf
	@echo "Sync complete!"

load-hyprland:
	@echo "Load hyprland config to ~/.config/hypr/hyprland.conf"
	@cp ./dotfiles/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
	@echo "Load complete!"

link-hyprland:
	@mkdir -p ~/.config/hypr
	@if [ -f "$$HOME/.config/hypr/hyprland.conf" ]; then \
		echo "Backing up existing hypr/hyprland.conf..."; \
		mv $$HOME/.config/hypr/hyprland.conf $$HOME/.config/hypr/hyprland_backup.conf; \
	fi
	@echo "Creating symlink for hyprland config ~/.config/hypr/hyprland.conf."
	@ln ./dotfiles/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
