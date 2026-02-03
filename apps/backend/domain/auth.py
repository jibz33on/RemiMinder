from domain.ports import auth as auth_port


def get_current_user(*args, **kwargs):
    return auth_port.get_current_user(*args, **kwargs)


def get_current_user_jwt(*args, **kwargs):
    return auth_port.get_current_user_jwt(*args, **kwargs)
