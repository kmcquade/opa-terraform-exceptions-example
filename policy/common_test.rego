package common

# ---------------------------------------------------------------------------------------------------------------------
# list_contains_value
# ---------------------------------------------------------------------------------------------------------------------
sample_list := [
		"marshall",
		"mathers",
		"haley",
		"kim",
]

test_list_contains_value_pass {
	list_contains_value(sample_list, "mathers")
}

test_list_contains_value_false {
	list_contains_value(sample_list, "biggie") == false
}

test_list_contains_value_not {
	not list_contains_value(sample_list, "biggie")
}


# ---------------------------------------------------------------------------------------------------------------------
# object_contains_keys
# Determines if an object contains a key
# ---------------------------------------------------------------------------------------------------------------------

sample_object_for_key_existence := {
  "luke": "skywalker",
  "obiwan": "kenobi"
}

# Pass example
test_object_contains_key_pass {
  object_contains_key(sample_object_for_key_existence, "luke")
}

# False example
test_object_contains_key_false {
  false == object_contains_key(sample_object_for_key_existence, "kylo")
}

# Not example
test_object_contains_key_not {
  not object_contains_key(sample_object_for_key_existence, "kylo")
}