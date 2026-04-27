extends HBoxContainer

@onready var h_slider = $HSlider
@onready var spin_box = $SpinBox

var is_updating := false


func _on_h_slider_value_changed(value: float) -> void:
	if is_updating:
		return
	
	is_updating = true
	spin_box.value = value
	is_updating = false


func _on_spin_box_value_changed(value: float) -> void:
	if is_updating:
		return
	
	is_updating = true
	h_slider.value = value
	is_updating = false
