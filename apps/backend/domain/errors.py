class DomainError(Exception):
    """Base class for domain-level errors."""


class NotFoundError(DomainError):
    """Resource not found."""


class ForbiddenError(DomainError):
    """Access forbidden."""


class ValidationError(DomainError):
    """Validation failed."""


class ConflictError(DomainError):
    """Conflict with current state."""


class UnauthorizedError(DomainError):
    """Authentication failed or missing."""


class InternalError(DomainError):
    """Unexpected internal error."""
