"""Reset base

Revision ID: 442bd9419299
Revises: 00ae4b6890fb
Create Date: 2025-05-27 14:24:43.378404

"""

from typing import Sequence, Union

import pgvector
import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "442bd9419299"
down_revision: Union[str, None] = "00ae4b6890fb"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
