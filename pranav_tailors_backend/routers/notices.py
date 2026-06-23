from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List

from database.database import get_db
from models.user import User
from models.notice import Notice
from core.dependencies import require_manager, require_any
from schemas.notice_schemas import NoticeCreate, NoticeResponse

router = APIRouter()

@router.post("", response_model=NoticeResponse)
async def create_notice(
    req: NoticeCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    notice = Notice(
        title=req.title,
        message=req.message,
        created_by=current_user.id
    )
    db.add(notice)
    await db.commit()
    await db.refresh(notice)
    return notice

@router.get("", response_model=List[NoticeResponse])
async def list_notices(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(Notice).where(Notice.is_active == True).order_by(Notice.created_at.desc())
    res = await db.execute(stmt)
    return res.scalars().all()

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_notice(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    stmt = select(Notice).where(Notice.id == id)
    res = await db.execute(stmt)
    notice = res.scalar_one_or_none()
    if not notice:
        raise HTTPException(status_code=404, detail="Notice not found")
    
    notice.is_active = False
    await db.commit()
