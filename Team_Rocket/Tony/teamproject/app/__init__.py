import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager
from config import Config

# Define the static folder path
static_folder = os.path.join(os.getcwd(), 'static')

# Create a Flask app instance
app = Flask(__name__, static_url_path='/static', static_folder=static_folder)
app.config.from_object(Config)
app.secret_key = '123456789'

# Initialize SQLAlchemy and Migrate extensions
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Initialize Flask-Login
login_manager = LoginManager()
login_manager.login_view = 'login'  # Specify the login view route name
login_manager.init_app(app)

# Define the user loader function
from app.models import User  # Import your User model
@login_manager.user_loader
def load_user(user_id):
    # This function is used to load a user from the database based on their user ID
    return User.query.get(int(user_id))

# This line imports the routes you've defined in routes.py
from app import routes

