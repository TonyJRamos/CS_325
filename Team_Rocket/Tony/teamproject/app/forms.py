from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, validators

class RegistrationForm(FlaskForm):
    username = StringField('Username', [validators.Length(min=4, max=25), validators.DataRequired()])
    password = PasswordField('Password', [validators.Length(min=6, max=35), validators.DataRequired()])
    submit = SubmitField('Register')