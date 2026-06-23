from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from datetime import timedelta

from database.database import get_db
from models.user import User
from schemas.auth_schemas import LoginRequest, TokenResponse, RefreshRequest, UserResponse
from utils.password_utils import verify_pin
from utils.jwt_utils import create_access_token, create_refresh_token, decode_token
from core.dependencies import get_current_user

router = APIRouter()

@router.post("/login", response_model=TokenResponse)
async def login(req: LoginRequest, db: AsyncSession = Depends(get_db)):
    stmt = select(User).where(User.phone == req.phone)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid phone or PIN")
    
    if not verify_pin(req.pin, user.pin_hash):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid phone or PIN")
    
    payload = {
        "user_id": user.id,
        "role": user.role.value,
        "name": user.name
    }
    
    access_token = create_access_token(payload, timedelta(days=7))
    refresh_token = create_refresh_token(payload, timedelta(days=30))
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

@router.post("/refresh", response_model=TokenResponse)
async def refresh(req: RefreshRequest, db: AsyncSession = Depends(get_db)):
    payload = decode_token(req.refresh_token)
    if not payload or not payload.get("refresh"):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid refresh token")
    
    user_id = payload.get("user_id")
    stmt = select(User).where(User.id == int(user_id))
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User inactive or deleted")

    new_payload = {
        "user_id": user.id,
        "role": user.role.value,
        "name": user.name
    }
    
    access_token = create_access_token(new_payload, timedelta(days=7))
    refresh_token = create_refresh_token(new_payload, timedelta(days=30))
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

@router.get("/me", response_model=UserResponse)
async def get_me(current_user: User = Depends(get_current_user)):
    return current_user
