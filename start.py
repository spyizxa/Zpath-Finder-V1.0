import subprocess 
import os

def intro():
    print("""
  _____            _   _       _____ _           _
|__  /_ __   __ _| |_| |__   |  ___(_)_ __   __| | ___ _ __
  / /| '_ \ / _` | __| '_ \  | |_  | | '_ \ / _` |/ _ \ '__|
 / /_| |_) | (_| | |_| | | | |  _| | | | | | (_| |  __/ |
/____| .__/ \__,_|\__|_| |_| |_|   |_|_| |_|\__,_|\___|_|
     |_|

zpath finder V1.0 | telegram: @zeroexploits

    """)

def main():
    url = input("Enter URL: ")
    yn = input("Use default wordlist? [Y/n]:  ")
    wordlist = "wordlist.txt"
    if yn.lower() == "n":
        wl = input("Enter wordlist path: ")
        subprocess.call(["chmod", "+x", "main.sh"])
        subprocess.call(["./main.sh", url, wl])
    elif yn.lower() == "y":
        subprocess.call(["chmod", "+x", "main.sh"])
        subprocess.call(["./main.sh", url, wordlist])
    else:
        os._exit()

intro()
main()