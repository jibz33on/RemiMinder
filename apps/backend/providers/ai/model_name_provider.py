import os


def get_model_name() -> str:
    model_name = os.getenv("MODEL_NAME")
    if not model_name:
        raise RuntimeError("MODEL_NAME not set")
    return model_name
