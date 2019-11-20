package main

import data.policy.s3
import data.exceptions

import input as tfplan

warn[msg] {
	count(s3.private_acl.insecure_resources) > 0
	msg := sprintf("s3_private_acl: S3 does not have private ACL set. Instances: %s", [s3.private_acl.insecure_resources])
}