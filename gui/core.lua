local guicore = {}
guicore.templates = require("gui/templates")
local util = require("util")

function guicore.gui_init()
    for i, player in pairs(game.players) do
        guicore.gui_init_player(player)
    end
end

function guicore.gui_init_player(player)
    if player.valid and player.gui and player.gui.relative and player.gui.relative.children then
        for _, child in pairs(player.gui.relative.children) do
            if child.name == "tshb-duplicate" or child.name == "tshb-replace" then
                child.destroy()
            end
        end
    end

    guicore.gui_action_cleanup(player)

    player.gui.relative.add(guicore.templates.duplicate_button)
    player.gui.relative.add(guicore.templates.replace_button)
end

local function tmerge(template, params)
    params = params or {}

    local result = guicore.templates[template]
    for k, v in pairs(params) do
        result[k] = v
    end

    return result
end

function guicore.gui_action_isopen(player, search)
    if player.valid and player.gui and player.gui.screen and player.gui.screen.children then
        for _, child in pairs(player.gui.screen.children) do
            if child.name == search then
                return true
            end
        end
    end

    return false
end

function guicore.gui_action_cleanup(player)
    if player.valid and player.gui and player.gui.screen and player.gui.screen.children then
        for _, child in pairs(player.gui.screen.children) do
            if child.name == "tshf-duplicate" or child.name == "tshf-replace" then
                child.destroy()
            end
        end
    end
end

function guicore.gui_action_duplicate_open(player, train)
    if guicore.gui_action_isopen(player, "tshf-duplicate") then
        guicore.gui_action_cleanup(player)
        return
    elseif guicore.gui_action_isopen(player, "tshf-replace") then
        guicore.gui_action_cleanup(player)
    end

    -- Top Frame
    local gui_top = player.gui.screen.add(tmerge("action_frame", { name = "tshf-duplicate"}))
    gui_top.force_auto_center()
    
    -- Heading Title Bar
    local gui_heading_area = gui_top.add(tmerge("action_heading_flow"))
    local gui_heading_label = gui_heading_area.add(tmerge("action_heading_label", { caption = {"tsh_duplicate"} }))
    local gui_heading_filler = gui_heading_area.add(tmerge("action_heading_filler"))

    gui_heading_label.drag_target = gui_top
    gui_heading_filler.drag_target = gui_top
    
    gui_heading_area.add(tmerge("action_close_button"))

    --local gui_search = guicore.templates.action_search_frame
    local gui_stationlist = gui_top.add(tmerge("action_list_pane", { name = "tsha-duplicate" }))

    if train.schedule and train.schedule.records and #train.schedule.records > 0 then
        for i, record in ipairs(train.schedule.records) do
            gui_stationlist.add_item(record.station, i)
        end
    end
end

function guicore.gui_action_duplicate_click(player, train, element)
    local schedule = util.table.deepcopy(train.schedule)

    if element.selected_index == 0 then
        return
    end

    if element.selected_index <= #schedule.records then
        local record = util.table.deepcopy(train.schedule.records[element.selected_index])
        table.insert(schedule.records, record)
        train.schedule = schedule
    end

    guicore.gui_action_cleanup(player)
end

local function gui_stationlist_collate(player)
    local stations_unsorted = player.surface.find_entities_filtered({
        name = "train-stop"
    })

    local stations = {}
    local stations_seen = {}

    for _, station in pairs(stations_unsorted) do
        if not stations_seen[station.backer_name] then
            table.insert(stations, station.backer_name)
            stations_seen[station.backer_name] = true
        end
    end

    table.sort(stations)
    return stations
end

function guicore.gui_action_replace_open(player, train)
    if guicore.gui_action_isopen(player, "tshf-replace") then
        guicore.gui_action_cleanup(player)
        return
    elseif guicore.gui_action_isopen(player, "tshf-duplicate") then
        guicore.gui_action_cleanup(player)
    end

    local gui_top = player.gui.screen.add(tmerge("action_frame", { name = "tshf-replace"}))
    gui_top.force_auto_center()
    
    -- Heading Title Bar
    local gui_heading_area = gui_top.add(tmerge("action_heading_flow"))
    local gui_heading_label = gui_heading_area.add(tmerge("action_heading_label", { caption = {"tsh_replace"} }))
    local gui_heading_filler = gui_heading_area.add(tmerge("action_heading_filler"))

    gui_heading_label.drag_target = gui_top
    gui_heading_filler.drag_target = gui_top
    
    gui_heading_area.add(tmerge("action_close_button"))

    --local gui_search = guicore.templates.action_search_frame
    local gui_stationlist_s = gui_top.add(tmerge("action_list_pane", { name = "tsha-replacesource" }))

    if train.schedule and train.schedule.records and #train.schedule.records > 0 then
        for _, record in pairs(train.schedule.records) do
            gui_stationlist_s.add_item(record.station)
        end
    end

    local gui_stationlist_t = gui_top.add(tmerge("action_list_pane", { name = "tsha-replacetarget" }))

    for _, station in pairs(gui_stationlist_collate(player)) do
        gui_stationlist_t.add_item(station)
    end
end

function guicore.gui_action_replace_click(player, train, element)
    local source
    local target

    for _, child in pairs(element.parent.children) do
        if element.name == "tsha-replacesource" and child.name == "tsha-replacetarget" then
            source = element
            target = child
        elseif element.name == "tsha-replacetarget" and child.name == "tsha-replacesource" then
            source = child
            target = element
        end
    end

    if not source or not target then
        return
    end

    if source.selected_index > 0 and target.selected_index > 0 then
        local schedule = util.table.deepcopy(train.schedule)

        if source.selected_index <= #schedule.records then
            local record = util.table.deepcopy(train.schedule.records[source.selected_index])
            record.station = target.get_item(target.selected_index)
            schedule.records[source.selected_index] = record
            train.schedule = schedule
        end

        guicore.gui_action_cleanup(player)
    end
end

return guicore