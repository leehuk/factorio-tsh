local guicore = {}
guicore.templates = require("gui/templates")
local util = require("util")

function guicore.gui_init()
    for i, player in pairs(game.players) do
        if player.valid and player.gui and player.gui.relative and player.gui.relative.children then
            for _, child in pairs(player.gui.relative.children) do
                if child.name == "tsh-duplicate" then
                    child.destroy()
                end
            end
        end

        guicore.gui_action_cleanup(player)

        local gui_button = guicore.templates.duplicate_button
        player.gui.relative.add(gui_button)
    end
end

local function tmerge(template, params)
    params = params or {}

    local result = guicore.templates[template]
    for k, v in pairs(params) do
        result[k] = v
    end

    return result
end

function guicore.gui_action_isopen(player)
    if player.valid and player.gui and player.gui.screen and player.gui.screen.children then
        for _, child in pairs(player.gui.screen.children) do
            if child.name == "tsh-action" then
                return true
            end
        end
    end

    return false
end

function guicore.gui_action_cleanup(player)
    if player.valid and player.gui and player.gui.screen and player.gui.screen.children then
        for _, child in pairs(player.gui.screen.children) do
            if child.name == "tsh-action" then
                child.destroy()
            end
        end
    end
end

function guicore.gui_action_duplicate_open(player, train)
    if guicore.gui_action_isopen(player) then
        guicore.gui_action_cleanup(player)
        return
    end

    -- Top Frame
    local gui_top = player.gui.screen.add(tmerge("action_frame"))
    gui_top.force_auto_center()
    
    -- Heading Title Bar
    local gui_heading_area = gui_top.add(tmerge("action_heading_flow"))
    local gui_heading_label = gui_heading_area.add(tmerge("action_heading_label", { caption = "Duplicate Station" }))
    local gui_heading_filler = gui_heading_area.add(tmerge("action_heading_filler"))

    gui_heading_label.drag_target = gui_top
    gui_heading_filler.drag_target = gui_top
    
    gui_heading_area.add(tmerge("action_close_button"))

    --local gui_search = guicore.templates.action_search_frame
    local gui_stationlist = gui_top.add(tmerge("action_list_pane", { name = "tsh-action" }))

    if train.schedule and train.schedule.records and #train.schedule.records > 0 then
        for i, record in ipairs(train.schedule.records) do
            gui_stationlist.add_item(record.station, i)
        end
    end
end

function guicore.gui_action_duplicate_click(player, train, index)
    local schedule = util.table.deepcopy(train.schedule)

    if index <= #schedule.records then
        local record = util.table.deepcopy(train.schedule.records[index])
        table.insert(schedule.records, record)
        train.schedule = schedule
    end

    guicore.gui_action_cleanup(player)
end

return guicore