-- Ghostty: auto-adjust font size based on which monitor the window is on
-- Built-in display: font-size = 10.0 | External display: font-size = 14.0
--
-- The size goes in a file of its own that the Ghostty config includes, so the
-- config itself stays as chezmoi wrote it.

local ghosttyFontSizePath = os.getenv("HOME") .. "/.config/ghostty/font-size"
local ghosttyCurrentScreenID = nil
local debounceTimer = nil

local function ghosttySetFontSize(size)
  local content = "font-size = " .. size .. "\n"

  local f = io.open(ghosttyFontSizePath, "r")
  if f then
    local current = f:read("*a")
    f:close()
    if current == content then return end
  end

  local fw = io.open(ghosttyFontSizePath, "w")
  if not fw then return end
  fw:write(content)
  fw:close()

  hs.timer.doAfter(0.05, function()
    local app = hs.application.find("com.mitchellh.ghostty")
    if app then
      hs.eventtap.keyStroke({ "cmd", "shift" }, ",", 0, app)
    end
  end)
end

local ghosttyWF = hs.window.filter.new("Ghostty")
ghosttyWF:subscribe(hs.window.filter.windowMoved, function(win)
  if not win then return end

  if debounceTimer then debounceTimer:stop() end
  debounceTimer = hs.timer.doAfter(0.2, function()
    local screen = win:screen()
    if not screen then return end

    local screenID = screen:id()
    if screenID == ghosttyCurrentScreenID then return end
    ghosttyCurrentScreenID = screenID

    -- macOS names the laptop's own screen "Built-in ... Display".
    if (screen:name() or ""):match("^Built%-in") then
      ghosttySetFontSize("10.0")
    else
      ghosttySetFontSize("14.0")
    end
  end)
end)
