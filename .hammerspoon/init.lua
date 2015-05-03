-- Setup environment
hs.window.animationDuration = 0

-- Modifier shortcuts
local alt = {"⌥"}
local hyper = {"⌘", "⌥", "⌃", "⇧"}
local nudgekey = {"⌥", "⌃"}
local yankkey = {"⌥", "⌃","⇧"}
local pushkey = {"⌃", "⌘"}

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

-- Push to screen edge
hs.hotkey.bind(pushkey,"left", function() push(0,0,0.5,1) end) 		-- left side
hs.hotkey.bind(pushkey,"right", function() push(0.5,0,0.5,1) end)	-- right side
hs.hotkey.bind(pushkey,"up", function()	push(0,0,1,0.5) end) 		-- top half
hs.hotkey.bind(pushkey,"down", function()	push(0,0.5,1,0.5) end)	-- bottom half

-- Move to middle of screen
hs.hotkey.bind(pushkey, "m", function() push(0.05,0.05,0.9,0.9) end)

-- Fullscreen
hs.hotkey.bind(pushkey, "f", function() push(0,0,1,1) end)

-- Chat windows (arrange in grid of 4 on right hand of screen)
hs.hotkey.bind(hyper, "1", function() push(0.7,0,0.3,0.25) end)
hs.hotkey.bind(hyper, "2", function() push(0.7,0.25,0.3,0.25) end)
hs.hotkey.bind(hyper, "3", function() push(0.7,0.5,0.3,0.25) end)
hs.hotkey.bind(hyper, "4", function() push(0.7,0.75,0.3,0.25) end)

--config reloading. manual:
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
  hs.alert.show("Config loaded")
end)


--and magic:
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- Replace Caffeine.app with 18 lines of Lua :D
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    local result
    if state then
        result = caffeine:setIcon("caffeine-on.pdf")
    else
        result = caffeine:setIcon("caffeine-off.pdf")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end