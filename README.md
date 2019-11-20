# opa-terraform-exceptions-example

* Log in to AWS via CLI
* Install [tfjson2](https://github.com/justinm/tfjson2)
* Install [conftest](https://github.com/instrumenta/conftest)
* Install jq

### Generating Terraform plan

```bash
export COMPANY_SERVICE="kinnaird"
export ACCOUNT_ID="987654321012"
export TF_MODULE_NAME=s3-private-acl-fail
# Run terraform plan
make plan
```

This will generate the files in each test folder. The one of interest is titled `tfplan-combined.json`, which combines the environment variables of interest with the ones in the regular terraform plan file.


### 