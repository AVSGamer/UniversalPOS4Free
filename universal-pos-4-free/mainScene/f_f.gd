# FirstForm.gd
extends Control

# Reference the UI elements inside your 2D Control Node using type inference
@onready var fform_pc := $FFmc/FFpc
@onready var detect_first := $FFmc/FFpc/VBoxContainer/detectFirstRun
@onready var initialize_sys := $FFmc/FFpc/VBoxContainer/firstRun
@onready var gov_reg_save := $FFmc/FFpc/VBoxContainer/HBoxContainer/govRegSave
@onready var HBC1 := $FFmc/FFpc/VBoxContainer/HBoxContainer
@onready var yBTN := $FFmc/FFpc/VBoxContainer/HBoxContainer/btnY
@onready var nBTN := $FFmc/FFpc/VBoxContainer/HBoxContainer/btnN
@onready var yBTN2 := $FFmc/FFpc/VBoxContainer/HBoxContainer/btnY2
@onready var nBTN2 := $FFmc/FFpc/VBoxContainer/HBoxContainer/btnN2
@onready var yBTN3 := $FFmc/FFpc/VBoxContainer/HBoxContainer/btnY3
@onready var nBTN3 := $FFmc/FFpc/VBoxContainer/HBoxContainer/btnN3
@onready var chkBoxAlways := $FFmc/FFpc/VBoxContainer/displayAtStart
@onready var inputBox := $FFmc/FFpc/VBoxContainer/tInputmc/textInput
@onready var vbox_ff := $FFmc/FFpc/VBoxContainer/MarginContainer/progGenGovDeets
@onready var vbox_ff_out_gov := $FFmc/FFpc/VBoxContainer/MarginContainer/outGenGovDeets

func _ready() -> void:
	# Programmatically force the signal to bind to our custom saving function
	if not gov_reg_save.pressed.is_connected(_on_gov_reg_save_pressed):
		gov_reg_save.pressed.connect(_on_gov_reg_save_pressed)
	
	# Hide contextual dynamic elements explicitly on boot to maintain an uncluttered view
	inputBox.hide()
	gov_reg_save.hide()
	nBTN3.hide()
	yBTN3.hide()
	vbox_ff_out_gov.hide()
	_evaluate_system_state()

func _evaluate_system_state() -> void:
	if G.firstRun == 0:
		detect_first.hide()
		initialize_sys.text = "Detected unconfigured POS Launch. Initialize Parameters?"
		initialize_sys.show()
		HBC1.show()
		yBTN.show()
		nBTN.hide() # On first real installation boot, skipping configuration defaults to No instead
		chkBoxAlways.show()
	else:
		detect_first.hide()
		initialize_sys.text = "Detected configured POS Launch. Re-Initialize Parameters?"
		if G.firstPrompt == true:
			initialize_sys.show()
			HBC1.show()
			yBTN.show()
			nBTN.show()
			chkBoxAlways.show()
		else:
			_transition_to_user_login()

func _transition_to_user_login() -> void:
	print("System already configured. Redirecting layout to User Login Matrix...")
	# get_tree().change_scene_to_file("res://scenes/UserLogin.tscn")

# Call this function once the Admin successfully submits the initialization profile
func complete_initial_setup() -> void:
	G.firstRun = 1
	# Save state to local browser/file configuration layers here securely...
	_System_Parameters_Init()

func _on_btn_y_pressed() -> void:
	# Start System Parameters Initialization
	G.firstPrompt = chkBoxAlways.button_pressed
	if chkBoxAlways.visible == true:
		chkBoxAlways.hide()
	detect_first.text = "Do you have Government Approved Business Registration Details to Save in this POS?"
	detect_first.show()
	initialize_sys.text = "The details provided to you after approval that you need to input in this system.\nI have no idea what those could be.\nSo I am handing over to you the ability to create the fields for those details yourself if you agree.\nOtherwise, if you want to skip this to demonstrate the system first, click No."
	if nBTN.visible == true:
		nBTN.hide()
	if yBTN.visible == true:
		yBTN.hide()
	nBTN2.show()
	yBTN2.show()

func _on_btn_n_pressed() -> void:
	G.firstPrompt = chkBoxAlways.button_pressed
	if chkBoxAlways.visible == true:
		chkBoxAlways.hide()
	if HBC1.visible == true:
		HBC1.hide()
	if yBTN.visible == true:
		yBTN.hide()
	if nBTN.visible == true:
		nBTN.hide()    
	initialize_sys.text = "!!YOU ARE NOT SUPPOSED TO REACH THIS MESSAGE!!\nDon't worry though, there's no harm in it\nBut nice \'FLAG^1337\' you got there! ;) Hackur!"
	# Add a safe yield/wait delay here before forcing redirection to terminal login panels
	await get_tree().create_timer(3.5).timeout
	_transition_to_user_login()

func _on_btn_y_2_pressed() -> void:
	# Registered Mode -> UI to Input Custom String Fields.
	detect_first.text = "!YOU ARE IN GOV'T REGISTRATION INFO INPUT MODE!(BETA-MODE-DO NOT INPUT REAL DATA!)"
	initialize_sys.text = "Name the FIELD or LABEL of the INFORMATION to be added in the Input Box\nthen use the buttons below to add the appropriate\nTYPE OF THE FIELD for what you are inputting.\nClick Save without adding any Fields or without clicking\nany of the buttons below to skip this part and proceed to the rest of the Demo."
	nBTN2.hide()
	yBTN2.hide()
	nBTN3.show()
	yBTN3.show()
	inputBox.show()
	gov_reg_save.show()
	
func _on_btn_n_2_pressed() -> void:
	# Demo Mode Not Registered to Government via the Business/User yet.
	_System_Parameters_Init()

func _on_btn_y_3_pressed() -> void:
	if inputBox.text.strip_edges() == "": return # Guard against blank names
	_create_field_programmatically(inputBox.text, 1) # 1 = Numeric Type Flag

func _on_btn_n_3_pressed() -> void:
	if inputBox.text.strip_edges() == "": return # Guard against blank names
	_create_field_programmatically(inputBox.text, 0) # 0 = String Type Flag
	
func _create_field_programmatically(field_label_name: String, data_type_flag: int) -> void:
	# Append automatically adds the data validation tags to tracking layout arrays
	if vbox_ff.visible == false:
		vbox_ff.show()
	G.govRegEIDPairs.append(data_type_flag)
	
	if data_type_flag == 0:
		G.govRegDT.append("") # Empty placeholder for future data value collection strings
		G.govRegDTFields.append(field_label_name)
	else:
		G.govRegI.append(0)   # Numeric placeholder integer tracking slot
		G.govRegIFields.append(field_label_name)

	# GENERATE 2D INTERFACE ELEMENTS VIA CODE
	var row_hbox := HBoxContainer.new()
	row_hbox.name = "FieldRow_" + str(inputBox.text.hash()) # Hash naming handles independent indexing structures
	
	# BAKE METADATA STRINGS DIRECTLY INTO THE PARENT NODE OBJECT
	row_hbox.set_meta("field_label", field_label_name)
	row_hbox.set_meta("data_type", data_type_flag)
	
	# Create the structural Delete Button on the far left
	var del_button := Button.new()
	del_button.text = "X"
	del_button.pressed.connect(func():
		_delete_field_by_metadata(row_hbox)
	)    
	
	# Create the visual Descriptor Label
	var field_label := Label.new()
	field_label.text = field_label_name + ": "
	field_label.custom_minimum_size.x = 150 
	
	# Create editable inputs box
	var custom_input := LineEdit.new()
	custom_input.name = "InputBox" 
	custom_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_input.placeholder_text = "Input numeric value..." if data_type_flag == 1 else "Input text..."
	
	# ENFORCE SYSTEM INTERCEPT VALIDATION RULES [Tech Support Skill]
	if data_type_flag == 1:
		custom_input.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER_DECIMAL
		custom_input.text_changed.connect(func(new_text: String): 
			_enforce_numeric_only_typing(custom_input, new_text)
		)
		
	# Inject child layouts sequentially
	row_hbox.add_child(del_button)
	row_hbox.add_child(field_label)
	row_hbox.add_child(custom_input) 
	
	vbox_ff.add_child(row_hbox)
	inputBox.text = ""

func _on_gov_reg_save_pressed() -> void:
	print("--- SYSTEM NOTICE: SAVE BUTTON PRESSED ---")
	
	# [.. keep your existing row collection loops here untouched ..]
	for row in vbox_ff.get_children():
		if row.has_meta("field_label"):
			var label_name: String = row.get_meta("field_label")
			var type_flag: int = row.get_meta("data_type")
			var input_node := row.get_node("InputBox") as LineEdit
			var typed_value: String = input_node.text
			
			if type_flag == 0:
				var idx = G.govRegDTFields.find(label_name)
				if idx != -1: G.govRegDT[idx] = typed_value
			else:
				var idx = G.govRegIFields.find(label_name)
				if idx != -1: G.govRegI[idx] = int(typed_value) if typed_value.is_valid_int() else 0
				
	# Push configurations directly into your updated Global file pipeline
	G.firstRun = 1
	G.save_data_to_browser()
	
	# --- SAFE TIMING LAYER ---
	# Wait exactly 0.25 seconds to guarantee the browser finished writing data strings
	# onto your physical disk block before we clean up or hide the layout panels!
	await get_tree().create_timer(0.25).timeout
	
	print("Data committed safely. Initializing verification grid views...")
	complete_initial_setup()


# VALIDATION FILTER ROUTINE [Tech Support Skill]
func _enforce_numeric_only_typing(target_line_edit: LineEdit, current_string: String) -> void:
	var regex := RegEx.new()
	regex.compile("[^0-9.]") 
	
	if regex.search(current_string):
		var caret_pos := target_line_edit.caret_column
		target_line_edit.text = regex.sub(current_string, "", true)
		target_line_edit.caret_column = clampi(caret_pos - 1, 0, target_line_edit.text.length())

func _delete_field_by_metadata(row_node: HBoxContainer) -> void:
	var label_text: String = row_node.get_meta("field_label")
	var type_flag: int = row_node.get_meta("data_type")    
	
	if type_flag == 0:
		var sub_index = G.govRegDTFields.find(label_text)
		if sub_index != -1:
			G.govRegDT.remove_at(sub_index)
			G.govRegDTFields.remove_at(sub_index)
	else:
		var sub_index = G.govRegIFields.find(label_text)
		if sub_index != -1:
			G.govRegI.remove_at(sub_index)
			G.govRegIFields.remove_at(sub_index)
			
	var pair_index = G.govRegEIDPairs.find(type_flag)
	if pair_index != -1:
		G.govRegEIDPairs.remove_at(pair_index)

	row_node.queue_free()

func _System_Parameters_Init() -> void:
	# Clear out any stale entries in the output container before building layout rows
	for child in vbox_ff_out_gov.get_children():
		child.queue_free()
		
	var string_index_tracker: int = 0
	var integer_index_tracker: int = 0
	
	# Reconstruct fields chronologically based on setup arrays matching values
	for target_type_flag in G.govRegEIDPairs:
		var row_hbox := HBoxContainer.new()
		var dynamic_label_name: String = ""
		var dynamic_saved_value: String = ""
		
		if target_type_flag == 0:
			if string_index_tracker < G.govRegDTFields.size():
				dynamic_label_name = G.govRegDTFields[string_index_tracker]
				dynamic_saved_value = G.govRegDT[string_index_tracker]
				string_index_tracker += 1
		else:
			if integer_index_tracker < G.govRegIFields.size():
				dynamic_label_name = G.govRegIFields[integer_index_tracker]
				dynamic_saved_value = str(G.govRegI[integer_index_tracker])
				integer_index_tracker += 1
				
		if dynamic_label_name != "":
			var lbl_desc := Label.new()
			lbl_desc.text = dynamic_label_name + ": "
			lbl_desc.custom_minimum_size.x = 200
			
			var lbl_val := Label.new()
			lbl_val.text = "[" + dynamic_saved_value + "]"
			lbl_val.add_theme_color_override("font_color", Color.GREEN) # Styled for the hacker look
			
			row_hbox.add_child(lbl_desc)
			row_hbox.add_child(lbl_val)
			vbox_ff_out_gov.add_child(row_hbox)

	# Context/Visibility updates
	detect_first.text = "You are seeing this Screen to Verify that what you inputted before was saved to your browser's cache."
	initialize_sys.text = "This is just a test, if you happened to input actually identifying information,\nfeel free to clear this site's cache at least to delete it."
	if detect_first.visible == false: detect_first.show()
	if initialize_sys.visible == false: initialize_sys.show()
	# Clear out inputs configuration workflows layout elements out of view
	if nBTN3.visible == true: nBTN3.hide()
	if yBTN3.visible == true: yBTN3.hide()
	if gov_reg_save.visible == true: gov_reg_save.hide()
	if HBC1.visible == true: HBC1.hide()
	if inputBox.visible == true: inputBox.hide()
	if vbox_ff.visible == true: vbox_ff.hide()
	# Show verification list view panel
	if vbox_ff_out_gov.visible == false: vbox_ff_out_gov.show()
