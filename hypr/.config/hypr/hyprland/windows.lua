-- gen by confToLua.py
-- Source: /home/x12/dotfiles/hypr/.config/hypr/hyprland/windows.conf
-- Some values might need MANUAL check. PLEASE DO BACKUP BEFORE TESTING, PLEASEEEE.

-- Foot
hl.window_rule({
	match = { class = "^(foot)$" },
	opacity = "0.85 override 0.80 override",
	-- blur = true,
})

-- Nautilus
hl.window_rule({
	match = { class = "^(nautilus)$" },
	opacity = "0.85 override 0.80 override",
	-- blur = true,
})

-- Spotify
hl.window_rule({
	match = { class = "^(spotify)$" },
	opacity = "0.80 override 0.75 override",
})

-- Discord
hl.window_rule({
	match = { class = "^(discord)$" },
	opacity = "0.80 override 0.75 override",
})

-- Satty for screenshots
hl.window_rule({
	match = { class = "^(com.gabm.satty)$" },
	float = true,
	size = "900 600",
	center = true,
	pin = true,
})
