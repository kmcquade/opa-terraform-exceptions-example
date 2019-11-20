package policy.s3.private_acl

import data.exception_logic
import data.exceptions
import data.terraform.get_resources_by_type
import input as tfplan

#########
# Policy
#########

resource_types = ["aws_s3_bucket"]
insecure_resources = find_insecure_resources(resource_types)

# Creates a set of resource names failing this
find_insecure_resources(resource_types) = {resource.name |
	resources := get_resources_by_type(tfplan, resource_types)
	resource := resources[_]
	resource.attributes.acl == "public"

	# If ONE of the following is a match, this will be allowed.
	not exception_logic.is_account_id_exception("s3", "private_acl")
	not exception_logic.is_company_service_exception("s3", "private_acl")
}
