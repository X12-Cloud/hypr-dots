-- gen by confToLua.py
-- Source: /home/x12/dotfiles/hypr/.config/hypr/hyprland.conf
-- Some values might need MANUAL check. PLEASE DO BACKUP BEFORE TESTING, PLEASEEEE.

-- Variables
terminal = "foot"
fileManager = "nautilus"
menu_fallback = "~/.config/rofi/run.sh norm 1 1"
menu = "quickshell:open_launcher"
qs = "quickshell"

hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("awww img /home/x12/Pictures/wallpapers/2030-3840x2160-desktop-4k-firewatch-wallpaper-image.jpg")
end)

-- exec (on file reload)
hl.exec_cmd("~/.config/quickshell/Modules/Launcher/generate_apps.sh")

-- Requires
require("hyprland.general")
require("hyprland.keybinds")
require("hyprland.monitors")
require("hyprland.env")
require("hyprland.windows")
