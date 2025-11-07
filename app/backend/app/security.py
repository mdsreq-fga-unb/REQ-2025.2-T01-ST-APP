from datetime import datetime, timedelta, timezone
from passlib.context import CryptContext
from jose import JWTError, jwt
from .config import settings


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_password(plain_password: str, hashed_password: str) -> bool:

    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)



def create_access_token(data: dict,  expires_delta: timedelta | None = None) -> str:

    to_encode = data.copy()

    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)


    to_encode.update({"exp":expire})


    encode_jwt = jwt.encode(
            to_encode,
            settings.SECRET_KEY,
            algorithm=settings.ALGORITHM
            )

    return encode_jwt



def decode_token(token: str) -> dict | None:

    try:
        payload = jwt.decode(
                token, 
                settings.SECRET_KEY,
                algorithms=[settings.ALGORITHM]
                )
        return payload

    except JWTError:
        return None 
        



