import requests
import sys
import os

SERVICE1_URL = os.getenv("SERVICE1_URL", "http://service1:8080")
message = requests.get(sys.stdin.readline()).text
print(message)
data = ["md5", message]
print(SERVICE1_URL)
res = requests.post(SERVICE1_URL, data="\n".join(data))
print(res.text)