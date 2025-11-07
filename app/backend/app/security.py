from datetime import datetime, timedelta, timezone
from passlib.context import CryptContext
from jose import JWTError, jwt
from .config import settings


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_password(plain_password: str, hashed_password: str) -> bool:

    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


<<<<<<< HEAD
def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
=======

def create_access_token(data: dict,  expires_delta: timedelta | None = None) -> str:
>>>>>>> 1db8677 (adiciona cadastro de usuarios)

    to_encode = data.copy()

    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)

<<<<<<< HEAD
    to_encode.update({"exp": expire})

    encode_jwt = jwt.encode(
        to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM
    )
=======

    to_encode.update({"exp":expire})


    encode_jwt = jwt.encode(
            to_encode,
            settings.SECRET_KEY,
            algorithm=settings.ALGORITHM
            )
>>>>>>> 1db8677 (adiciona cadastro de usuarios)

    return encode_jwt


<<<<<<< HEAD
=======

>>>>>>> 1db8677 (adiciona cadastro de usuarios)
def decode_token(token: str) -> dict | None:

    try:
        payload = jwt.decode(
<<<<<<< HEAD
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        return payload

    except JWTError:
        return None
=======
                token, 
                settings.SECRET_KEY,
                algorithms=[settings.ALGORITHM]
                )
        return payload

    except JWTError:
        return None 
        



>>>>>>> 1db8677 (adiciona cadastro de usuarios)
