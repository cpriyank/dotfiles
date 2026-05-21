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

-- ===== Clipboard history =====
hs.loadSpoon("TextClipboardHistory")
local clip = spoon.TextClipboardHistory
clip.hist_size = 250
clip.show_in_menubar = false
clip.paste_on_select = true

-- Preview truncation: collapse whitespace, cap at PREVIEW_LEN chars.
-- Full text is preserved in `fullText` for paste; chooser shows compact `text`.
local PREVIEW_LEN = 90
local function makePreview(s)
	local oneLine = s:gsub("[\r\n\t]+", " ⏎ "):gsub("  +", " ")
	local len = utf8.len(oneLine) or #oneLine
	if len > PREVIEW_LEN then
		local byteEnd = utf8.offset(oneLine, PREVIEW_LEN + 1)
		oneLine = oneLine:sub(1, (byteEnd or PREVIEW_LEN + 1) - 1) .. "…"
	end
	return oneLine
end

local origPopulate = clip._populateChooser
function clip:_populateChooser()
	local data = origPopulate(self)
	for _, row in ipairs(data) do
		if row.text and not row.action then
			row.fullText = row.text
			local preview = makePreview(row.text)
			local lineCount = select(2, row.text:gsub("\n", "\n")) + 1
			row.text = preview
			if #row.fullText > PREVIEW_LEN or lineCount > 1 then
				row.subText = string.format("%d chars · %d lines", #row.fullText, lineCount)
			end
		end
	end
	return data
end

local origProcess = clip._processSelectedItem
function clip:_processSelectedItem(value)
	if value and type(value) == "table" and value.fullText and not value.action then
		value.text = value.fullText
	end
	origProcess(self, value)
end

clip:start()

-- Theme + sizing for the chooser (created inside :start()).
clip.selectorobj
	:bgDark(true)
	:rows(12)
	:width(35)
	:searchSubText(false)
	:fgColor({ hex = "#cdd6f4" })
	:subTextColor({ hex = "#7f849c" })

-- Direct binding for muscle memory
hs.hotkey.bind({ "cmd", "shift" }, "v", function()
	clip:toggleClipboard()
end)

-- ===== RecursiveBinder =====
hs.loadSpoon("RecursiveBinder")
spoon.RecursiveBinder.escapeKey = { {}, "escape" }
spoon.RecursiveBinder.showBindHelper = true

local singleKey = spoon.RecursiveBinder.singleKey

-- ===== App + System Settings launcher (frecency-ranked) =====

-- Hand-curated overrides — used only where Apple's own searchTerms files miss
-- shorthand the user might actually type (e.g. "dnd" for Focus). Tags here are
-- merged with auto-discovered ones, not a replacement.
local paneOverrides = {
	["com.apple.Focus-Settings.extension"]            = { tags = "dnd" },
	["com.apple.Displays-Settings.extension"]         = { name = "Displays" },
	["com.apple.systempreferences.AppleIDSettings"]   = { name = "Apple ID" },
}

-- Sub-pane anchors (can't be auto-discovered since they're internal to a pane).
local subPanes = {
	{ name = "Night Shift",            url = "x-apple.systempreferences:com.apple.preference.displays?nightShift",             tags = "display blue light evening" },
	{ name = "Camera Privacy",         url = "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera",         tags = "permissions video webcam" },
	{ name = "Microphone Privacy",     url = "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone",     tags = "permissions audio recording" },
	{ name = "Screen Recording",       url = "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture",  tags = "permissions capture" },
	{ name = "Accessibility Permissions", url = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility", tags = "permissions a11y hammerspoon" },
	{ name = "Full Disk Access",       url = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles",       tags = "permissions filesystem" },
	{ name = "Automation Access",      url = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation",     tags = "permissions applescript" },
	{ name = "Input Monitoring",       url = "x-apple.systempreferences:com.apple.preference.security?Privacy_InputMonitoring", tags = "permissions keystroke" },
}

-- Title-case and CamelCase-split a derived name string.
local function prettifyName(s)
	s = s:gsub("[-_]+", " ")
	s = s:gsub("(%l)(%u)", "%1 %2") -- camelCase boundary
	s = s:gsub("(%u%u)(%u%l)", "%1 %2") -- acronymCase boundary (IDSettings → ID Settings)
	s = s:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	return s
end

-- Derive a human-friendly name from a bundle ID when the plist's display name
-- is missing or is a localization key (e.g. "ICLOUD_SCENE_LABEL").
local function deriveDisplayName(bundleID)
	local last = bundleID:match("([^%.]+)$") or bundleID
	last = last:gsub("[-_]?[Ss]ettings$", "")
	last = last:gsub("[-_]?[Ee]xtension$", "")
	return prettifyName(last)
end

local function looksLikeLocalizationKey(s)
	if not s or s == "" then return true end
	-- All caps with underscores = localization key (e.g. "ICLOUD_SCENE_LABEL")
	return s:match("^[%u_]+$") ~= nil
end

-- Determine preferred locale prefixes for resolving .lproj resources.
local function preferredLocales()
	local locales = {}
	local seen = {}
	local function add(s)
		if s and s ~= "" and not seen[s] then
			seen[s] = true
			table.insert(locales, s)
		end
	end
	local current = hs.host.locale.current and hs.host.locale.current()
	add(current)
	if current then add(current:match("^([%a]+)")) end
	add("en")
	add("en_US")
	add("Base")
	return locales
end

local LOCALES = preferredLocales()

-- Read a settings extension's bundled searchTerms plist; returns the parsed
-- table or nil. The file lives at Contents/Resources/<locale>.lproj/<name>.searchTerms.
local function readSearchTerms(extensionPath, fileName)
	if not fileName or fileName == "" then return nil end
	for _, locale in ipairs(LOCALES) do
		local path = extensionPath .. "/Contents/Resources/" .. locale .. ".lproj/" .. fileName .. ".searchTerms"
		if hs.fs.attributes(path) then
			return hs.plist.read(path)
		end
	end
	return nil
end

-- Walk a parsed searchTerms plist and collect titles + comma-separated index
-- keywords into a single space-joined tag string. De-duplicates case-insensitively.
local function tagsFromSearchTerms(data)
	if type(data) ~= "table" or type(data.Main) ~= "table" then return "" end
	local entries = data.Main.localizableStrings
	if type(entries) ~= "table" then return "" end
	local out, seen = {}, {}
	local function push(s)
		s = s and s:lower():gsub("^%s+", ""):gsub("%s+$", "") or ""
		if s ~= "" and not seen[s] then
			seen[s] = true
			table.insert(out, s)
		end
	end
	for _, entry in ipairs(entries) do
		push(entry.title)
		if type(entry.index) == "string" then
			for term in entry.index:gmatch("[^,]+") do
				push(term)
			end
		end
	end
	return table.concat(out, " ")
end

local function discoverSettingsPanes()
	local panes = {}
	local root = "/System/Library/ExtensionKit/Extensions"
	if not hs.fs.attributes(root) then return panes end
	local handle = io.popen("/bin/ls -1 " .. ("%q"):format(root) .. " 2>/dev/null")
	if not handle then return panes end
	for entry in handle:lines() do
		if entry:sub(-6) == ".appex" then
			local extensionPath = root .. "/" .. entry
			local plist = hs.plist.read(extensionPath .. "/Contents/Info.plist")
			if plist then
				local attrs = plist.EXAppExtensionAttributes
				local settingsAttrs = attrs and attrs.SettingsExtensionAttributes
				if settingsAttrs and settingsAttrs.allowsXAppleSystemPreferencesURLScheme then
					local bundleID = plist.CFBundleIdentifier
					if bundleID then
						local override = paneOverrides[bundleID] or {}
						local name = override.name
						if not name then
							name = plist.CFBundleDisplayName or plist.CFBundleName
							if looksLikeLocalizationKey(name) then
								name = deriveDisplayName(bundleID)
							end
						end
						local autoTags = tagsFromSearchTerms(readSearchTerms(extensionPath, settingsAttrs.searchTermsFileName))
						local tags = autoTags
						if override.tags and override.tags ~= "" then
							tags = (tags ~= "" and (tags .. " ") or "") .. override.tags
						end
						table.insert(panes, {
							name = name,
							url = "x-apple.systempreferences:" .. bundleID,
							bundleID = bundleID,
							tags = tags,
						})
					end
				end
			end
		end
	end
	handle:close()
	return panes
end

-- Frecency (persisted) — score = count * exp(-0.05 * daysSinceLastHit)
local launcherFrecency = hs.settings.get("launcher.frecency") or {}
local function frecencyOf(id)
	local e = launcherFrecency[id]
	if not e then return 0 end
	local days = (os.time() - e.last) / 86400
	return e.count * math.exp(-0.05 * days)
end
local function recordLauncherHit(id)
	local e = launcherFrecency[id] or { count = 0, last = 0 }
	e.count = e.count + 1
	e.last = os.time()
	launcherFrecency[id] = e
	hs.settings.set("launcher.frecency", launcherFrecency)
end

local launcherItems = {}
local launcherActions = {} -- id → fn (kept out of chooser data so it stays NSObject-serializable)

local function discoverAppsAt(root, depth)
	if not root or not hs.fs.attributes(root) then return end
	local handle = io.popen("/bin/ls -1 " .. ("%q"):format(root) .. " 2>/dev/null")
	if not handle then return end
	for entry in handle:lines() do
		if entry and entry:sub(1, 1) ~= "." then
			local path = root .. "/" .. entry
			if entry:sub(-4) == ".app" then
				local name = entry:sub(1, -5)
				local id = "app:" .. path
				table.insert(launcherItems, {
					id = id,
					text = name,
					subText = "Application",
					image = hs.image.iconForFile(path),
				})
				launcherActions[id] = function()
					hs.task.new("/usr/bin/open", nil, { path }):start()
				end
			elseif depth > 0 then
				local attr = hs.fs.attributes(path)
				if attr and attr.mode == "directory" then
					discoverAppsAt(path, depth - 1)
				end
			end
		end
	end
	handle:close()
end

local function buildLauncherItems()
	launcherItems = {}
	launcherActions = {}
	discoverAppsAt("/Applications", 1)
	discoverAppsAt("/System/Applications", 1)
	discoverAppsAt(os.getenv("HOME") .. "/Applications", 1)
	local settingsIcon = hs.image.imageFromAppBundle("com.apple.systempreferences")
	local addPane = function(pane)
		local id = "settings:" .. pane.url
		local tags = pane.tags or ""
		local subText = "System Settings"
		if tags ~= "" then subText = subText .. " · " .. tags end
		table.insert(launcherItems, {
			id = id,
			text = pane.name,
			subText = subText,
			image = settingsIcon,
		})
		local url = pane.url
		launcherActions[id] = function()
			hs.task.new("/usr/bin/open", nil, { url }):start()
		end
	end
	for _, pane in ipairs(discoverSettingsPanes()) do
		addPane(pane)
	end
	for _, pane in ipairs(subPanes) do
		addPane(pane)
	end
end

local launcherChooser = hs.chooser
	.new(function(choice)
		if not choice or not choice.id then return end
		recordLauncherHit(choice.id)
		local fn = launcherActions[choice.id]
		if fn then fn() end
	end)
	:bgDark(true)
	:rows(12)
	:width(40)
	:searchSubText(true)
	:fgColor({ hex = "#cdd6f4" })
	:subTextColor({ hex = "#7f849c" })

launcherChooser:choices(function()
	return launcherItems
end)

local function showLauncher()
	if #launcherItems == 0 then
		hs.alert.show("Launcher: no items discovered (check /Applications)")
		return
	end
	table.sort(launcherItems, function(a, b)
		return frecencyOf(a.id) > frecencyOf(b.id)
	end)
	launcherChooser:refreshChoicesCallback()
	launcherChooser:show()
end

buildLauncherItems()
hs.printf("Launcher: %d items discovered", #launcherItems)

-- ===== Window switcher (across spaces, MRU order) =====
local switcherFilter = hs.window.filter.new():setCurrentSpace(nil)

-- Pre-warm the filter so the first invocation isn't slow.
hs.timer.doAfter(2, function()
	switcherFilter:getWindows(hs.window.filter.sortByFocusedLast)
end)

-- Cache app icons; bundleID → hs.image (filesystem lookup is the slow part).
local iconCache = {}
local function getAppIcon(bundleID)
	if not bundleID then
		return nil
	end
	if iconCache[bundleID] == nil then
		iconCache[bundleID] = hs.image.imageFromAppBundle(bundleID) or false
	end
	return iconCache[bundleID] or nil
end

local switcherChooser = hs.chooser
	.new(function(choice)
		if not choice or not choice.winId then
			return
		end
		local win = hs.window.get(choice.winId)
		if win then
			win:focus()
		end
	end)
	:bgDark(true)
	:rows(12)
	:width(35)
	:searchSubText(true)
	:fgColor({ hex = "#cdd6f4" })
	:subTextColor({ hex = "#7f849c" })

local function buildAndShowSwitcher()
	local choices = {}
	local focused = hs.window.focusedWindow()
	local focusedId = focused and focused:id() or nil
	for _, win in ipairs(switcherFilter:getWindows(hs.window.filter.sortByFocusedLast)) do
		if win:isStandard() and not win:isMinimized() and win:id() ~= focusedId then
			local app = win:application()
			local bundleID = app and app:bundleID()
			table.insert(choices, {
				text = (app and app:name()) or "?",
				subText = win:title() or "",
				image = getAppIcon(bundleID),
				winId = win:id(),
			})
		end
	end
	switcherChooser:choices(choices)
	switcherChooser:show()
end

-- Defer to next tick so RecursiveBinder's hint dismisses immediately
-- and we don't visibly block the leader UI while building the chooser.
local function showWindowSwitcher()
	hs.timer.doAfter(0, buildAndShowSwitcher)
end

-- ===== Auto-layout on display change =====
-- Snapshot/restore window placement per display config.
-- Stored in hs.settings under "autoLayout.<configKey>" — survives reloads.
local function currentConfigKey()
	local ids = {}
	for _, s in ipairs(hs.screen.allScreens()) do
		table.insert(ids, s:getUUID() or tostring(s:id()))
	end
	table.sort(ids)
	return table.concat(ids, "|")
end

local function snapshotLayout()
	local snapshot = {}
	for _, app in ipairs(hs.application.runningApplications()) do
		if app:kind() == 1 then
			local bundleID = app:bundleID()
			if bundleID then
				local windows = {}
				for _, win in ipairs(app:allWindows()) do
					if win:isStandard() and not win:isMinimized() then
						local screen = win:screen()
						if screen then
							local f = win:frame()
							local sf = screen:frame()
							table.insert(windows, {
								screenUUID = screen:getUUID() or tostring(screen:id()),
								unit = {
									x = (f.x - sf.x) / sf.w,
									y = (f.y - sf.y) / sf.h,
									w = f.w / sf.w,
									h = f.h / sf.h,
								},
								title = win:title() or "",
							})
						end
					end
				end
				if #windows > 0 then
					snapshot[bundleID] = windows
				end
			end
		end
	end
	local key = currentConfigKey()
	hs.settings.set("autoLayout." .. key, snapshot)
	local count = 0
	for _ in pairs(snapshot) do
		count = count + 1
	end
	hs.alert.show(string.format("Layout saved: %d apps · %d screens", count, #hs.screen.allScreens()))
end

local function findScreenByUUID(uuid)
	for _, s in ipairs(hs.screen.allScreens()) do
		if (s:getUUID() or tostring(s:id())) == uuid then
			return s
		end
	end
	return nil
end

local function restoreLayout()
	local key = currentConfigKey()
	local snapshot = hs.settings.get("autoLayout." .. key)
	if not snapshot then
		hs.alert.show("No layout saved for this display config")
		return false
	end
	local restored = 0
	for bundleID, savedWindows in pairs(snapshot) do
		local apps = hs.application.applicationsForBundleID(bundleID)
		local app = apps and apps[1]
		if app then
			local liveWindows = {}
			for _, w in ipairs(app:allWindows()) do
				if w:isStandard() and not w:isMinimized() then
					table.insert(liveWindows, w)
				end
			end
			local used = {}
			for _, sw in ipairs(savedWindows) do
				local match
				for i, lw in ipairs(liveWindows) do
					if not used[i] and lw:title() == sw.title then
						match = lw
						used[i] = true
						break
					end
				end
				if not match then
					for i, lw in ipairs(liveWindows) do
						if not used[i] then
							match = lw
							used[i] = true
							break
						end
					end
				end
				if match then
					local screen = findScreenByUUID(sw.screenUUID)
					if screen then
						local sf = screen:frame()
						match:setFrame({
							x = sf.x + sw.unit.x * sf.w,
							y = sf.y + sw.unit.y * sf.h,
							w = sw.unit.w * sf.w,
							h = sw.unit.h * sf.h,
						})
						restored = restored + 1
					end
				end
			end
		end
	end
	hs.alert.show(string.format("Layout restored: %d windows", restored))
	return true
end

-- Auto-restore on display change (debounced; lets macOS settle first)
local layoutDebounce
local screenWatcher = hs.screen.watcher.new(function()
	if layoutDebounce then
		layoutDebounce:stop()
	end
	layoutDebounce = hs.timer.doAfter(2.0, function()
		local key = currentConfigKey()
		if hs.settings.get("autoLayout." .. key) then
			restoreLayout()
		end
	end)
end)
screenWatcher:start()

-- ===== Vim navigation mode (eventtap-based) =====
-- Enter with Option+Space → v. Escape, i, or a to exit.
-- Uses hs.eventtap so interception works in search fields, terminals, and
-- other contexts where hs.hotkey's Carbon API doesn't reliably catch bare keys.
local vimActive = false
local vimVisual = false
local vimAlertId = nil
local vimEventTap = nil
local VIM_INJECT_MARK = 0x76494d4d -- "vIMM" — tags our synthesized events

local function showVimStatus()
	if vimAlertId then
		hs.alert.closeSpecific(vimAlertId)
	end
	vimAlertId = hs.alert.show(vimVisual and "VIM · VISUAL" or "VIM", 0)
end

local function vimExit()
	if not vimActive then return end
	vimActive = false
	if vimEventTap then vimEventTap:stop() end
	if vimAlertId then
		hs.alert.closeSpecific(vimAlertId)
		vimAlertId = nil
	end
end

-- Post a synthetic keystroke tagged so we recognize and skip it on the way back.
local function vimInject(mods, key)
	local down = hs.eventtap.event.newKeyEvent(mods, key, true)
	local up = hs.eventtap.event.newKeyEvent(mods, key, false)
	if down then
		down:setProperty(hs.eventtap.event.properties.eventSourceUserData, VIM_INJECT_MARK)
		down:post()
	end
	if up then
		up:setProperty(hs.eventtap.event.properties.eventSourceUserData, VIM_INJECT_MARK)
		up:post()
	end
end

-- Movement: prepends shift in visual mode to extend selection.
local function vimMove(key, mods)
	return function()
		local m = mods and { table.unpack(mods) } or {}
		if vimVisual then table.insert(m, "shift") end
		vimInject(m, key)
	end
end

-- Action: never extends selection (find, paste, etc.).
local function vimAction(key, mods)
	return function()
		vimInject(mods or {}, key)
	end
end

-- Handlers, looked up by character + whether shift is held.
local vimNormal = {
	h = vimMove("left"),
	j = vimMove("down"),
	k = vimMove("up"),
	l = vimMove("right"),
	w = vimMove("right", { "alt" }),
	b = vimMove("left", { "alt" }),
	["0"] = vimMove("left", { "cmd" }),
	g = vimMove("up", { "cmd" }),
	u = vimMove("pageup"),
	d = vimMove("pagedown"),
	["/"] = vimAction("f", { "cmd" }),
	n = vimAction("g", { "cmd" }),
	p = vimAction("v", { "cmd" }),
	y = function()
		vimInject({ "cmd" }, "c")
		vimVisual = false
		showVimStatus()
	end,
	v = function()
		vimVisual = not vimVisual
		showVimStatus()
	end,
	i = vimExit,
	a = vimExit,
}

local vimShift = {
	["4"] = vimMove("right", { "cmd" }),       -- $
	g = vimMove("down", { "cmd" }),            -- G
	n = vimAction("g", { "cmd", "shift" }),    -- N
}

local ESCAPE_KEYCODE = hs.keycodes.map.escape

local function vimEventHandler(event)
	-- Skip events we synthesized so we don't re-process them.
	if event:getProperty(hs.eventtap.event.properties.eventSourceUserData) == VIM_INJECT_MARK then
		return false
	end

	local flags = event:getFlags()
	-- Pass through Cmd/Alt/Ctrl chords so Cmd+Tab, Cmd+W, etc. still work.
	if flags.cmd or flags.alt or flags.ctrl then
		return false
	end

	if event:getKeyCode() == ESCAPE_KEYCODE then
		vimExit()
		return true
	end

	local char = event:getCharacters(true)
	if not char or char == "" then return false end
	char = char:lower()

	local handler = flags.shift and vimShift[char] or vimNormal[char]
	if handler then handler() end

	-- Consume any alphanumeric / punctuation so stray keys don't type into
	-- the focused app while in vim mode. Pass through everything else
	-- (arrow keys, function keys, etc.).
	if char:match("^[%w/]$") then return true end
	return false
end

local function vimEnter()
	if vimActive then return end
	vimActive = true
	vimVisual = false
	showVimStatus()
	if not vimEventTap then
		vimEventTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, vimEventHandler)
	end
	vimEventTap:start()
end

-- ===== Quit chooser (pick app to quit) =====
local quitChooser = hs.chooser
	.new(function(choice)
		if not choice or not choice.pid then
			return
		end
		local app = hs.application.applicationForPID(choice.pid)
		if app then
			app:kill()
		end
	end)
	:bgDark(true)
	:rows(12)
	:width(35)
	:fgColor({ hex = "#cdd6f4" })
	:subTextColor({ hex = "#7f849c" })

local function showQuitChooser()
	local choices = {}
	for _, app in ipairs(hs.application.runningApplications()) do
		if app:kind() == 1 then
			local name = app:name()
			local bundleID = app:bundleID()
			if name and bundleID then
				local winCount = #app:allWindows()
				table.insert(choices, {
					text = name,
					subText = winCount == 1 and "1 window" or (winCount .. " windows"),
					image = hs.image.imageFromAppBundle(bundleID),
					pid = app:pid(),
				})
			end
		end
	end
	table.sort(choices, function(a, b)
		return a.text:lower() < b.text:lower()
	end)
	quitChooser:choices(choices)
	quitChooser:show()
end

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

	-- Clipboard history
	[singleKey("y", "yank/clipboard")] = function()
		clip:toggleClipboard()
	end,

	-- Window switcher (MRU, across spaces)
	[singleKey("o", "open window")] = showWindowSwitcher,

	-- App + Settings launcher (frecency-ranked)
	[singleKey("a", "any/launcher")] = showLauncher,

	-- Quit chooser (pick app to quit)
	[singleKey("k", "kill app")] = showQuitChooser,

	-- Layout snapshot/restore (auto-restores on display change)
	[singleKey("l", "layout+")] = {
		[singleKey("s", "snapshot")] = snapshotLayout,
		[singleKey("r", "restore")] = restoreLayout,
	},

	-- Vim navigation mode
	[singleKey("v", "vim mode")] = vimEnter,

	-- Reload config
	[singleKey("r", "reload")] = function()
		hs.reload()
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
}

-- Leader key
hs.hotkey.bind({ "option" }, "space", spoon.RecursiveBinder.recursiveBind(keyMap))

-- Direct Cmd+Space → launcher (replaces Spotlight; same as Option+Space → a)
hs.hotkey.bind({ "cmd" }, "space", showLauncher)
