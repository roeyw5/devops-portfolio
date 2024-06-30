import os

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev_key')
    MONGO_URI = os.getenv('MONGO_URI')
    WEATHER_API_KEY = os.getenv('WEATHER_API_KEY')
    WEATHER_API_URL = os.getenv('WEATHER_API_URL')

    if not MONGO_URI:
        raise ValueError("No MONGO_URI set for Flask application")
    if not WEATHER_API_KEY or not WEATHER_API_URL:
        raise ValueError("Missing necessary environment variables: WEATHER_API_KEY and WEATHER_API_URL")
