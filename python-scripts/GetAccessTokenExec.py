import subprocess
import os
  
def getTokenByShell():
  OFFLINE_ACCESS_TOKEN=os.getenv("OFFLINE_ACCESS_TOKEN")
  executablePath = os.getenv("EXECUTABLE_PATH")
  # use when Popen(shell=False)
  # cmd = ['echo', 'Hello World!']
  
  # use when Popen(shell=True)
  cmd = f"""{executablePath}/ocm login --token=\"{OFFLINE_ACCESS_TOKEN}\" && 
        echo $({executablePath}/ocm token --generate);"""
  proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)

  out, err = proc.communicate()

  if proc.returncode != 0 or err.decode('utf-8').rstrip() != "":
    print('Error: '  + err.decode('utf-8').rstrip())
    print('code: ' + str(proc.returncode))
    return None
  else:
    # print('Output: ' + out.decode('utf-8').rstrip())
    return out.decode('utf-8').rstrip()

  
# To download the offline token: https://cloud.redhat.com/openshift/token
  