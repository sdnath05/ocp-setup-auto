import json
import os
import requests
from dotenv import load_dotenv
from GetAccessTokenExec import getTokenByShell

load_dotenv()

def getPullSecret():
  accessToken = getTokenByShell()
  
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

def saveJsonFile(filepath, obj):
  try:
    with open(filepath, 'w') as file:
      json.dump(obj, file)
      print(f"pull-secret data successfully saved to '{filepath}'")
  except IOError as e:
    print(f"Error writing to file: {e}")

if __name__ == "__main__":
  OUT_DIR = os.getenv("OUT_DIR")
  pullSecret = getPullSecret()
  
  saveJsonFile(f"{OUT_DIR}/pull-secret.json", pullSecret)
  
    