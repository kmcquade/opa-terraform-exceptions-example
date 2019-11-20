package exception_logic

import data.common
import data.exceptions

import input as tfplan

is_company_service_exception(service, rule_name) {
	common.object_contains_key(exceptions[service][rule_name], "company_service")
	common.list_contains_value(exceptions[service][rule_name].company_service, tfplan[TF_PIPELINE_ENV_VARS].COMPANY_SERVICE)
}

is_account_id_exception(service, rule_name) {
	common.object_contains_key(exceptions[service][rule_name], "account_id")
	common.list_contains_value(exceptions[service][rule_name].account_id, tfplan[TF_PIPELINE_ENV_VARS].ACCOUNT_ID)
}