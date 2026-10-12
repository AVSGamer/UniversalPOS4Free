extends MarginContainer

# Define what percentage of the screen width/height you want your margins to be
@export_range(0.0, 0.2) var horizontal_margin_percentage: float = 0.04 # 4% of screen width
@export_range(0.0, 0.2) var vertical_margin_percentage: float = 0.03   # 3% of screen height

func _ready() -> void:
	# 1. Run the initial calculation immediately on load
	_recalculate_margins()
	
	# 2. Connect to the window size change signal to handle responsive resizing dynamically
	get_tree().root.size_changed.connect(_recalculate_margins)

func _recalculate_margins() -> void:
	# Get the current dimensions of the game window/viewport
	var viewport_size: Vector2i = get_viewport().size
	
	# Calculate dynamic pixel values based on current viewport size
	var dynamic_x_margin: int = int(viewport_size.x * horizontal_margin_percentage)
	var dynamic_y_margin: int = int(viewport_size.y * vertical_margin_percentage)
	
	# Enforce a reasonable minimum padding so text never touches the absolute edge on tiny screens
	dynamic_x_margin = max(dynamic_x_margin, 10)
	dynamic_y_margin = max(dynamic_y_margin, 10)
	
	# Apply the overrides to the theme constants matrix
	add_theme_constant_override("margin_left", dynamic_x_margin)
	add_theme_constant_override("margin_right", dynamic_x_margin)
	add_theme_constant_override("margin_top", dynamic_y_margin)
	add_theme_constant_override("margin_bottom", dynamic_y_margin)
