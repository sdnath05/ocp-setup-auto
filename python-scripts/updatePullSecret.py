import json
import base64
import argparse

parser = argparse.ArgumentParser(add_help=True)

def setArgs():
  parser.add_argument("-u", "--user", type=str, help="Username for the mirror registry")
  parser.add_argument("-p", "--password", type=str, help="Password for the mirror registry")
  parser.add_argument("-d", "--dir", type=str, help="Directory for the pull-secret.json")

def getArgs():
  return parser.parse_args()

if __name__ == "__main__":
  try:
    setArgs()
    args = getArgs()
    dir = args.dir
    user = args.user
    password = args.password
    userPass = f"{user}:{password}"
    str_bytes = userPass.encode('utf-8')
    base64_bytes = base64.b64encode(str_bytes)
    json_data = dict()
    
    with open(f"{dir}/pull-secret.json", mode='rb') as file:
      json_data = json.load(file)
      json_data["auths"]["registry.ocp.local:7443"] = {
        "auth": base64_bytes.decode("utf-8"),
        "email": ""
      }
    with open(f"{dir}/pull-secret.json", mode='w+') as file:
      json.dump(obj=json_data, fp=file)
      print("Updated pull-secret.json with registry password")
  except FileNotFoundError:
    print("Error: 'pull-secret.json' not found.")
  except json.JSONDecodeError:
    print("Error: Could not decode JSON from 'pull-secret.json'. Check file format.")

