package terraform

get_resources_by_type(tfplan, types) = [resource |
	resource = tfplan[_] # iterate over resources in tfplan
	type = types[_] # iterate over types
	resource.resourceType == type # include resource into return list if the type matches
]