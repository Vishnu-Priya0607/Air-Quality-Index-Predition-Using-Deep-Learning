from flask import Flask, request, jsonify
import pandas as pd 
import numpy as np
import requests
import pickle
from datetime import datetime
import jsonpickle


app = Flask(__name__)


@app.route("/api", methods=["GET"])
def returnAscii():
    d = {}
    inputchr = str(request.args["query"])
    latitude = str(inputchr).split('|')[0]
    longitude = str(inputchr).split('|')[1]
    print(latitude)
    print(longitude)

    API_URL = f"http://api.weatherapi.com/v1/current.json?key=ef67efc7ab6d48cd89540707230204&q={latitude},{longitude}&aqi=no"
    print(API_URL)
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid=168f350bf1717adf4a0541d23934e2c1"
    forecast = f"http://api.openweathermap.org/data/2.5/forecast?lat={latitude}&lon={longitude}&appid=168f350bf1717adf4a0541d23934e2c1"
    response = requests.get(API_URL)
    response2 = requests.get(url)
    url = f"https://api.opencagedata.com/geocode/v1/json?q={latitude}+{longitude}&key=824a808fa0d149cd83a79c888eff5d9e"
    responseP = requests.get(url).json()
    place_nameP = responseP['results'][0]['formatted']
    place_na = str(place_nameP).split(',')
    print(place_na)
    city = place_na[2].split('-')[0]
    forecastresponse = requests.get(forecast)

    if response.status_code != 404 and response2.status_code != 404 and forecastresponse.status_code != 404:
        data = response.json()
        data2 = response2.json()
        forecastdata = forecastresponse.json()
        # city = data['location']['name']
        temperature = data["current"]["temp_c"]
        temp_min = data2["main"]["temp_min"] - 273.15
        climate = data2["weather"][0]['description']
        temp_max = data2["main"]["temp_max"]- 273.15
        humidity = data["current"]["humidity"]
        rainfall = data["current"]["precip_mm"]
        visibility = data["current"]["vis_km"]
        windspeed_min = data["current"]["wind_kph"]
        windspeed_max = data["current"]["wind_kph"]
        if climate=='few clouds':
            icon='clouds'
        elif climate=='scattered clouds':
            icon='clouds'
        else:
            icon='clouds'


        # Tomorrow
        temperature2 = forecastdata["list"][0]["main"]["temp"] - 273.15
        temp_min2 = forecastdata["list"][0]["main"]["temp_min"] - 273.15
        temp_max2 = forecastdata["list"][0]["main"]["temp_max"]- 273.15
        humidity2 = forecastdata["list"][0]["main"]["humidity"]
        MAX_ATTEMPTS = 5
        attempts = 0
        rainfall2 = 0
        while attempts < MAX_ATTEMPTS:
            try:
                rainfall2 = forecastdata["list"][attempts]["rain"]["3h"]
                break  
            except (KeyError, IndexError):
                attempts += 1
        if rainfall2 == 0:
            rainfall2 = 0
        rainfall2 = 0
        visibility2 = forecastdata["list"][0]["visibility"]
        windspeed_min2 = forecastdata["list"][0]["wind"]["speed"]
        windspeed_max2 = forecastdata["list"][0]["wind"]["speed"]
        
        # Tomorrow
        temperature3 = forecastdata["list"][8]["main"]["temp"] - 273.15
        temp_min3 = forecastdata["list"][8]["main"]["temp_min"] - 273.15
        temp_max3 = forecastdata["list"][8]["main"]["temp_max"]- 273.15
        humidity3 = forecastdata["list"][8]["main"]["humidity"]
        MAX_ATTEMPTS = 12
        attempts = 8
        rainfall3 = 0
        while attempts < MAX_ATTEMPTS:
            try:
                rainfall3 = forecastdata["list"][attempts]["rain"]["3h"]
                break  
            except (KeyError, IndexError):
                attempts += 1
        if rainfall3 == 0:
            rainfall3 = 0
        visibility3 = forecastdata["list"][8]["visibility"]
        windspeed_min3 = forecastdata["list"][8]["wind"]["speed"]
        windspeed_max3 = forecastdata["list"][8]["wind"]["speed"]

        # Tomorrow
        temperature4 = forecastdata["list"][16]["main"]["temp"] - 273.15
        temp_min4 = forecastdata["list"][16]["main"]["temp_min"] - 273.15
        temp_max4 = forecastdata["list"][16]["main"]["temp_max"]- 273.15
        humidity4 = forecastdata["list"][16]["main"]["humidity"]
        MAX_ATTEMPTS = 20
        attempts = 16
        rainfall4 = 0
        while attempts < MAX_ATTEMPTS:
            try:
                rainfall4 = forecastdata["list"][attempts]["rain"]["3h"]
                break  
            except (KeyError, IndexError):
                attempts += 1
        if rainfall4 == 0:
            rainfall4 = 0
        visibility4 = forecastdata["list"][16]["visibility"]
        windspeed_min4 = forecastdata["list"][16]["wind"]["speed"]
        windspeed_max4 = forecastdata["list"][16]["wind"]["speed"]

        # Tomorrow
        temperature5 = forecastdata["list"][24]["main"]["temp"] - 273.15
        temp_min5 = forecastdata["list"][24]["main"]["temp_min"] - 273.15
        temp_max5 = forecastdata["list"][24]["main"]["temp_max"]- 273.15
        humidity5 = forecastdata["list"][24]["main"]["humidity"]
        MAX_ATTEMPTS = 28
        attempts = 24
        rainfall5 = 0
        while attempts < MAX_ATTEMPTS:
            try:
                rainfall5 = forecastdata["list"][attempts]["rain"]["3h"]
                break  
            except (KeyError, IndexError):
                attempts += 1
        if rainfall5 == 0:
            rainfall5 = 0
        visibility5 = forecastdata["list"][24]["visibility"]
        windspeed_min5 = forecastdata["list"][24]["wind"]["speed"]
        windspeed_max5 = forecastdata["list"][24]["wind"]["speed"]
        


    # load the model from disk
    loaded_model=pickle.load(open('random_forest_regression_model1.pkl', 'rb'))


    def make_prediction(loaded_model, T, TM, Tm, H, PP, VV, V, VM):
        input_data = np.array([T, TM, Tm, H, PP, VV, V, VM]).reshape(1, -1)
        prediction = loaded_model.predict(input_data)
        return prediction.tolist()

    with open('random_forest_regression_model1.pkl', 'rb') as f:
        loaded_model = pickle.load(f)

   
    prediction2 = make_prediction(loaded_model, temperature2, temp_min2, temp_max2,humidity2, rainfall2 if 'rainfall2' in locals() and rainfall2 is not None else 0, visibility2, windspeed_min2, windspeed_max2)
    prediction3 = make_prediction(loaded_model, temperature3, temp_min3, temp_max3,humidity3, rainfall3 if 'rainfall2' in locals() and rainfall3 is not None else 0, visibility3, windspeed_min3, windspeed_max3)
    prediction4 = make_prediction(loaded_model, temperature4, temp_min4, temp_max4,humidity4, rainfall4 if 'rainfall2' in locals() and rainfall4 is not None else 0, visibility4, windspeed_min4, windspeed_max4)
    prediction5 = make_prediction(loaded_model, temperature5, temp_min5, temp_max5,humidity5, rainfall5 if 'rainfall2' in locals() and rainfall5 is not None else 0, visibility5, windspeed_min5, windspeed_max5)

    x = [prediction2, prediction3, prediction4, prediction5,city]
    return jsonpickle.encode(x)

if __name__ == "main":
    app.run()
