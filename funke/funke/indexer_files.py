from funke.db import  IndexDatabase
from funke import load_config
from pathlib import PurePath
import magic
import os
import time


db = IndexDatabase()
timestamp = int(time.time())
config = load_config()
mime = magic.Magic(mime=True)

def index_files():
    home = os.path.expanduser("~")
    traverse_directory_tree(home)
    db.commit()




def index_directory(path):
    global db
    global timestamp
    name = os.path.basename(path)
    modified_at = int(os.path.getmtime(path))
    db.write_directory(path, name, timestamp, modified_at)



def index_file(path):
    global db
    global timestamp
    global mime

    modified = int(os.path.getmtime(path))
    # checking if file is there and its last modified time is same as the one in db
    modified_at = db.get_file_modified_at(path)
    if modified_at is not None and modified_at == modified:
        return

    name = str(os.path.basename(path))
    mime_type = mime.from_file(path)

    db.write_file(path,
                  name,
                  os.path.splitext(name)[1],
                  os.path.getsize(path),
                  mime_type,
                  modified,
                  timestamp
    )


# recursive directory traversal
def traverse_directory_tree(path):
    global config

    unchanged_dir = False
    # check if already indexed and if last modified time is same as the one in db
    modified_at = db.get_directory_modified_at(path)
    if modified_at == int(os.path.getmtime(path)):
        print(f"Directory {path} is up to date, skipping indexing")
        unchanged_dir = True

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
        elif not unchanged_dir and entry.is_file(follow_symlinks=False):
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
