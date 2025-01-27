import requests
import sys
import os

SERVICE1_URL = os.getenv("SERVICE1_URL", "http://service1:8080")

message = requests.get(sys.stdin.readline()).text
data = ["md5", message]

print(requests.post(SERVICE1_URL, data="\n".join(data)))