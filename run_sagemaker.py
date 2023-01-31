import os

from sagemaker.estimator import Estimator

role = os.environ["SAGEMAKER_ROLE"]
image_tag = "orig" if "SIGTERM_AWARE" not in os.environ else "sigterm-aware"
trainer = Estimator(
    entry_point="sleeper.sh",
    source_dir=".",
    image_uri=f"sagemaker_sleeper:{image_tag}",
    role=role,
    instance_type="local",
    instance_count=1,
)

trainer.fit()
