extends Button

@export var action : String
var is_listening: bool = false

static var remapping_in_progress: bool = false

func _ready():
    set_process_unhandled_input(false)
    display_key()

func display_key():
    text = InputMap.action_get_events(action)[0].as_text()

func remap_action_to(event):
    InputMap.action_erase_events(action)
    InputMap.action_add_event(action, event)

    Persistence.config.set_value("Controls", action, event)
    Persistence.save_data()

    text = event.as_text()

func _on_pressed() -> void:
    if not remapping_in_progress:
        remapping_in_progress = true
        set_process_unhandled_input(true)
        text = "Press any key..."
        is_listening = true
    else:
        print("Another key remap is already in progress.")


func _unhandled_key_input(event: InputEvent) -> void:
    if is_listening:
        remap_action_to(event)
        set_process_unhandled_input(false)
        is_listening = false
        release_focus()
        remapping_in_progress = false
