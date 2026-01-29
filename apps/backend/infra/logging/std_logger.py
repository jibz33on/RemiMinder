import logging

from domain.ports.logging import LoggerPort


class StdLogger(LoggerPort):
    def __init__(self) -> None:
        self.logger = logging.getLogger("backend")

    def info(self, message: str, **kwargs):
        self.logger.info(message, extra=kwargs)

    def warning(self, message: str, **kwargs):
        self.logger.warning(message, extra=kwargs)

    def error(self, message: str, **kwargs):
        self.logger.error(message, extra=kwargs)

    def exception(self, message: str, **kwargs):
        self.logger.exception(message, extra=kwargs)
