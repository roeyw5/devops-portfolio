from flask import Blueprint, request, render_template, jsonify, current_app as app
from .helpers import form_handler, get_weather_data

main_bp = Blueprint('main', __name__)

# Log incoming requests
@main_bp.before_app_request
def log_request_info():
    app.logger.info(f"Request: {request.method} {request.url} Headers: {request.headers} Body: {request.get_data()}")

# Log responses
@main_bp.after_app_request
def log_response_info(response):
    app.logger.info(f"Response: {response.status} Headers: {response.headers}")
    return response

@main_bp.route('/')
def index():
    app.logger.info("Rendering main page")
    added_locations = list(app.locations_collection.find({"type": "favorite"}))
    last_searched = list(app.searches_collection.find().sort("_id", -1).limit(5))
    all_previous_searches = list(app.searches_collection.find())
    return render_template('index.html', added_locations=added_locations, last_searched=last_searched, all_previous_searches=all_previous_searches)

@main_bp.route('/', methods=["POST"])
def requests_handler():
    app.logger.info("Handling form submission")
    location_data, location_display, error_message = form_handler(request.form)

    if location_display:
        if not app.searches_collection.find_one({"name": location_display}):
            app.searches_collection.insert_one({"name": location_display})

    return update_page(location_display, location_data, error_message)

@main_bp.route('/favorites', methods=["POST"])
def add_favorite():
    app.logger.info("Adding favorite location")
    location_name = request.form.get('location_name')
    if not app.locations_collection.find_one({"name": location_name, "type": "favorite"}):
        app.locations_collection.insert_one({"name": location_name, "type": "favorite"})

    location_data = get_weather_data(location_name)
    if location_data:
        return update_page(location_name, location_data, error_message=None)
    else:
        return update_page(location_name, None, error_message="Could not fetch weather data for this location.")

@main_bp.route('/favorites/<location_name>', methods=["DELETE"])
def remove_favorite(location_name):
    app.logger.info("Removing favorite location")
    app.locations_collection.delete_one({"name": location_name, "type": "favorite"})
    return '', 204

@main_bp.route('/favorites/<location_name>', methods=["PUT"])
def rename_favorite(location_name):
    app.logger.info("Renaming favorite location")
    new_name = request.form.get('new_name')
    app.locations_collection.update_one(
        {"name": location_name, "type": "favorite"},
        {"$set": {"name": new_name}}
    )
    return '', 204

@main_bp.route('/favorites')
def favorites():
    app.logger.info("Displaying favorite locations")
    locations = list(app.locations_collection.find({"type": "favorite"}))
    return render_template('favorites.html', locations=locations)

@main_bp.route('/location/<location_name>')
def show_location(location_name):
    app.logger.info("Showing location: %s", location_name)
    location_data = get_weather_data(location_name)
    if location_data:
        return update_page(location_name, location_data, error_message=None)
    else:
        return update_page(location_name, None, error_message="Could not fetch weather data for this location.")

@main_bp.route('/locations', methods=["GET"])
def get_locations():
    app.logger.info("Getting all previous searches")
    all_previous_searches = list(app.searches_collection.find())
    return jsonify([search['name'] for search in all_previous_searches]), 200

# Readiness probe
@main_bp.route('/ready', methods=['GET'])
def ready():
    app.logger.info('Readiness Probe route accessed')
    return jsonify({'message': 'App is ready!'})

def update_page(location_name, weather_data, error_message=None):
    added_locations = list(app.locations_collection.find({"type": "favorite"}))
    last_searched = list(app.searches_collection.find().sort("_id", -1).limit(5))
    all_previous_searches = list(app.searches_collection.find())
    return render_template(
        'index.html',
        locationName=location_name,
        data=weather_data,
        error_message=error_message,
        added_locations=added_locations,
        last_searched=last_searched,
        all_previous_searches=all_previous_searches
    )
