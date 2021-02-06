local guitemplates = {}

guitemplates.duplicate_button = {
    name = "tshb-duplicate",
    type = "sprite-button",
    sprite = "tsh_button_duplicate",
    style = "tsh_button",
    anchor = {
        gui      = defines.relative_gui_type.train_gui,
        position = defines.relative_gui_position.right,
    }
}

guitemplates.replace_button = {
    name = "tshb-replace",
    type = "sprite-button",
    sprite = "tsh_button_replace",
    style = "tsh_button",
    anchor = {
        gui      = defines.relative_gui_type.train_gui,
        position = defines.relative_gui_position.right,
    }
}

guitemplates.action_frame = {
    type = "frame",
    direction = "vertical",
    style = "frame"
}
guitemplates.action_heading_flow = {
    name = "tsh-action-heading-flow",
    type = "flow",
    direction = "horizontal",
    style = "horizontal_flow"
}
guitemplates.action_heading_label = {
    name = "tsh-action-heading-label",
    type = "label",
    style = "frame_title"
}
guitemplates.action_heading_filler = {
    name = "tsh-action-heading-filler",
    type = "empty-widget",
    style = "tsh_heading_filler"
}
guitemplates.action_close_button = {
    name = "tshb-closebutton",
    type = "sprite-button",
    sprite = "tsh_button_close",
    style = "frame_action_button"
}
guitemplates.action_search_frame = {
    name = "tsh-action-search",
    type = "frame",
    direction = "horizontal",
    style = "subheader_frame"
}
guitemplates.action_list_pane = {
    type = "list-box",
    style = "tsh_list_pane",
}
guitemplates.action_listitem = {
    type = "button",
    style = "list_box_item"
}

return guitemplates