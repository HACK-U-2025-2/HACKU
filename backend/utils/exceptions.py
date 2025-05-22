from fastapi import HTTPException, status


def raise_if_none(value, value_name: str):
    if value is None:
        detail = value_name + " not found"
        raise HTTPException(status_code=404, detail=detail)
