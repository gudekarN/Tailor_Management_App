"""
Receipts router — generate and serve PDF receipts.
"""
import os
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession

from database.database import get_db
from models.user import User
from core.dependencies import require_any
from utils.pdf_generator import generate_receipt_pdf, RECEIPTS_DIR

router = APIRouter()


@router.get("/{order_id}/pdf")
async def get_receipt_pdf(
    order_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    Return an existing PDF if already generated, otherwise generate it on-the-fly.
    """
    file_path = os.path.join(RECEIPTS_DIR, f"receipt_{order_id}.pdf")

    if not os.path.exists(file_path):
        try:
            file_path = await generate_receipt_pdf(order_id=order_id, db=db)
        except ValueError as exc:
            raise HTTPException(status_code=404, detail=str(exc))

    return FileResponse(
        path=file_path,
        media_type="application/pdf",
        filename=f"receipt_{order_id}.pdf",
    )
