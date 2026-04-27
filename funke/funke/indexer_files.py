from funke.db import  IndexDatabase
from funke import load_config
from pathlib import PurePath
import magic
import os
import time


db = IndexDatabase()
timestamp = int(time.time())
config = load_config()

def index_files():
    home = os.path.expanduser("~")
    traverse_directory_tree(home)
    db.commit()




def index_directory(path):
    global db
    global timestamp
    name = os.path.basename(path)
    print(f"Indexing directory: {path}")
    db.write_directory(path, name, timestamp)


def index_file(path):
    global db
    global timestamp
    name = os.path.basename(path)
    modified = int(os.path.getmtime(path))
    mime = magic.Magic(mime=True)
    mime_type = mime.from_file(path)
    print(f"Indexing file: {path}")
    db.write_file(path, name, os.path.splitext(name)[1], os.path.getsize(path), mime_type, modified, timestamp)



# recursive directory traversal
def traverse_directory_tree(path):
    global config

    exclude_paths = config.get("exclude_paths", [])

    try:
        entries = os.scandir(path)
    except PermissionError:
        # no permission to access this directory
        print(f"Permission denied: {path}")
        return

    # main traversal loop
    for entry in entries:
        entry_path = entry.path
        # if it's a directory, index and recurse into it
        if(entry.is_dir(follow_symlinks=False)
                and not is_excluded(entry_path, exclude_paths)):
                index_directory(entry_path)
                traverse_directory_tree(entry_path)
        # if it's a file, index it'
        elif(entry.is_file(follow_symlinks=False)):
            index_file(entry_path)



def is_excluded(path, exclude_paths=None):
    for pattern in exclude_paths:
        expanded = os.path.expanduser(pattern)
        if expanded.startswith('/'):
            # absolute path — prefix check
            if path.startswith(expanded):
                return True
        else:
            # glob pattern — use PurePath.match()
            if PurePath(path).match(pattern):
                return True
    return False




if __name__ == "__main__":
    start_time = time.time()
    index_files()
    end_time = time.time()
