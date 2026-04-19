import configparser
import time

from funke.app_entry import AppEntry
from funke.constants import APP_DIRS
import os

from funke.db import  IndexDatabase


def index_apps():
    """Index applications by scanning their desktop files and storing metadata in a database.

    Args:
        apps (list): List of application directories to index.

    Returns:
        None
    """


    database = IndexDatabase()
    current_indexed_files = database.get_indexed_app_paths()

    ## loop over APP-DIRECTORies and withing them over all .desktoip files

    for app_dir_path in APP_DIRS:
        print(app_dir_path)
        ## open dir from path
        filesList = os.listdir(os.path.expanduser(app_dir_path))

        for file in filesList:
            file = os.path.join(app_dir_path, file)
            if file.endswith('.desktop'):
                try:

                    config = configparser.RawConfigParser()
                    config.read(file)

                    if config.has_section('Desktop Entry'):
                        if config['Desktop Entry'].getboolean('NoDisplay', fallback=False):
                            continue
                        if not config['Desktop Entry'].get('Exec', fallback=None):
                            continue
                        # It should at least have either a name or a comment or both (one at least for indexing / searching)
                        if not config['Desktop Entry'].get('Name', fallback=None) and not config['Desktop Entry'].get('Comment', fallback=None):
                            continue

                        # now, let's create the app entry and write it

                        # already indexed?
                        if file in current_indexed_files:
                            # check if modified
                            last_modified = os.path.getmtime(file)
                            prev_last_modified = database.get_app_last_modified(file)
                            if prev_last_modified < last_modified:
                                print(f"File {file} modified, updating...")
                                # update app entry
                                database.update_app(
                                    AppEntry(
                                        name=config['Desktop Entry'].get('Name', fallback=''),
                                        comment=config['Desktop Entry'].get('Comment', fallback=''),
                                        app_exec=config['Desktop Entry'].get('Exec', fallback=''),
                                        try_exec=config['Desktop Entry'].get('TryExec', fallback=''),
                                        icon=config['Desktop Entry'].get('Icon', fallback=''),
                                        last_modified=last_modified,
                                        path=file,
                                    )
                                )

                            # remove from list
                            current_indexed_files.remove(file)
                        else:
                            database.write_app(
                                AppEntry(
                                    name=config['Desktop Entry'].get('Name', fallback=''),
                                    comment=config['Desktop Entry'].get('Comment', fallback=''),
                                    app_exec=config['Desktop Entry'].get('Exec', fallback=''),
                                    try_exec=config['Desktop Entry'].get('TryExec', fallback=''),
                                    icon=config['Desktop Entry'].get('Icon', fallback=''),
                                    created_at = int(time.time()),
                                    last_modified=os.path.getmtime(file),
                                    path=file,
                                )
                            )
                except KeyError as e:
                    print(f"KeyError: {e} in {file}")
                    continue

    # remove abandoned files
    for file in current_indexed_files:
        database.delete_app(file)

    database.commit()
    database.close()





if __name__ == "__main__":
    index_apps()