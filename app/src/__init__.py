from flask import Flask
from pymongo import MongoClient
from prometheus_flask_exporter import PrometheusMetrics
import logging
from logging.handlers import RotatingFileHandler
import os
from .config import Config

def create_app():
    app = Flask(__name__, static_url_path='/static', static_folder='static')
    app.config.from_object(Config)

    # Set up MongoDB connection
    client = MongoClient(app.config['MONGO_URI'])
    app.db = client.get_database()
    app.locations_collection = app.db.locations
    app.searches_collection = app.db.searches

    # Set up Prometheus metrics exporter
    metrics = PrometheusMetrics(app)
    metrics.info('app_info', 'Application info', version='1.0.3')

    # Set up logging
    file_handler = RotatingFileHandler('weather.log', maxBytes=10240, backupCount=10)
    file_handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    app.logger.addHandler(file_handler)
    app.logger.setLevel(logging.INFO)

    # Register blueprints
    from .routes import main_bp
    app.register_blueprint(main_bp)

    return app
