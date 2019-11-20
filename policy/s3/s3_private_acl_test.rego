package policy.s3.private_acl

import input as tfplan

# ---------------------------------------------------------------------------------------------------------------------
# Standard test cases
# ---------------------------------------------------------------------------------------------------------------------
test_one_s3_bucket_acl_private {
	insecure_resources == set() with tfplan as {"aws_s3_bucket.test_bucket": {
		"attributes": {
			"acl": "private",
			"bucket": "test_bucket",
			"force_destroy": "false",
			"server_side_encryption_configuration.#": "1",
			"server_side_encryption_configuration.0.rule.#": "1",
			"server_side_encryption_configuration.0.rule.0.apply_server_side_encryption_by_default.#": "1",
			"server_side_encryption_configuration.0.rule.0.apply_server_side_encryption_by_default.0.kms_master_key_id": "test_kms_key",
			"server_side_encryption_configuration.0.rule.0.apply_server_side_encryption_by_default.0.sse_algorithm": "aws:kms",
		},
		"name": "test_bucket",
		"resourceType": "aws_s3_bucket",
		"requiresNew": true,
		"willBeDestroyed": false,
	}}
}

test_one_s3_bucket_acl_public {
	insecure_resources == {"test_bucket"} with tfplan as {"aws_s3_bucket.test_bucket": {
		"attributes": {
			"acl": "public",
			"bucket": "test_bucket",
			"force_destroy": "false",
		},
		"name": "test_bucket",
		"resourceType": "aws_s3_bucket",
		"requiresNew": true,
		"willBeDestroyed": false,
	}}
}

# ---------------------------------------------------------------------------------------------------------------------
# Exception test cases
# ---------------------------------------------------------------------------------------------------------------------

test_exception_s3_bucket_acl_public_deny_no_matches {
	insecure_resources == {"test_bucket"} with tfplan as {
		"aws_s3_bucket.test_bucket": {
			"attributes": {
				"acl": "public",
				"bucket": "test_bucket",
				"force_destroy": "false",
			},
			"name": "test_bucket",
			"resourceType": "aws_s3_bucket",
			"requiresNew": true,
			"willBeDestroyed": false,
		},
		# It will deny this because the values for the environment variables below are NOT present in the `policy/exceptions/s3.yaml` file under the s3.private_acl space
		"TF_PIPELINE_ENV_VARS": {
			"COMPANY_SERVICE": "bad-service",
			"ACCOUNT_ID": "123456789012",
		},
	}
}

# Notice how only one of these matches are legitimate:
# COMPANY_SERVICE only has "example-pass" as legitimate, which does NOT match the value below.
# ACCOUNT_ID only lists "987654321012", which DOES match the value below
test_exception_s3_bucket_acl_public_allow_match_workspace_only {
	insecure_resources == set() with tfplan as {
		"aws_s3_bucket.test_bucket": {
			"attributes": {
				"acl": "public",
				"bucket": "test_bucket",
				"force_destroy": "false",
			},
			"name": "test_bucket",
			"resourceType": "aws_s3_bucket",
			"requiresNew": true,
			"willBeDestroyed": false,
		},
		# It will allow it because `kinnaird` IS present in the `policy/exceptions/s3.yaml` file under the s3.private_acl space
		"TF_PIPELINE_ENV_VARS": {
			"COMPANY_SERVICE": "kinnaird",
			"ACCOUNT_ID": "987654321012",
		},
	}
}

# Notice how only one of these matches are legitimate:
# COMPANY_SERVICE only has "example-pass" as legitimate, which does NOT match the value below.
# ACCOUNT_ID only lists "987654321012", which DOES match the value below
test_exception_s3_bucket_acl_public_allow_match_service_only {
	insecure_resources == set() with tfplan as {
		"aws_s3_bucket.test_bucket": {
			"attributes": {
				"acl": "public",
				"bucket": "test_bucket",
				"force_destroy": "false",
			},
			"name": "test_bucket",
			"resourceType": "aws_s3_bucket",
			"requiresNew": true,
			"willBeDestroyed": false,
		},
		# It will allow it because `kinnaird` IS present in the `policy/exceptions/s3.yaml` file under the s3.private_acl space
		"TF_PIPELINE_ENV_VARS": {
			"COMPANY_SERVICE": "example-pass",
			"ACCOUNT_ID": "123456789012",
		},
	}
}
