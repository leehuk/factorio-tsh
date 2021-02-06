require('event')

local guicore = require('gui/core')

script.on_init(function()
    global.guimapping = {}
    guicore.gui_init()
end)

script.on_configuration_changed(function(event)
    global.guimapping = {}
    guicore.gui_init()
end)

script.on_event(defines.events.on_gui_click, tsh_event_gui_click)
script.on_event(defines.events.on_gui_closed, tsh_event_gui_closed)
script.on_event(defines.events.on_gui_opened, tsh_event_gui_opened)
script.on_event(defines.events.on_gui_selection_state_changed, tsh_event_gui_selected)