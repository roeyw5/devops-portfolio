import requests
import os
import base64

# Helper function to decode base64 environment variables
def get_env_var(key, default=None):
    value = os.getenv(key, default)
    if value:
        return base64.b64decode(value).decode('utf-8')
    return value

# Use the API details from the K8s secret
API_KEY = get_env_var('WEATHER_API_KEY')
API_URL = get_env_var('WEATHER_API_URL')

if not API_KEY or not API_URL:
    raise ValueError("Missing necessary environment variables: WEATHER_API_KEY and WEATHER_API_URL")

class CountryNotFoundError(Exception):
    """ Custom exception raised when a requested country's information cannot be found."""
    pass


def get_weather_data(location):
    """
      Fetches weather data from an external API for the given location.

      This function sends a GET request to an external weather API to retrieve weather
      data for the specified location. The API URL is constructed using the provided
      location and API key. The response is then checked for a successful status code,
      and if it's 200 (OK), the JSON data is parsed and returned. If the response status
      code is not 200, the function returns None.

      Args:
          location (str): The name of the location for which weather data is requested.

      Returns:
          dict or None: A dictionary containing weather data if the API response is successful,
                        or None if an issue occurs during API communication.
      """
    url = f"{API_URL}?city={location}&key={API_KEY}&days=7"     # Construct the API URL
    response = requests.get(url)                                # Send a GET request to the API and receive the response

    if response.status_code == 200:
        return response.json()                                  # Parse and return the JSON data from the response

    else:
        return None



def form_handler(form):
    """
    Processes the form submission and returns location data.
    """
    location = form['input_location']
    location_data = get_weather_data(location)

    if location_data:
        location_to_upper = location.title()
        error_message = None
    else:
        error_message = "City not found, please try again."
        location_to_upper = ""

    return location_data, location_to_upper, error_message
