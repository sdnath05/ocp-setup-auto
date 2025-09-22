import yaml
import argparse

parser = argparse.ArgumentParser(add_help=True)

def setArgs():
  parser.add_argument("--schedular-file", type=str, help="Master schedular file path")

def getArgs():
  return parser.parse_args()

def readYamlFile(path):
  try:
    with open(path, 'r') as file:
      data = yaml.safe_load(file)
      return data
  except FileNotFoundError:
    print(f"Error: The file was not found.")
    print(FileNotFoundError)
    return None
  except yaml.YAMLError as exc:
    print(f"Error parsing YAML file: {exc}")
    return None

if __name__ == "__main__":
  data = None
  setArgs()
  args = getArgs()
  schedularFile = args.schedular_file
  
  try:
    data = readYamlFile(schedularFile)
    data["spec"]["mastersSchedulable"] = False
      
    with open(schedularFile, 'w+') as file:
      yaml.dump(data, file, width=-1, indent=2, Dumper=yaml.CDumper)
  except FileNotFoundError:
    print(f"Error: The file was not found.")
    print(FileNotFoundError)
  except yaml.YAMLError as exc:
    print(f"Error parsing YAML file: {exc}")
  
