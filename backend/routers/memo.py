from crud.memo import *
from fastapi import APIRouter
from schemas.memo import ExaResponse
from starlette import status

router = APIRouter(tags=["Memos"])


@router.get("/", response_model=ExaResponse, status_code=status.HTTP_200_OK)
async def read_root():
    return exaRet()
