from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from config import Config

app = Flask(__name__)
app.config.from_object(Config)

# Initialize SQLAlchemy and Migrate extensions
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# This line imports the routes you've defined in routes.py
from app import routes
