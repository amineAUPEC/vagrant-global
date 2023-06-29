endpoint = 'http://6b5e03f5-e125-464a-a6b8-4c687e530f31.eastus.azurecontainer.io/score' #Replace with your endpoint
key = 'wvtM23LJAL8r0N32IIEVOa6syf5cX3zZ' #Replace with your key

import urllib.request
import json
import os

data = {
    "Inputs": {
        "input1":
        [
            {
                    'PatientID': 1882185,
                    'Pregnancies': 9,
                    'PlasmaGlucose': 104,
                    'DiastolicBloodPressure': 51,
                    'TricepsThickness': 7,
                    'SerumInsulin': 24,
                    'BMI': 27.36983156,
                    'DiabetesPedigree': 1.3504720469999998,
                    'Age': 43,
            },
        ],
    },
    "GlobalParameters":  {
    }
}

body = str.encode(json.dumps(data))


headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ key)}

req = urllib.request.Request(endpoint, body, headers)

try:
    response = urllib.request.urlopen(req)
    result = response.read()
    json_result = json.loads(result)
    output = json_result["Results"]["WebServiceOutput0"][0]
    print('Patient: {}\nPrediction: {}\nProbability: {:.2f}'.format(output["PatientID"],
                                                            output["DiabetesPrediction"],
                                                            output["Probability"],))
except urllib.error.HTTPError as error:
    print("The request failed with status code: " + str(error.code))

    # Print the headers to help debug
    print(error.info())
    print(json.loads(error.read().decode("utf8", 'ignore')))