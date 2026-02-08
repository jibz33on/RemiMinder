from abc import ABC, abstractmethod
from typing import Any


class LoggerPort(ABC):
    @abstractmethod
    def debug(self, message: str, *args: Any, **kwargs: Any) -> None: ...

    @abstractmethod
    def info(self, message: str, *args: Any, **kwargs: Any) -> None: ...

    @abstractmethod
    def warning(self, message: str, *args: Any, **kwargs: Any) -> None: ...

    @abstractmethod
    def error(self, message: str, *args: Any, **kwargs: Any) -> None: ...

    @abstractmethod
    def exception(self, message: str, *args: Any, **kwargs: Any) -> None: ...


class _NullLogger(LoggerPort):
    def debug(self, message: str, *args: Any, **kwargs: Any) -> None:
        pass

    def info(self, message: str, *args: Any, **kwargs: Any) -> None:
        pass

    def warning(self, message: str, *args: Any, **kwargs: Any) -> None:
        pass

    def error(self, message: str, *args: Any, **kwargs: Any) -> None:
        pass

    def exception(self, message: str, *args: Any, **kwargs: Any) -> None:
        pass


_logger: LoggerPort = _NullLogger()


def set_logger(logger: LoggerPort) -> None:
    global _logger
    _logger = logger


def get_logger() -> LoggerPort:
    return _logger
