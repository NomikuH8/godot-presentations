class_name EnterCommandWait
extends RichTextLabel



signal wait_finished()



@export var started: bool = false
@export var wait_amount: float = .05



func _process(_delta: float) -> void:
	if started:
		visible = true
		await get_tree().create_timer(wait_amount).timeout
		wait_finished.emit()
		started = false



func start() -> void:
	started = true
