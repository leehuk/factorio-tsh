local guicore = require("gui/core")

function tsh_event_gui_opened(event)
    local player = game.players[event.player_index]
    
    if not player or not player.valid or not event.entity or not event.entity.valid then
        return
    end
    
    if event.entity.type == "locomotive" then
        global.guimapping[player.index] = event.entity
    end
end

function tsh_event_gui_closed(event)
    local player = game.players[event.player_index]
    
    if not player or not player.valid or not event.entity or not event.entity.valid then
        return
    end
    
    if event.entity.type == "locomotive" then
        global.guimapping[player.index] = nil
        guicore.gui_action_cleanup(player)
    end
end

function tsh_event_gui_click(event)
    local player = game.players[event.player_index]
    
    if not player or not player.valid then
        return
    end

    if event.element.name == "tshb-closebutton" then
        guicore.gui_action_cleanup(player)
        return
    end

    local entity = global.guimapping[player.index]
    if not entity or not entity.valid or not entity.train then
        return
    end

    if event.element.name == "tshb-duplicate" then        
        guicore.gui_action_duplicate_open(player, entity.train)
    elseif event.element.name == "tshb-replace" then
        guicore.gui_action_replace_open(player, entity.train)
    end
end

function tsh_event_gui_selected(event)
    local player = game.players[event.player_index]

    if not player or not player.valid or not event.element or not event.element.valid then
        return
    end

    local entity = global.guimapping[player.index]
    if not entity or not entity.valid or not entity.train then
        return
    end

    if event.element.name == "tsha-duplicate" then
        guicore.gui_action_duplicate_click(player, entity.train, event.element)
    elseif event.element.name == "tsha-replacesource" or event.element.name == "tsha-replacetarget" then
        guicore.gui_action_replace_click(player, entity.train, event.element)
    end
end

function tsh_event_modsetting_changed(event)
    if not event.player_index or event.setting ~= "tsh-button-location" then        
        return
    end

    local player = game.players[event.player_index]
    if not player or not player.valid then
        return
    end

    guicore.gui_init_player(player)
end

function tsh_event_player_created(event)
    local player = game.players[event.player_index]

    guicore.gui_init_player(player)
end