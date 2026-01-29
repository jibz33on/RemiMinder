class DomainError(Exception):
    """Base class for domain-level errors."""
    status_code = 500

    def __init__(self, message: str, status_code: int | None = None) -> None:
        super().__init__(message)
        if status_code is not None:
            self.status_code = status_code


class NotFoundError(DomainError):
    """Resource not found."""
    status_code = 404


class PermissionDeniedError(DomainError):
    """Access forbidden or authentication missing."""
    status_code = 403


class ValidationError(DomainError):
    """Validation failed."""
    status_code = 400


class ConflictError(DomainError):
    """Conflict with current state."""
    status_code = 409


class InternalError(DomainError):
    """Unexpected internal error."""
    status_code = 500