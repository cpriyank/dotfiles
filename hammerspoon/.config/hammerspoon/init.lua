-- ============================================================
-- init.lua (known-good)
-- - Focus follows mouse (FFM)
-- - RecursiveBinder leader on Option+Space
-- - Window hints + tiling under: Option+Space → w → ...
-- ============================================================

-- ===== Focus Follows Mouse (FFM) =====
local function windowUnderMouse()
	local pos = hs.mouse.absolutePosition()
	local screen = hs.mouse.getCurrentScreen()

	for _, win in ipairs(hs.window.orderedWindows()) do
		if win and win:isStandard() and win:screen() == screen and (not win:isFullScreen()) then
			local f = win:frame()
			if pos.x >= f.x and pos.x < (f.x + f.w) and pos.y >= f.y and pos.y < (f.y + f.h) then
				return win
			end
		end
	end

	return nil
end

local lastFocusedId = nil

hs.eventtap
	.new({ hs.eventtap.event.types.mouseMoved }, function(_)
		-- Don't change focus while dragging/selecting
		local buttons = hs.eventtap.checkMouseButtons()
		if buttons.left or buttons.right or buttons.middle then
			return false
		end

		local win = windowUnderMouse()
		if not win then
			return false
		end

		local id = win:id()
		if id and id ~= lastFocusedId then
			lastFocusedId = id

			local focused = hs.window.focusedWindow()
			if (not focused) or focused:id() ~= id then
				win:focus()
			end
		end

		return false
	end)
	:start()

-- ===== RecursiveBinder =====
hs.loadSpoon("RecursiveBinder")
spoon.RecursiveBinder.escapeKey = { {}, "escape" }
spoon.RecursiveBinder.showBindHelper = true

local singleKey = spoon.RecursiveBinder.singleKey

-- ===== Window helpers =====
local function withFocused(fn)
	return function()
		local win = hs.window.focusedWindow()
		if not win then
			hs.alert.show("No focused window")
			return
		end
		fn(win)
	end
end

local function toUnit(unit)
	return withFocused(function(win)
		win:moveToUnit(unit)
	end)
end

-- ===== Key map =====
local keyMap = {
	-- App launchers
	[singleKey("b", "browser")] = function()
		hs.application.launchOrFocus("Safari")
	end,
	[singleKey("f", "firefox")] = function()
		hs.application.launchOrFocus("Firefox")
	end,
	[singleKey("t", "terminal")] = function()
		hs.application.launchOrFocus("Kitty")
	end,
	[singleKey("c", "chat")] = function()
		hs.application.launchOrFocus("Slack")
	end,
	[singleKey("q", "docs")] = function()
		hs.application.launchOrFocus("Notion")
	end,
	[singleKey("e", "editor")] = function()
		hs.application.launchOrFocus("Emacs")
	end,

	-- Windows: hints + tiling
	[singleKey("w", "windows+")] = {
		-- Window hints ("AceJump for windows")
		[singleKey("h", "hints")] = function()
			hs.hints.windowHints()
		end,

		-- Tiling (focused window)
		[singleKey("a", "left 50%")] = toUnit(hs.layout.left50),
		[singleKey("d", "right 50%")] = toUnit(hs.layout.right50),
		[singleKey("s", "maximize")] = toUnit(hs.layout.maximized),

		-- Quarters
		[singleKey("q", "top-left")] = toUnit({ x = 0, y = 0, w = 0.5, h = 0.5 }),
		[singleKey("e", "top-right")] = toUnit({ x = 0.5, y = 0, w = 0.5, h = 0.5 }),
		[singleKey("z", "bot-left")] = toUnit({ x = 0, y = 0.5, w = 0.5, h = 0.5 }),
		[singleKey("c", "bot-right")] = toUnit({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 }),
	},

	-- URLs
	[singleKey("d", "domain+")] = {
		[singleKey("g", "github")] = function()
			hs.urlevent.openURL("https://github.com")
		end,
		[singleKey("y", "youtube")] = function()
			hs.urlevent.openURL("https://youtube.com")
		end,
	},
}

-- Leader key
hs.hotkey.bind({ "option" }, "space", spoon.RecursiveBinder.recursiveBind(keyMap))
