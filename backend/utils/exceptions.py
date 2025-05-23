from fastapi import HTTPException


class InvalidBodyException(Exception):
    pass


def raise_if_none(value, value_name: str):
    if value is None:
        raise HTTPException(status_code=404, detail=f"{value_name} not found")
