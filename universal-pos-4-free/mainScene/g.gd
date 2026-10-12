# G.gd
extends Node

# Countermeasure flag: 0 = First deployment, 1 = Configured/Running
var firstRun: int = 0
var govRegD: int = 0
var firstPrompt: bool = true

# Strongly typed parallel database matrices
var govRegDT: Array[String] = []
var govRegDTFields: Array[String] = []
var govRegI: Array[int] = []
var govRegIFields: Array[String] = []
var govRegEIDPairs: Array[int] = []

const SAVE_PATH: String = "user://pos_system_config.cfg"

func _ready() -> void:
	load_data_from_browser()

# Call this whenever an admin clicks a "Save" or "Next" button in your UI step matrix
func save_data_to_browser() -> void:
	var config := ConfigFile.new()
	
	# Set your tracking states into the configuration file layout
	config.set_value("SystemState", "firstRun", firstRun)
	config.set_value("SystemState", "govRegD", govRegD)
	config.set_value("SystemState", "firstPrompt", firstPrompt)
	
	config.set_value("Registration", "govRegDT", govRegDT)
	config.set_value("Registration", "govRegDTFields", govRegDTFields)
	config.set_value("Registration", "govRegI", govRegI)
	config.set_value("Registration", "govRegIFields", govRegIFields)
	config.set_value("Registration", "govRegEIDPairs", govRegEIDPairs)
	
	# Save directly to the secure browser engine database slice
	var error := config.save(SAVE_PATH)
	if error == OK:
		print("Config pertaining to POS Settings successfully hard-baked into browser IndexedDB!")
	else:
		print("Storage write for saving POS Settings to userspace failed with code: ", error)

# Call this on startup to verify if this is a returning deployment run
func load_data_from_browser() -> void:
	var config := ConfigFile.new()
	var error := config.load(SAVE_PATH)
	
	# If the file doesn't exist yet, it means this is a true firstRun boot
	if error != OK:
		print("No configuration file detected. Initializing firstRun onboarding...")
		firstRun = 0
		return
		
	# CRITICAL CLEANUP: Wipe current RAM layers clean to prevent data double-allocation pollution
	govRegDT.clear()
	govRegDTFields.clear()
	govRegI.clear()
	govRegIFields.clear()
	govRegEIDPairs.clear()
		
	# Fallbacks are provided as the third parameter if data corruption occurs
	firstRun = config.get_value("SystemState", "firstRun", 0)
	govRegD = config.get_value("SystemState", "govRegD", 0)
	firstPrompt = config.get_value("SystemState", "firstPrompt", true)
	
	# Godot 4 strict type allocation fix: Type hints must wrap the initialization payload array directly
	var fallback_string_array: Array[String] = []
	var fallback_int_array: Array[int] = []
	
	govRegDT = config.get_value("Registration", "govRegDT", fallback_string_array)
	govRegDTFields = config.get_value("Registration", "govRegDTFields", fallback_string_array)
	govRegI = config.get_value("Registration", "govRegI", fallback_int_array)
	govRegIFields = config.get_value("Registration", "govRegIFields", fallback_string_array)
	govRegEIDPairs = config.get_value("Registration", "govRegEIDPairs", fallback_int_array)
	
	print("Loaded system successfully. Current firstRun state is: ", firstRun)
