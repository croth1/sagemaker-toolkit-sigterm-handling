FROM condaforge/mambaforge:22.9.0-3 AS base

RUN mamba install gcc -y && conda clean --all -y

FROM base as orig 
COPY sagemaker-training-toolkit /tmp/sagemaker-training-toolkit
RUN pip install /tmp/sagemaker-training-toolkit


FROM base as sigterm-aware
COPY sagemaker-training-toolkit-sigterm /tmp/sagemaker-training-toolkit
RUN pip install /tmp/sagemaker-training-toolkit
