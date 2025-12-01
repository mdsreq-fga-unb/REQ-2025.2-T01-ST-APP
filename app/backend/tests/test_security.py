from app.security import verify_password, get_password_hash

def test_password_hashing():
    senha = "minhasenha123"
    hash_senha = get_password_hash(senha)
    
    assert verify_password(senha, hash_senha) is True
    assert verify_password("senhaerrada", hash_senha) is False
