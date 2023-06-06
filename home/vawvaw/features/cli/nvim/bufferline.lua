require("bufferline").setup {
  options = {
    close_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = "Bdelete! %d",
    right_mouse_command = nil,

    themable = true,
    indicator = { style = "icon", icon = "▎" },
    max_name_length = 25,
    tab_size = 20,
    show_buffer_close_icons = false,
    seperator_style = "thin",
    enforce_regular_tabs = true,
  },
}
