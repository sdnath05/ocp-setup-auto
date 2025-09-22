import requests
import os

# Your Red Hat credentials
# username = "your_redhat_username"
# password = "your_redhat_password"
def getTokenWithPass(username, password):
  # OpenShift pull secret API endpoint (undocumented/private use)
  SSO_URL = os.getenv("SSO_URL")
  
  # Authentication to get token
  try:
    response = requests.post(SSO_URL, data={
      "grant_type": "password",
      "client_id": "cloud-services",
      "username": username,
      "password": password
    })

    if response.status_code == 200:
      access_token = response.json().get('access_token')
      print("Access token fetched successfully.")
      return access_token
    else:
      print("Failed to authenticate:", response.status_code, response.text)
      return None
  except Exception as e:
    print(e)
    return None

def getTokenWithOfflineToken():
  # OpenShift pull secret API endpoint (undocumented/private use)
  SSO_URL = os.getenv("SSO_URL")
  OFFLINE_ACCESS_TOKEN=os.getenv("OFFLINE_ACCESS_TOKEN")
  
  # Authentication to get token
  try:
    response = requests.post(SSO_URL, data={
      "grant_type": "refresh_token",
      "client_id": "cloud-services",
      "refresh_token": OFFLINE_ACCESS_TOKEN
    })

    if response.status_code == 200:
      access_token = response.json().get('access_token')
      print("Access token fetched successfully.")
      return access_token
    else:
      print("Failed to authenticate:", response.status_code, response.text)
      return None
  except Exception as e:
    print(e)
    return None

def getPullSecret():
  accessToken = getTokenWithOfflineToken()
  PULL_SECRET_URL = os.getenv("PULL_SECRET_URL")
  
  headers = {
    "Authorization": f"Bearer {accessToken}",
    "Content-Type": "application/json"
  }

  res = requests.post(PULL_SECRET_URL, headers=headers)
  if res.status_code == 200:
    return res.json()
  else:
    print("Failed to get pull secret:", res.status_code, res.text)
    return None
  