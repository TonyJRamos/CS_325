import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'hard_to_guess_string'
    
    # Connect to the MySQL database using provided credentials
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or 'mysql+pymysql://root:Meee6333@localhost/online_order_system'
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
