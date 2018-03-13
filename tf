#!/usr/bin/env bash

set -e

terraform $@ -var-file=ecs.tfvars
