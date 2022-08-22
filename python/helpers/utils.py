import subprocess

def printNoLB(s):
    print(s, end='')

def runCommand(command):
    try:
        splitted = command.split(' ')
        output = subprocess.check_output(splitted).decode()
        return str(output).rstrip('\n')
    except:
        return