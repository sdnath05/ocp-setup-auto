import yaml
import argparse

parser = argparse.ArgumentParser(add_help=True)

def setArgs():
  parser.add_argument("--public-key", type=str, help="Public key filepath")
  parser.add_argument("--pull-secret", type=str, help="Pull secret filepath")
  parser.add_argument("--installer-dir", type=str, help="Installation dir")
  parser.add_argument("--cert-file", type=str, help="Certificate file that has been used for mirror setup")

def getArgs():
  return parser.parse_args()

def readFile(path):
  try:
    with open(path, 'r') as file:
      data = file.read().rstrip()
      return data
  except FileNotFoundError:
    print(f"Error: The file was not found.")
    print(FileNotFoundError)
    return None

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
  yamlFilePath = "./manifests/install-config.yaml"
  sshFilePath = args.public_key
  pullSecretPath = args.pull_secret
  out_dir = args.installer_dir
  cert_file = args.cert_file
  
  def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
      return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)

  yaml.add_representer(str, str_presenter)
  
  try:
    data = readYamlFile(yamlFilePath)
    pullSecretData = readFile(pullSecretPath)
    publicKey = readFile(sshFilePath)
    certData = readFile(cert_file)
    
    data["pullSecret"] = pullSecretData
    data["sshKey"] = publicKey
    data["additionalTrustBundle"] = certData
      
    with open(f'{out_dir}/install-config.yaml', 'w+') as file:
      yaml.dump(data, file, indent=2, width=float("inf"))
  except FileNotFoundError:
    print(f"Error: The file was not found.")
    print(FileNotFoundError)
  except yaml.YAMLError as exc:
    print(f"Error parsing YAML file: {exc}")
  
