# create_webhook.py
import requests
import json
import os

# Fetching environment variables set by Jenkins
GITHUB_TOKEN = os.getenv('GITHUB_TOKEN')
REPO_OWNER = os.getenv('REPO_OWNER')
REPO_NAME = os.getenv('REPO_NAME')
JENKINS_URL = os.getenv('JENKINS_URL')
SECRET = os.getenv('SECRET')

# URL for the GitHub API endpoint to create a webhook
url = f'https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/hooks'

# Headers for the request
headers = {
    'Authorization': f'token {GITHUB_TOKEN}',
    'Content-Type': 'application/json'
}

# Payload for the webhook
payload = {
    "name": "web",
    "active": True,
    "events": [
        "push"
    ],
    "config": {
        "url": JENKINS_URL,
        "content_type": "json",
        "secret": SECRET
    }
}

# Sending the POST request to create the webhook
response = requests.post(url, headers=headers, data=json.dumps(payload))

# Handling the response
if response.status_code == 201:
    print('Webhook created successfully')
else:
    print(f'Failed to create webhook: {response.status_code}')
    print(response.json())
