# sagemaker-training toolkit and SIGTERM handling

## Introduction & thought process

Being able to handle SIGTERM gracefully seems to be a key concept in recovering from SPOT instance failure on AWS as termination seems to be a two-step process:

1. 120 seconds before spot termination, a SIGTERM is sent to the container
2. If container not finished after 120s grace period, docker kill terminates forcefully

Code that hooks onto the SIGTERM signal can perform final steps such as writing out a final checkpoint

## Problem

When using an entry-point shell script with sagemaker-training-toolkit the container does not seem to pass the SIGTERM signal down to the user script, preventing from making use of graceful shutdown logic (e.g. provided by pytorch lightning project).

## Example

```bash
git clone --recurse-submodules https://github.com/croth1/sagemaker-toolkit-sigterm-handling.git
conda env create -f env.yml
conda activate sagemaker-test
bash build_containers.sh

# original code - gets killed without running SIGTERM handler
SAGEMAKER_ROLE="arn:aws:iam::xxxxx:role/yyyyy" python run_sagemaker.py
docker kill -TERM <container-id>

# SIGTERM-aware code - exits gracefully due to SIGTERM handling
SAGEMAKER_ROLE="arn:aws:iam::xxxxx:role/yyyyy" SIGTERM_AWARE=1 python run_sagemaker.py
docker kill -TERM <container-id>
```
