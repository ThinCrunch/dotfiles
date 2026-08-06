-- HYPRLAND CONFIG
-- https://wiki.hypr.land/Configuring/
-- vim:fileencoding=utf-8:foldmethod=marker

local colors = require("~/.config/hypr/colors.lua")

-- Monitors {{{

-- See https://wiki.hyprland.org/Configuring/Monitors/

hl.monitor({ output = "eDP-1", mode = "1920x1080@75", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@75", position = "1920x0", scale = 1, vrr = 1 })

-- Useful configurations
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "", mode = "highres@highrr", position = "auto", scale = 1, mirror = "eDP-1" })

-- }}}

-- Environmental Variables {{{

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "elementary")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "elementary")

hl.env("MESA_VK_WSI_PRESENT_MODE", "immediate")
hl.env("SDL_VIDEODRIVER", "wayland")

hl.env("AQ_DRM_DEVICES", "/dev/dri/card2")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("NVD_BACKEND", "direct")

hl.env("QS_ICON_THEME", "kora")

-- }}}

-- Variables {{{

local EDPI = 280
local DPI = 800

hl.config({
    input = {
        kb_layout = "us, us",
        kb_variant = ", intl",
        kb_options = "grp:alt_shift_toggle",
        float_switch_override_focus = false,

        touchpad = {
            natural_scroll = false,
        },

        -- clamped: [-1.0; 1.0], 0 means no modification.

        -- calculating libinput accel speed from a multiplier:
        -- normal_multiplier = <libinput_sens> + 1 = eDPI / DPI
        -- libinput_sens = (eDPI / DPI) - 1
        sensitivity = (EDPI / DPI) - 1,

        accel_profile = "flat",
    },
})

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = colors.color12,
            inactive_border = colors.bg_t,
            nogroup_border_active = colors.color12,  -- scratchpads
            nogroup_border = colors.bg_t,            -- scratchpads
        },
        layout = "dwindle",

        allow_tearing = true,
        resize_on_border = false,
    },
})

hl.config({
    decoration = {
        rounding = 5,

        blur = {
            enabled = true,
            popups = true,
            size = 3,
            passes = 3
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        }
    },
})

hl.config({
    animations = {
        enabled = true,
    }
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- For curves: https://easings.net/
hl.curve("easeOutQuint", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })

hl.animation({ leaf = "windows",          enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 3, bezier = "easeOutQuint", style = "popin 80%" })
hl.animation({ leaf = "border",           enabled = true, speed = 6, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle",      enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 5, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 5, bezier = "easeOutQuint", style = "slide" })

-- disabled fadeOut animation to avoid scratchpad animation from bugging out
hl.animation({ leaf = "fadeOut",          enabled = false, speed = 3, bezier = "easeOutQuint" })

hl.config({
    dwindle = {
        -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
        preserve_split = true,  -- you probably want this
    }
})

hl.device({
    name = "elan1201:00-04f3:3098-touchpad",
    sensitivity = 0,
})

hl.config({
    cursor = {
        no_hardware_cursors = true,
        enable_hyprcursor = true,
    }
})

hl.config({
    render = {
        direct_scanout = false,
    }
})

hl.config({
    misc = {
        force_default_wallpaper = false,
    }
})

-- }}}

-- Keybinds {{{

-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/
local mainMod = "SUPER"

-- Move focus and windows
local bind_to_direction = {["H"] = "left", ["L"] = "right", ["K"] = "up", ["J"] = "down"}

for key,direction in pairs(bind_to_direction) do
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Switch workspaces, move window to workspace
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Window handling
hl.bind(mainMod .. " + SHIFT + Q",     hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",             hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen({ action = "toggle" }))

-- Basic SW binds
local dmenu_cmd = 'rofi -show drun -show-icons -modes "drun,w:~/Bash/rofi-walls.sh,p:~/Bash/rofi-power.sh"'
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(dmenu_cmd))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + SHIFT + SEMICOLON", hl.dsp.exec_cmd("hyprlock"))

-- Quit
hl.bind(mainMod .. " + M", hl.dsp.exit())

-- Media player control
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("playerctl next"))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Power modes
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("powerprofilesctl set balanced"))
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("powerprofilesctl set power-saver"))

-- Screenshots
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("slurp | grim -g - - | wl-copy"))

-- Paste image from clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("~/Bash/clipdrop.sh"))

-- Laptop keyboard functionality
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("asusctl leds set next"))
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("asusctl leds set prev"))

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pamixer --increase 5"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("pamixer --decrease 5"))
hl.bind("XF86AudioMute",   hl.dsp.exec_cmd("pamixer --toggle-mute"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"))

-- Scratchpads
hl.bind(mainMod .. " + SEMICOLON", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(mainMod .. " + O",         hl.dsp.exec_cmd("pypr toggle files"))

-- }}}

-- Workspace Rules {{{

for i = 1,5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

for i = 6,7 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

-- }}}

-- Autostart {{{

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function () 
    -- Daemons
    hl.exec_cmd("/usr/lib/mate-polkit/polkit-mate-authentication-agent-1")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("dunst")
    hl.exec_cmd("pypr")
    hl.exec_cmd("wl-clip-persist --clipboard regular")

    -- Programs
    hl.exec_cmd("waybar")

    -- Applets
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("gammastep-indicator")
    hl.exec_cmd("sleep 2 && firewall-applet")
    hl.exec_cmd("sleep 2 && openrgb --startminimized --profile default")

    -- Actions
    hl.exec_cmd("sleep 2 && ~/Bash/notify-updates.sh")
    hl.exec_cmd("asusctl -c 80")
    hl.exec_cmd("setcursor elementary 24")
end)

-- }}}

-- Layer rules {{{

hl.layer_rule({ match = { namespace = ".*" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "rofi" }, blur = true })

hl.layer_rule({ match = { namespace = "waybar" },
                blur = true,
                ignore_alpha = 0.1 })

hl.layer_rule({ match = { namespace = "quickshell" },
                blur = true,
                blur_popups = true,
                ignore_alpha = 0.1 })

hl.layer_rule({ match = { namespace = "notifications" },
                blur = true,
                ignore_alpha = 0.1,
                animation = "slide" })

-- }}}

-- Window Rules {{{

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { focus = "false" }, no_shadow = true })

local floaters = { "blobdrop", "AppImageLauncher", "Windscribe" }
for _ ,class_ in ipairs(floaters) do
    hl.window_rule({ match = { class = class_ }, float = true })
end

hl.window_rule({ match = { class = "^(steam)$" }, tile = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(notificationtoasts.*|)$" },
                 rounding = true,
                 float = true })

-- }}}
