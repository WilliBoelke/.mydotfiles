import os
from funke.db import  IndexDatabase
import time

def index_files():
    # getting user home directory
    home = os.path.expanduser("~")
    index_directory(home)

def index_directory(path):

    try:
        fileList = os.listdir(path)
    except PermissionError:
        return


    for file in fileList:
        if os.path.isdir(path + "/" + file):
            index_directory(path + "/" + file)
        else:
            index_file(path + "/" + file)


import os
from funke.db import  IndexDatabase
import time

def index_files():
    # getting user home directory
    home = os.path.expanduser("~")
    index_directory(home)

def index_directory(path):

    try:
        fileList = os.listdir(path)
    except PermissionError:
        return


    for file in fileList:
        if os.path.isdir(path + "/" + file):
            index_directory(path + "/" + file)
        else:
            index_file(path + "/" + file)


files = 0
def index_file(path):
    global files
    files += 1
    print(f"Indexing file: {path}")



if __name__ == "__main__":
    start_time = time.time()
    index_files()
    end_time = time.time()
    print(f"Indexed {files} files in {end_time - start_time} seconds")

def index_file(path):
    files += 1
    print(f"Indexing file: {path}")



if __name__ == "__main__":
    start_time = time.time()
    index_files()
    end_time = time.time()
    print(f"Indexed {files} files in {end_time - start_time} seconds")
