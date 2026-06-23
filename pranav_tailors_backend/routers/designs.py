from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Optional
import os
import uuid

from database.database import get_db
from models.user import User
from models.design_gallery import DesignGallery, GalleryType
from core.dependencies import require_manager, require_any
from schemas.design_schemas import DesignResponse

router = APIRouter()

UPLOAD_DIR = "uploads/designs"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("", response_model=DesignResponse)
async def upload_design(
    type: str,
    file: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    if type not in [t.value for t in GalleryType]:
        raise HTTPException(status_code=400, detail="Invalid design type")
        
    file_ext = os.path.splitext(file.filename)[1]
    unique_filename = f"{uuid.uuid4().hex}{file_ext}"
    file_path = os.path.join(UPLOAD_DIR, unique_filename)
    
    with open(file_path, "wb") as buffer:
        content = await file.read()
        buffer.write(content)
        
    image_url = f"/static/designs/{unique_filename}"
    
    design = DesignGallery(
        type=GalleryType(type),
        image_url=image_url,
        uploaded_by=current_user.id
    )
    db.add(design)
    await db.commit()
    await db.refresh(design)
    return design

@router.get("", response_model=List[DesignResponse])
async def list_designs(
    type: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(DesignGallery).order_by(DesignGallery.created_at.desc())
    if type:
        stmt = stmt.where(DesignGallery.type == GalleryType(type))
    res = await db.execute(stmt)
    return res.scalars().all()

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_design(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    stmt = select(DesignGallery).where(DesignGallery.id == id)
    res = await db.execute(stmt)
    design = res.scalar_one_or_none()
    if not design:
        raise HTTPException(status_code=404, detail="Design not found")
        
    # Delete file
    filename = design.image_url.split("/")[-1]
    file_path = os.path.join(UPLOAD_DIR, filename)
    if os.path.exists(file_path):
        os.remove(file_path)
        
    await db.delete(design)
    await db.commit()
