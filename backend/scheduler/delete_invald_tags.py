from crud.tag import delete_unconnected_tags
from sqlalchemy.orm import Session


def delete_invalid_tags(db: Session):
    delete_unconnected_tags(db)
