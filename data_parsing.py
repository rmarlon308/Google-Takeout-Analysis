import json
import pandas as pd
import os
from datetime import datetime
import requests


url = "https://raw.githubusercontent.com/rmarlon308/google_takeout_analysis/master/2018_JULY.json"

my_data = requests.get(url).json()

#List for activities
current_activity = []
start_time = []
end_time = []
total_time = []
probability = []

#List for places
place = []
latitude = []
longitude = []

for act in my_data['timelineObjects']:
	for a in act:
		if(a == 'activitySegment'):
			try:
				for activity in act['activitySegment']['activities']:
					if(activity['probability'] >= 50): #If the probabilite is grader that 50% we take the activity
			
						startTime = int(act['activitySegment']['duration']['startTimestampMs'])/1000
						endTime = int(act['activitySegment']['duration']['endTimestampMs']) /1000
						totalTime = (endTime - startTime)/60 #En minutos


						current_activity.append(activity['activityType'])
						start_time.append(datetime.fromtimestamp(int(startTime)))
						end_time.append(datetime.fromtimestamp(int(endTime)))
						total_time.append(totalTime)
						probability.append(activity['probability'])

			except Exception as e:
				print(e)

		elif(a == 'placeVisit'):
			try:
				place.append(act['placeVisit']['location']['name'])
				latitude.append(act['placeVisit']['location']['latitudeE7'])
				longitude.append(act['placeVisit']['location']['longitudeE7'])

			except Exception as e:
				print(e)			

#Create a data frame to analize the data easily

df = pd.DataFrame(list(zip(place, latitude, longitude,current_activity, 
	probability, start_time, end_time, total_time)), 
               columns =['place', 'latitude', 'longitude','activity', 
               'probability', 'startTime', 'endTime', 'totalTime_min'])

print(df.head())

df.to_csv('activities.csv', index=False)