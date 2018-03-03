-- -----------------
-- Setup environment
-- -----------------

-- Spoons
-- Config reloading automatically
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Replacing Caffeine with spoon.
hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

-- None of this animation shit:
hs.window.animationDuration = 0

-- Modifier shortcuts
local alt = {"⌥"}
local hyper = {"⌘", "⌥", "⌃", "⇧"}
local nudgekey = {"⌥", "⌃"}
local yankkey = {"⌥", "⌃","⇧"}
local pushkey = {"⌃", "⌘"}
local shiftpushkey= {"⌃", "⌘", "⇧"}

-- --------------------------------------------------------
-- Helper functions - these do all the heavy lifting below.
-- Names are roughly stolen from same functions in Slate :)
-- --------------------------------------------------------

-- Move a window a number of pixels in x and y
function nudge(xpos, ypos)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	f.x = f.x + xpos
	f.y = f.y + ypos
	win:setFrame(f)
end

-- Resize a window by moving the bottom
function yank(xpixels,ypixels)
	local win = hs.window.focusedWindow()
	local f = win:frame()

	f.w = f.w + xpixels
	f.h = f.h + ypixels
	win:setFrame(f)
end

-- Resize window for chunk of screen.
-- For x and y: use 0 to expand fully in that dimension, 0.5 to expand halfway
-- For w and h: use 1 for full, 0.5 for half
function push(x, y, w, h)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w*x)
	f.y = max.y + (max.h*y)
	f.w = max.w*w
	f.h = max.h*h
	win:setFrame(f)
end

-- -----------------
-- Screen Management
-- -----------------
local workLeftDisplay = 724062416
local workRightDisplay = 724063183
local laptopDisplay = 69731906

-- -----------------
-- Window management
-- -----------------

-- Movement hotkeys
hs.hotkey.bind(nudgekey, 'down', function() nudge(0,100) end) 	--down
hs.hotkey.bind(nudgekey, "up", function() nudge(0,-100) end)	--up
hs.hotkey.bind(nudgekey, "right", function() nudge(100,0) end)	--right
hs.hotkey.bind(nudgekey, "left", function() nudge(-100,0) end)	--left

-- Resize hotkeys
hs.hotkey.bind(yankkey, "up", function() yank(0,-100) end) -- yank bottom up
hs.hotkey.bind(yankkey, "down", function() yank(0,100) end) -- yank bottom down
hs.hotkey.bind(yankkey, "right", function() yank(100,0) end) -- yank right side right
hs.hotkey.bind(yankkey, "left", function() yank(-100,0) end) -- yank right side left

-- Push to screen edge using miro's window manager:
hs.loadSpoon("MiroWindowsManager")
spoon.MiroWindowsManager:bindHotkeys({
  up = {pushkey, "up"},
  right = {pushkey, "right"},
  down = {pushkey, "down"},
  left = {pushkey, "left"},
  fullscreen = {pushkey, "f"}
})

-- Center window with some room to see the desktop
hs.hotkey.bind(pushkey, "m", function() push(0.05,0.05,0.9,0.9) end)

-- Put Messages.app where I like it
hs.hotkey.bind(pushkey, "1", function() push(0.02,0.02,0.4,0.5) end)

-- Move a window between monitors
hs.hotkey.bind(shiftpushkey, "left", function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(shiftpushkey, "right", function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind(shiftpushkey, "down", function() hs.window.focusedWindow():moveOneScreenSouth() end)
hs.hotkey.bind(shiftpushkey, "up", function() hs.window.focusedWindow():moveOneScreenNorth() end)


-- Application shortcuts
hs.hotkey.bind(hyper, "C", function() hs.application.launchOrFocus("Google Chrome") end)
hs.hotkey.bind(hyper, "P", function() hs.application.launchOrFocus("Papers") end)
hs.hotkey.bind(hyper, "E", function() hs.application.launchOrFocus("Evernote") end)
hs.hotkey.bind(hyper, "X", function() hs.application.launchOrFocus("Microsoft Excel") end)
hs.hotkey.bind(hyper, "S", function() hs.application.launchOrFocus("Spotify") end)
hs.hotkey.bind(hyper, "M", function() hs.application.launchOrFocus("Messages") end)
