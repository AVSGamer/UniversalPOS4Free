extends PanelContainer

@export_file("*.png") var dynamic_skin_path: String = "res://res/3by3StyleBox.png"
@export_group("9-Slice Percentages")
@export_range(0.0, 0.45) var left_margin_percentage: float = 0.165
@export_range(0.0, 0.45) var right_margin_percentage: float = 0.165
@export_range(0.0, 0.45) var top_margin_percentage: float = 0.165
@export_range(0.0, 0.45) var bottom_margin_percentage: float = 0.165

func _ready() -> void:
	apply_custom_form_skin(dynamic_skin_path)

func apply_custom_form_skin(texture_path: String) -> void:
	var skin_texture: Texture2D = load(texture_path)
	var image_size: Vector2 = skin_texture.get_size()
	var tex_width: float = image_size.x
	var tex_height: float = image_size.y
	var pixel_cut_left: int = int(tex_width * left_margin_percentage)
	var pixel_cut_right: int = int(tex_width * right_margin_percentage)
	var pixel_cut_top: int = int(tex_height * top_margin_percentage)
	var pixel_cut_bottom: int = int(tex_height * bottom_margin_percentage)
	var dynamic_stylebox: StyleBoxTexture = StyleBoxTexture.new()
	dynamic_stylebox.texture = skin_texture
	dynamic_stylebox.texture_margin_left = pixel_cut_left
	dynamic_stylebox.texture_margin_right = pixel_cut_right
	dynamic_stylebox.texture_margin_top = pixel_cut_top
	dynamic_stylebox.texture_margin_bottom = pixel_cut_bottom
	dynamic_stylebox.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	dynamic_stylebox.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_STRETCH
	dynamic_stylebox.draw_center = true
	add_theme_stylebox_override("dyn_stylebox",dynamic_stylebox)
