local enable = menu.add_checkbox("Watermark", "Enable")
local show_fps = menu.add_checkbox("Watermark", "Show FPS")
local show_time = menu.add_checkbox("Watermark", "Show Time")
local username = menu.add_multi_selection("Watermark", "Username", {"Username", "UID"})
local continuity = menu.add_checkbox("Watermark", "Continuity mode")
local watermark_color = enable:add_color_picker("color")
local font = render.get_default_font()

local function paint()
    if not enable:get() then return end
    local fps = client.get_fps()
    local screen = render.get_screen_size()
    local hour, minute, second = client.get_local_time()
    local base_text, separator = "primordial", " | "
    local total_width, base_width = render.get_text_size(font, base_text).x, render.get_text_size(font, base_text).x
    
    if username:get(1) then total_width = total_width + render.get_text_size(font, user.name).x + render.get_text_size(font, separator).x end
    if username:get(2) then total_width = total_width + render.get_text_size(font, tostring(user.uid)).x + render.get_text_size(font, separator).x end
    if show_time:get() then total_width = total_width + render.get_text_size(font, string.format("%02d:%02d:%02d", hour, minute, second)).x + render.get_text_size(font, separator).x end
    if show_fps:get() then total_width = total_width + render.get_text_size(font, "FPS: " .. fps).x + render.get_text_size(font, separator).x end
    
    local x, y = 10, 5
    local text_height = render.get_text_size(font, base_text).y
    
    if continuity:get() then
        local outline_top_left = vec2_t(x - 6, y - 1)
        local outline_bottom_right = vec2_t(x + total_width + 2, y + text_height + 14)

        render.rect_filled(outline_top_left, outline_bottom_right, color_t(0, 0, 0, 255), 5)

        render.rect_filled(
           vec2_t(outline_top_left.x + 1, outline_top_left.y + 1),
           vec2_t(outline_bottom_right.x - 2, outline_bottom_right.y - 2),
            color_t(36, 36, 36, 255), 
           5
        )
    end

    local top_left = vec2_t(x - 5, y)
    local bottom_right = vec2_t(x + total_width, y + text_height)

    render.rect_filled(vec2_t(top_left.x - 1, top_left.y - 1), vec2_t(bottom_right.x + 2, bottom_right.y + 1), color_t(0, 0, 0, 255), 5)
    render.rect_filled(vec2_t(top_left.x - 1, top_left.y + 5), vec2_t(bottom_right.x + 2, bottom_right.y - 5), color_t(0, 0, 0, 255), 0)
    render.rect_filled(top_left, bottom_right, color_t(44, 44, 44, 255), 5)
    render.rect_filled(vec2_t(top_left.x, top_left.y + 5), vec2_t(bottom_right.x, bottom_right.y - 5), color_t(44, 44, 44, 255), 0)
    
    local current_x = x
    render.text(font, base_text, vec2_t(current_x, y), color_t(204, 204, 204))
    current_x = current_x + base_width
    
    if username:get(1) then
        render.text(font, separator .. user.name, vec2_t(current_x, y), color_t(204, 204, 204))
        current_x = current_x + render.get_text_size(font, user.name).x + render.get_text_size(font, separator).x
    end
    
    if username:get(2) then
        render.text(font, " (" .. tostring(user.uid) .. ")", vec2_t(current_x, y), color_t(204, 204, 204))
        current_x = current_x + render.get_text_size(font, tostring(user.uid)).x + render.get_text_size(font, separator).x
    end
    
    if show_time:get() then
        render.text(font, separator .. string.format("%02d:%02d:%02d", hour, minute, second), vec2_t(current_x, y), color_t(204, 204, 204))
        current_x = current_x + render.get_text_size(font, string.format("%02d:%02d:%02d", hour, minute, second)).x + render.get_text_size(font, separator).x
    end
    
    if show_fps:get() then
        render.text(font, separator .. "FPS: " .. fps, vec2_t(current_x, y), color_t(204, 204, 204))
    end
    
    render.line(vec2_t(x - 5, bottom_right.y + 4), vec2_t(x + total_width + 4, bottom_right.y + 4), watermark_color:get())
end

callbacks.add(e_callbacks.PAINT, paint)