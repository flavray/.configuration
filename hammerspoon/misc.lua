local misc = {}

-- Most credits to https://github.com/szymonkaliski/Dotfiles/tree/master/Dotfiles/hammerspoon

local spaces = require("hs._asm.undocumented.spaces")

local function activeScreen()
    local active_window = hs.window.focusedWindow()

    if active_window and active_window:role() ~= "AXScrollArea" then
        return active_window:screen()
    else
        local mouse_position = hs.geometry.point(hs.mouse.getAbsolutePosition())
        return hs.fnutils.find(hs.screen.allScreens(), function(screen)
            return mouse_position:inside(screen:frame())
        end)
    end
end

local function focusScreen(screen)
    local frame = screen:frame()
    local mouse_position = hs.mouse.getAbsolutePosition()

    if hs.geometry(mouse_position):inside(frame) then return false end

    local new_mouse_position = {
        x = frame.x + frame.w - 1,
        y = frame.y + frame.h - 1
    }

    hs.mouse.setAbsolutePosition(new_mouse_position)
    hs.timer.usleep(1000)

    return true
end

local function screenSpaces()
    local current_screen = activeScreen()
    return spaces.layout()[current_screen:spacesUUID()]
end

local function activeSpaceId(screen_spaces)
    return hs.fnutils.indexOf(screen_spaces, spaces.activeSpace()) or 1
end

local function spaceInDirection(direction)
    local screen_spaces = screenSpaces()
    local active_id = activeSpaceId(screen_spaces)
    local target_id = direction == "left" and active_id - 1 or active_id + 1

    return screen_spaces[target_id]
end

function misc.moveSpace(win, direction)
    if direction ~= "right" and direction ~= "left" then return end

    local mouse_position = win:zoomButtonRect()
    local old_mouse_position = hs.mouse.getAbsolutePosition()
    local target_space = spaceInDirection(direction)

    mouse_position.x = mouse_position.x + mouse_position.w + 5
    mouse_position.y = mouse_position.y + mouse_position.h / 2

    if win:application():title() == 'Google Chrome' then
        mouse_position.y = mouse_position.y - mouse_position.h
    end

    focusScreen(win:screen())

    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, mouse_position):post()
    hs.timer.usleep(500)

    hs.eventtap.keyStroke({'ctrl'}, direction)

    hs.timer.waitUntil(
        function() return spaces.activeSpace() == target_space end,
        function()
            hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, mouse_position):post()
            hs.mouse.setAbsolutePosition(old_mouse_position)
        end,
        0.1
    )
end

function misc.ssidChangedCallback()
    local ssid = hs.wifi.currentNetwork()
    local network = ssid and "Network: " .. ssid or "Disconnected"

    hs.notify.new({
        title = "Wi-Fi status",
        informativeText = network,
        setIdImage = os.getenv("HOME") .. "/.hammerspoon/assets/wifi.png"
      }):send()
end

return misc
