import logging
from typing import Any

from domain.ports.logging import LoggerPort


class StdLogger(LoggerPort):
    def __init__(self) -> None:
        self.logger = logging.getLogger("backend")

    def debug(self, message: str, *args: Any, **kwargs):
        self.logger.debug(message, *args, extra=kwargs)

    def info(self, message: str, *args: Any, **kwargs):
        self.logger.info(message, *args, extra=kwargs)

    def warning(self, message: str, *args: Any, **kwargs):
        self.logger.warning(message, *args, extra=kwargs)

    def error(self, message: str, *args: Any, **kwargs):
        self.logger.error(message, *args, extra=kwargs)

    def exception(self, message: str, *args: Any, **kwargs):
        self.logger.exception(message, *args, extra=kwargs)
