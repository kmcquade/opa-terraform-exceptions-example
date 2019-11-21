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

>>> Here is where I need help. For some reason, the real policy is not reading from the YAML file.

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

Our approach:

* Provision all Terraform infrastructure through a CICD pipeline
* In that CICD pipeline, environment variables are supplied to indicate various characteristics about that pipeline's deployment. For example, `COMPANY_SERVICE` AND `ACCOUNT_ID`. IRL, we have more granular environment variables than this, but we'll leave it at this for this public example.
* Exceptions requirements
  * We need to provide exceptions to rules, and have it be per-policy. 
  * Terraform developers who do not work on OPA code should be able to make pull requests to add their pipelines to an exceptions file expressed in YAML. Those Terraform developers know which environment variables to use and which values.
  * When we write a policy, we should have a uniform way of managing exceptions. So we should have ONE way of specifying exceptions when you write a policy. That is outlined below.

The nice thing about the approach outlined in this repository is that the policies don't have to actually know which account IDs, environments, service names, etc. are allowed per policy - they just know that the exceptions logic will take care of it, since the exceptions logic essentially takes things in from two sources in this code base:

1. The policy file, which feeds the **service name** and **rule name** over to the exceptions logic
2. The plan file, which contains the **Falcon environment variable values**, such as the values for `COMPANY_SERVICE`, `ACCOUNT_ID`, etc.

As a result, the exceptions folder can really be managed by anybody (doesn't have to be the devs!!! and definitely doesn't have to be someone who knows Rego). After all, the YAML File tells the exceptions logic This knows to look for `service_name`, `rule_name`, and the values for the environment variables.

...and the policy developers just have to include one two lines in their code:

```rego
import data.exception_logic
# ...then within their policy, call this function, and just specify the `service_name` and the `rule_name`
find_insecure_resources(resource_types) = {resource.name |
  # ...
  not exception_logic.is_account_id_exception("s3", "private_acl")
```

And the exception logic functions know how to evaluate the Terraform plan file for those environment variables, and read the `exceptions/service_name.yaml` file to determine whether this matches the exception criteria. 

