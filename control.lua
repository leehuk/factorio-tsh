require('event')

local guicore = require('gui/core')

script.on_init(function()
    global.guimapping = {}
    global.stationmapping = {}
    guicore.gui_init()
end)

script.on_configuration_changed(function(event)
    global.guimapping = {}
    global.stationmapping = {}
    guicore.gui_init()
end)

script.on_event(defines.events.on_gui_click, tsh_event_gui_click)
script.on_event(defines.events.on_gui_closed, tsh_event_gui_closed)
script.on_event(defines.events.on_gui_opened, tsh_event_gui_opened)
script.on_event(defines.events.on_gui_selection_state_changed, tsh_event_gui_selected)
script.on_event(defines.events.on_gui_text_changed, tsh_event_gui_text)

script.on_event(defines.events.on_runtime_mod_setting_changed, tsh_event_modsetting_changed)
script.on_event(defines.events.on_player_created, tsh_event_player_created)