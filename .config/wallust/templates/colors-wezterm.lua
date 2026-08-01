local colors = {
    bg = "{{background | darken(0.7)}}",
    fg = "{{foreground}}",
    cursor = "{{cursor}}",

    transparent_fg = "rgba({{foreground | red}}, {{foreground | green}}, {{foreground | blue}}, 0.2)",

    black = "{{color0}}",
    red = "{{color1}}",
    green = "{{color2}}",
    yellow = "{{color3}}",
    blue = "{{color4}}",
    magenta = "{{color5}}",
    cyan = "{{color6}}",
    white = "{{color7}}",

    b_black = "{{color8}}",
    b_red = "{{color9}}",
    b_green = "{{color10}}",
    b_yellow = "{{color11}}",
    b_blue = "{{color12}}",
    b_magenta = "{{color13}}",
    b_cyan = "{{color14}}",
    b_white = "{{color15}}"
}

return colors
