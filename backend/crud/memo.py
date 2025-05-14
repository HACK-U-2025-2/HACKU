from datetime import datetime

from schemas.memo import ExaResponse


def exaRet():
    return ExaResponse(name="example_test", viewed_at=datetime.now())
