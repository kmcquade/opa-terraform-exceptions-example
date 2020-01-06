all: fmt test

fmt:
	@opa fmt policy -w

test:
	@opa test policy -v --explain full -l

TF_MODULE_SUBFOLDER="./terraform/$(TF_MODULE_NAME)"
PLAN_FILE = plan.tfplan
SHOW_FILE = plan.json
TF_PIPELINE_ENV_VARS="tf_pipeline_env_vars.json"
TF_PLAN_COMBINED="tfplan-combined.json"
SCRIPTS_PATH=./utils/get_env_vars.json

plan:
	@pushd $(TF_MODULE_SUBFOLDER) && \
	 	terraform init && \
		pwd && \
		terraform plan -out=$(PLAN_FILE) && \
		tfjson2 --plan $(PLAN_FILE) | jq . > $(SHOW_FILE) && \
		echo "Finished tfjson2" && \
		ls -al ../../utils/
		python3 $(TF_MODULE_SUBFOLDER)/../../utils/get_env_vars.py > $(TF_MODULE_SUBFOLDER)/${TF_PIPELINE_ENV_VARS}
		jq -s '.[0] * .[1]' $(TF_MODULE_SUBFOLDER)/${TF_PIPELINE_ENV_VARS} $(TF_MODULE_SUBFOLDER)/${SHOW_FILE} > $(TF_MODULE_SUBFOLDER)/${TF_PLAN_COMBINED}

opa:
	@opa eval --data policy --input $(TF_MODULE_SUBFOLDER)/${TF_PLAN_COMBINED} --explain notes  --format=pretty "data.main"

conftest:
	@conftest test $(TF_MODULE_SUBFOLDER)/${TF_PLAN_COMBINED} -p policy
