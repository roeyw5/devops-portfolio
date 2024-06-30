from flask import Flask, request, render_template, jsonify
import os
from pymongo import MongoClient
import helpers 
from prometheus_flask_exporter import PrometheusMetrics
import logging
from logging.handlers import RotatingFileHandler

app = Flask(__name__, static_url_path='/static', static_folder='static')

# MongoDB connection using environment variables
mongo_uri = os.getenv('MONGO_URI')

# Init MongoDB client and collections
client = MongoClient(mongo_uri)
db = client.get_database()
locations_collection = db.locations
searches_collection = db.searches

# Init Prometheus metrics exporter
metrics = PrometheusMetrics(app)
metrics.info('app_info', 'Application info', version='1.0.3')

# Set up logging
file_handler = RotatingFileHandler('weather.log', maxBytes=10240, backupCount=10)
file_handler.setLevel(logging.INFO)
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
file_handler.setFormatter(formatter)
app.logger.addHandler(file_handler)
app.logger.setLevel(logging.INFO)

# Log incoming requests
@app.before_request
def log_request_info():
    app.logger.info(f"Request: {request.method} {request.url} Headers: {request.headers} Body: {request.get_data()}")

# Log responses
@app.after_request
def log_response_info(response):
    app.logger.info(f"Response: {response.status} Headers: {response.headers}")
    return response

@app.route('/')
def index():
    """
    Renders the main page of the weather forecast app.
    """
    app.logger.info("Rendering main page")
    added_locations = list(locations_collection.find({"type": "favorite"}))
    last_searched = list(searches_collection.find().sort("_id", -1).limit(5))
    all_previous_searches = list(searches_collection.find())
    return render_template('index.html', added_locations=added_locations, last_searched=last_searched, all_previous_searches=all_previous_searches)

@app.route('/', methods=["POST"])
def requests_handler():
    """
    Handles form submissions for weather data retrieval.
    """
    app.logger.info("Handling form submission")
    location_data, location_display, error_message = helpers.form_handler(request.form)

    if location_display:
        if not searches_collection.find_one({"name": location_display}):
            searches_collection.insert_one({"name": location_display})

    return update_page(location_display, location_data, error_message)

@app.route('/favorites', methods=["POST"])
def add_favorite():
    """
    Handles adding a location to the user's saved locations and displays the weather information.
    """
    app.logger.info("Adding favorite location")
    location_name = request.form.get('location_name')
    if not locations_collection.find_one({"name": location_name, "type": "favorite"}):
        locations_collection.insert_one({"name": location_name, "type": "favorite"})

    location_data = helpers.get_weather_data(location_name)
    if location_data:
        return update_page(location_name, location_data, error_message=None)
    else:
        return update_page(location_name, None, error_message="Could not fetch weather data for this location.")

@app.route('/favorites/<location_name>', methods=["DELETE"])
def remove_favorite(location_name):
    """
    Handles removing a location from the user's saved locations.
    """
    app.logger.info("Removing favorite location")   
    locations_collection.delete_one({"name": location_name, "type": "favorite"})
    return '', 204

@app.route('/favorites/<location_name>', methods=["PUT"])
def rename_favorite(location_name):
    """
    Handles renaming a location in the user's saved locations.
    """
    app.logger.info("Renaming favorite location")
    new_name = request.form.get('new_name')
    locations_collection.update_one(
        {"name": location_name, "type": "favorite"},
        {"$set": {"name": new_name}}
    )
    return '', 204

@app.route('/favorites')
def favorites():
    """
    Displays the user's saved locations.
    """
    app.logger.info("Displaying favorite locations")
    locations = list(locations_collection.find({"type": "favorite"}))
    return render_template('favorites.html', locations=locations)

@app.route('/location/<location_name>')
def show_location(location_name):
    """
    Displays the weather information for a specific location.
    """
    app.logger.info("Showing location: %s", location_name)
    location_data = helpers.get_weather_data(location_name)
    if location_data:
        return update_page(location_name, location_data, error_message=None)
    else:
        return update_page(location_name, None, error_message="Could not fetch weather data for this location.")

@app.route('/locations', methods=["GET"])
def get_locations():
    """
    Returns a list of all previous searches.
    """
    app.logger.info("Getting all previous searches")
    all_previous_searches = list(searches_collection.find())
    return jsonify([search['name'] for search in all_previous_searches]), 200

# Readiness probe
@app.route('/ready', methods=['GET'])
def ready():
    app.logger.info('Readiness Probe route accessed')
    return jsonify({'message': 'App is ready!'})

def update_page(location_name, weather_data, error_message=None):
    """
    Renders the HTML template with updated weather data and information.
    """
    added_locations = list(locations_collection.find({"type": "favorite"}))
    last_searched = list(searches_collection.find().sort("_id", -1).limit(5))
    all_previous_searches = list(searches_collection.find())
    return render_template(
        'index.html',
        locationName=location_name,
        data=weather_data,
        error_message=error_message,
        added_locations=added_locations,
        last_searched=last_searched,
        all_previous_searches=all_previous_searches
    )


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=False)
