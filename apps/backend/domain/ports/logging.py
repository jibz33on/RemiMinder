from abc import ABC, abstractmethod
from typing import Any


class LoggerPort(ABC):
    @abstractmethod
    def info(self, message: str, **kwargs: Any) -> None: ...

    @abstractmethod
    def warning(self, message: str, **kwargs: Any) -> None: ...

    @abstractmethod
    def error(self, message: str, **kwargs: Any) -> None: ...

    @abstractmethod
    def exception(self, message: str, **kwargs: Any) -> None: ...


class _NullLogger(LoggerPort):
    def info(self, message: str, **kwargs: Any) -> None:
        return None

    def warning(self, message: str, **kwargs: Any) -> None:
        return None

    def error(self, message: str, **kwargs: Any) -> None:
        return None

    def exception(self, message: str, **kwargs: Any) -> None:
        return None


_logger: LoggerPort = _NullLogger()


def set_logger(logger: LoggerPort) -> None:
    global _logger
    _logger = logger


def get_logger() -> LoggerPort:
    return _logger
