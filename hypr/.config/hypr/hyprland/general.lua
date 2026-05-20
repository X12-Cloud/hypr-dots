-- gen by confToLua.py
-- Source: /home/x12/dotfiles/hypr/.config/hypr/hyprland/general.conf
-- Some values might need MANUAL check. PLEASE DO BACKUP BEFORE TESTING, PLEASEEEE.

-- Gesture
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- General Config
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(aaaaaaff)", "rgba(666666ff)" }, angle = 45 },
			inactive_border = "rgba(555555aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			vibrancy = 0.1696,
		},
		rounding = 10,
		rounding_power = 2,
		active_opacity = 0.95,
		inactive_opacity = 0.85,
	},
	animations = {
		enabled = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
	input = {
		touchpad = {
			natural_scroll = false,
		},
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
	},
	device = {
		-- name = "epic-mouse-v1",
		-- sensitivity = -0.5,
	},
})

hl.curve("easeSoft", { type = "bezier", points = { { 0.25, 1.00 }, { 0.30, 1.00 } } })
hl.curve("easeSmooth", { type = "bezier", points = { { 0.42, 0.00 }, { 0.58, 1.00 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 7, bezier = "easeSmooth" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "easeSmooth" })

hl.animation({ leaf = "windows", enabled = true, speed = 3.8, bezier = "easeSoft" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "easeSoft", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "easeSmooth", style = "slide" })

hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.6, bezier = "easeSmooth" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.4, bezier = "easeSmooth" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.6, bezier = "easeSmooth" })

hl.animation({ leaf = "layers", enabled = true, speed = 2.8, bezier = "easeSmooth" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.0, bezier = "easeSmooth", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.7, bezier = "easeSmooth", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "easeSmooth" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.3, bezier = "easeSmooth" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 1.8, bezier = "easeSmooth", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.25, bezier = "easeSmooth", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.8, bezier = "easeSmooth", style = "slide" })

hl.animation({ leaf = "zoomFactor", enabled = true, speed = 5.5, bezier = "easeSoft" })
