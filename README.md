# opa-terraform-exceptions-example

Showing a proposed YAML-based exceptions process for OPA policies on Terraform plans, using environment variables from a CICD pipeline as a method for specifying exception criteria.

Note: I'm still working out some kinks in this code. Right now it fails on legit policies. I will make a note here in this repo when it works. Suggestions welcome.

### Instructions

* Log in to AWS via CLI
* Install [tfjson2](https://github.com/justinm/tfjson2)
* Install [conftest](https://github.com/instrumenta/conftest)
* Install jq

### Generating Terraform plan

* Passing case
  
```bash
export COMPANY_SERVICE="kinnaird"
export ACCOUNT_ID="987654321012"
export TF_MODULE_NAME=s3-private-acl-pass
# Run terraform plan
make plan
```

This will generate the files in each test folder. The one of interest is titled `tfplan-combined.json`, which combines the environment variables of interest with the ones in the regular terraform plan file.

* Failing case

```bash
export COMPANY_SERVICE="manyfails"
export ACCOUNT_ID="123456789012"
export TF_MODULE_NAME=s3-private-acl-fail
# Run terraform plan
make plan
```

### View pass vs. Fail 

```bash
make conftest-pass
make conftest-fail
```

The output will show that the policy fails.

## Approach

Fill this in later.