from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database.database import get_db
from utils.jwt_utils import decode_token
from models.user import User, UserRole

security = HTTPBearer()

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_db)
) -> User:
    token = credentials.credentials
    payload = decode_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Do not accept refresh tokens as access tokens
    if payload.get("refresh"):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Cannot use refresh token as access token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user_id = payload.get("user_id")
    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    stmt = select(User).where(User.id == int(user_id))
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()
    
    if user is None or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found or inactive",
        )
    return user

async def require_any(current_user: User = Depends(get_current_user)) -> User:
    """Dependency that requires any active logged-in user (manager or employee)."""
    return current_user

async def require_manager(current_user: User = Depends(get_current_user)) -> User:
    """Dependency that strictly requires manager role."""
    if current_user.role != UserRole.manager:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Manager privileges required"
        )
    return current_user

async def require_employee(current_user: User = Depends(get_current_user)) -> User:
    """Dependency for endpoints specifically requiring employee scope. Any active user allows it here."""
    return current_user
