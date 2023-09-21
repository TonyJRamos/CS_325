from app import db, create_app
from app.models import User
from werkzeug.security import generate_password_hash

app = create_app()

def hash_existing_passwords():
    with app.app_context():  # Push an application context
        users = User.query.all()
        for user in users:
            user.password = generate_password_hash(user.password)
        db.session.commit()

if __name__ == "__main__":
    hash_existing_passwords()
