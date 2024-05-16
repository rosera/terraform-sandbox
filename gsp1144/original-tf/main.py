def hello_world(request):
  import json
  import time
  import os
  from google.cloud import pubsub_v1

  f = open("weather_station_data.json")

  # Set the project ID, topic name, and bucket name
  project_id = os.environ.get("PROJECT_ID")
  topic_name = 'weather-sensor-trigger'

  publisher = pubsub_v1.PublisherClient()
  topic_path = publisher.topic_path(project_id, topic_name)

  data = json.load(f)
  # Publish the JSON data to the topic
  try:
     for doc in data:
        encoded_data = json.dumps(doc).encode("utf-8")
        future = publisher.publish(topic_path, data=encoded_data)
        time.sleep(0.5)
  except Exception as e:
     print(e)

  return "successful"
