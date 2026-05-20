-- gen by confToLua.py
-- Source: /home/x12/dotfiles/hypr/.config/hypr/hyprland.conf
-- Some values might need MANUAL check. PLEASE DO BACKUP BEFORE TESTING, PLEASEEEE.

-- Variables
terminal = "foot"
fileManager = "nautilus"
menu = "~/.config/rofi/run.sh norm 1 1"
qs = "quickshell"

hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)

-- exec (on file reload)
hl.exec_cmd(
	"awww img /home/x12/Pictures/sunset-lake-mountain-sky-scenery-digital-art-3k-wallpaper-uhdpaper.com-908@0@i.jpg"
)

-- Requires
require("hyprland.general")
require("hyprland.keybinds")
require("hyprland.monitors")
require("hyprland.env")
require("hyprland.windows")
