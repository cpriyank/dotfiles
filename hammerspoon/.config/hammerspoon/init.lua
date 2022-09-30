hs.loadSpoon("RecursiveBinder")

spoon.RecursiveBinder.escapeKey = {{}, 'escape'}  -- Press escape to abort

local singleKey = spoon.RecursiveBinder.singleKey

local keyMap = {
  [singleKey('b', 'browser')] = function() hs.application.launchOrFocus("Safari") end,
  [singleKey('f', 'firefox')] = function() hs.application.launchOrFocus("Firefox") end,
  [singleKey('t', 'terminal')] = function() hs.application.launchOrFocus("Kitty") end,
  [singleKey('c', 'communication')] = function() hs.application.launchOrFocus("Slack") end,
  [singleKey('q', 'docs')] = function() hs.application.launchOrFocus("Quip") end,
  [singleKey('p', 'pycharm')] = function() hs.application.launchOrFocus("PyCharm CE") end,
  [singleKey('m', 'mpv')] = function() hs.application.launchOrFocus("mpv") end,
  [singleKey('w', 'webex')] = function() hs.application.launchOrFocus("Cisco Webex Meetings") end,
  [singleKey('r', 'webex')] = function() hs.application.launchOrFocus("Radar 8") end,
  [singleKey('d', 'domain+')] = {
    [singleKey('g', 'github')] = function() hs.urlevent.openURL("github.com") end,
    [singleKey('y', 'youtube')] = function() hs.urlevent.openURL("youtube.com") end
  }
}

hs.hotkey.bind({'option'}, 'space', spoon.RecursiveBinder.recursiveBind(keyMap))

-- local applicationHotkeys = {
--   f = 'Safari',
--   k = 'Kitty',
--   d = 'Quip'
-- }
-- for key, app in pairs(applicationHotkeys) do
--   hs.hotkey.bind(hyper, key, function()
--     hs.application.launchOrFocus(app)
--   end)
-- end
