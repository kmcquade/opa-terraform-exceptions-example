#!/usr/bin/env python3

import json
import os

env_vars = [
    'COMPANY_SERVICE', 
    'ACCOUNT_ID'
]

env_vars_map = {"TF_PIPELINE_ENV_VARS": {}}

for i in env_vars:
    if os.getenv(i):
        env_vars_map["TF_PIPELINE_ENV_VARS"][i] = os.getenv(i)

print(json.dumps(env_vars_map))