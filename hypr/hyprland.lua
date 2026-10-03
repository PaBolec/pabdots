-- paul's minimal hyprland config (Lua, Hyprland 0.55+)
-- Old hyprlang .conf syntax is deprecated as of 0.55 — this replaces it.
-- Dispatcher names (hl.dsp.*) follow the same names as the old dispatcher
-- keywords (wiki.hypr.land/Configuring/Dispatchers) — if any call here
-- errors on your version, check that page for the current name.

local mainMod = "SUPER"

-- ---- autostart ----
hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -i ~/Pictures/wallpapers/wallpaper.jpg -m fill")
    hl.exec_cmd("dunst")
    hl.exec_cmd("waybar")
end)

-- ---- general / decoration / animations — flat, no gaps, no blur ----
hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        col_active_border = 0xff888888,
        col_inactive_border = 0xff333333,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },
    animations = {
        enabled = false,
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- ---- keybinds ----
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty -e ranger"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + Q", hl.dsp.killactive())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.togglefloating())
hl.bind(mainMod .. " + F", hl.dsp.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.togglesplit())

-- focus movement
hl.bind(mainMod .. " + Left", hl.dsp.movefocus("l"))
hl.bind(mainMod .. " + Right", hl.dsp.movefocus("r"))
hl.bind(mainMod .. " + Up", hl.dsp.movefocus("u"))
hl.bind(mainMod .. " + Down", hl.dsp.movefocus("d"))

-- workspaces 1-9, move window to workspace 1-9
for i = 1, 9 do
    local ws = tostring(i)
    hl.bind(mainMod .. " + " .. ws, hl.dsp.workspace(ws))
    hl.bind(mainMod .. " + SHIFT + " .. ws, hl.dsp.movetoworkspace(ws))
end

-- mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.movewindow())
hl.bind(mainMod .. " + mouse:273", hl.dsp.resizewindow())
