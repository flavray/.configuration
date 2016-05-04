-- Load Extensions
local alert = require "hs.alert"
local application = require "hs.application"
local http = require "hs.http"
local notify = require "hs.notify"
local screen = require "hs.screen"
local window = require "hs.window"

local misc = require "misc"
local weather = require "weather"

hs.window.animationDuration = 0

function hs.window.lower(win)
    local frame = win:screen():fullFrame()
    frame.w = frame.w / 2
    frame.h = frame.h / 2
    frame.x = frame.x + frame.w / 2
    frame.y = frame.y + frame.h / 2

    win:setFrame(frame)
end

function hs.window.midlower(win)
    local frame = win:screen():fullFrame()
    frame.w = 3 * frame.w / 4
    frame.h = 3 * frame.h / 4
    frame.x = frame.x + frame.w / 6
    frame.y = frame.y + frame.h / 6

    win:setFrame(frame)
end

function hs.window.left(win)
    local frame = win:screen():fullFrame()
    frame.w = frame.w / 2
    win:setFrame(frame)
end

function hs.window.right(win, index, total)
    index = index or 0
    total = total or 1

    local frame = win:screen():fullFrame()
    frame.w = frame.w / 2
    frame.x = frame.x + frame.w

    frame.h = frame.h / total
    frame.y = frame.h * (index-1)

    win:setFrame(frame)
end

local function setupWindows()
    local screens = {}
    for _, window in ipairs(hs.window.allWindows()) do
        if window:subrole() == "AXStandardWindow" and window:isVisible() then
            local screen_id = window:screen():id()

            if screens[screen_id] == nil then
                screens[screen_id] = {}
            end

            table.insert(screens[screen_id], window)
        end
    end

    for _, windows in pairs(screens) do
        if #windows == 1 then
            windows[1]:maximize()
        elseif #windows > 1 then
            local focused_window = hs.fnutils.indexOf(windows, hs.window.focusedWindow())

            -- Focused window goes first
            if focused_window then
                windows[1], windows[focused_window] = windows[focused_window], windows[1]
            end

            for i, window in pairs(windows) do
                if i == 1 then
                    window:left()
                else
                    window:right(i-1, #windows-1)
                end
            end
        end
    end
end

local function welcome()
    text = {"Hey!"}

    local status, data = weather.get_current()

    -- Wait for location to work
    local retries = 0
    while status == 0 and retries < 15 do
        hs.timer.usleep(2000)
        retries = retries + 1
        status, data = weather.get_current()
    end

    if status == 200 then
        temperature = math.floor(data.currently.temperature)
        icon = weather.icon(data.currently.icon)
        table.insert(text, string.format("Currently, it's %d° outside! %s", temperature, icon))
    end

    text = table.concat(text, "\n")
    alert.show(text, 5)
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", hs.reload)
hs.hotkey.bind({"cmd", "ctrl"}, "A", setupWindows)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", welcome)

hs.hotkey.bind({"cmd", "ctrl"}, "left", function()
    hs.window.focusedWindow():left()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "right", function()
    hs.window.focusedWindow():right()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "up", function()
    hs.window.focusedWindow():maximize()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "down", function()
    hs.window.focusedWindow():lower()
end)

hs.hotkey.bind({"cmd", "ctrl"}, "/", function()
    hs.window.focusedWindow():midlower()
end)

hs.hotkey.bind({"alt", "ctrl"}, "left", function()
    misc.moveSpace(hs.window.focusedWindow(), "left")
end)

hs.hotkey.bind({"alt", "ctrl"}, "right", function()
     misc.moveSpace(hs.window.focusedWindow(), "right")
end)

hs.wifi.watcher.new(misc.ssidChangedCallback):start()
welcome()
