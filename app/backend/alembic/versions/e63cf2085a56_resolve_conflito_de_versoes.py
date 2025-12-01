"""Resolve conflito de versoes

Revision ID: e63cf2085a56
Revises: 9e963e794566, a353620c9826
Create Date: 2025-12-01 20:13:17.766010

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e63cf2085a56'
down_revision: Union[str, Sequence[str], None] = ('9e963e794566', 'a353620c9826')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass
