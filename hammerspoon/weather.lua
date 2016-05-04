local weather = {}

-- Most credits to https://github.com/andrewhampton/dotfiles/blob/master/hammerspoon/.hammerspoon/weather.lua

local base_url = "https://api.forecast.io/forecast"
local api_key

local function read_api_key()
    if api_key then return end
    local file = io.open(os.getenv("HOME") .. "/.hammerspoon/weather.api", "r")

    if not file then return end

    api_key = file:read():gsub("\n$", "")
    file:close()
end

function weather.get(latitude, longitude)
    if not api_key then
        return -1, nil
    end

    local url = string.format("%s/%s/%f,%f?units=si", base_url, api_key, latitude, longitude)
    local weather_response = nil

    local status, body, headers = hs.http.get(url, nil)

    if status ~= 200 then
        print("forecast.io: error")
        print("HTTP status code: " .. status)
        print(hs.inspect.inspect(headers))
        print(hs.inspect.inspect(body))
    else
        weather_response = hs.json.decode(body)
    end

    return status, weather_response
end

function weather.get_current()
     hs.location.start()
     local position = hs.location.get()
     hs.location.stop()

     if position == nil then
        return 0, nil
     end

    return weather.get(position.latitude, position.longitude)
end

function weather.icon(iconCode)
   local icon = ''
   if iconCode == 'clear-day' then
      icon = '☀️'
   elseif iconCode == 'clear-night' then
      icon = '☀'
   elseif iconCode == 'rain' then
      icon = '🌧'
   elseif iconCode == 'snow' then
      icon = '🌨'
   elseif iconCode == 'sleet' then
      icon = '🌨'
   elseif iconCode == 'wind' then
      icon = '💨'
   elseif iconCode == 'fog' then
      icon = '(FOG)'
   elseif iconCode == 'cloudy' then
      icon = '☁'
   elseif iconCode == 'partly-cloudy-day' then
      icon = '⛅'
   elseif iconCode == 'partly-cloudy-night' then
      icon = '⛅'
   end

   return icon
end

read_api_key()

return weather

