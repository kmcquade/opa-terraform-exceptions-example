package exception_logic

import input as tfplan

tfplan_small_pass = {
  "TF_PIPELINE_ENV_VARS": {
	  "COMPANY_SERVICE": "kinnaird",
	  "ACCOUNT_ID": "987654321012",
  }
}

tfplan_small_fail = {
  "TF_PIPELINE_ENV_VARS": {
	  "COMPANY_SERVICE": "many-fails", # This will fail, since the relevant lines in exceptions/s3.yaml only include "space" and "kinnaird", not "bad-service"
	  "ACCOUNT_ID": "123456789012", # this will fail, since the relevant lines in exceptions/s3.yaml only includes "987654321012"
  }
}

# COMPANY_SERVICE
test_is_company_service_exception_pass {
	service := "s3"
	rule_name := "private_acl"
	is_company_service_exception(service, rule_name) with tfplan as tfplan_small_pass
}

test_is_company_service_exception_fail {
	service := "s3"
	rule_name := "private_acl"
	not is_company_service_exception(service, rule_name) with tfplan as tfplan_small_fail
}

# ACCOUNT_ID
test_is_account_id_pass {
	service := "s3"
	rule_name := "private_acl"
	is_account_id_exception(service, rule_name) with tfplan as tfplan_small_pass
}

test_is_account_id_fail {
	service := "s3"
	rule_name := "private_acl"
	not is_account_id_exception(service, rule_name) with tfplan as tfplan_small_fail
}