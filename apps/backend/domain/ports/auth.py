from domain.errors import InternalError


def get_current_user_jwt(*_args, **_kwargs):
    raise InternalError("Auth dependency not configured")


def get_current_user(*_args, **_kwargs):
    raise InternalError("Auth dependency not configured")
