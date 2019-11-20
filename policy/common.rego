package common

list_contains_value(list, item) {
	list_item = list[_]
	list_item == item
}

else = false {
    true # It will return false unconditionally, if previous function (lines 3-6 is not true)
}

object_contains_key(object, item) {
    _ = object[key]
    key = item
}

else = false {

    true # It will return false unconditionally, if previous function (lines 3-6 is not true)
}
