import os
import sqlite3
from funke.app_entry import AppEntry
from funke import load_config


def create_db_if_not_exists(db_path: str = "index.db") -> sqlite3.Connection:
    """
    Check if the database exists; if not, create it.
    The db_path defaults to the index_path defined in config.json.
    """

    path = os.path.expanduser(db_path)
    # create dir if not exist
    os.makedirs(os.path.dirname(path), exist_ok=True)

    # establish connection
    conn = sqlite3.connect(path)
    # Enable fk
    conn.execute(""" PRAGMA foreign_keys = ON; """)

    # adding the tables (if not there)
    conn.execute("""
                 CREATE TABLE IF NOT EXISTS apps
                 (
                     id INTEGER PRIMARY KEY AUTOINCREMENT,
                     name TEXT,
                     comment TEXT,
                     icon TEXT,
                     exec TEXT,
                     try_exec TEXT,
                     path TEXT UNIQUE,
                     created_at INTEGER,
                     last_modified INTEGER
                 )
                 """)

    conn.execute("""
                 CREATE TABLE IF NOT EXISTS app_actions
                 (
                     id INTEGER PRIMARY KEY AUTOINCREMENT,
                     application_id INTEGER NOT NULL,
                     name TEXT,
                     exec TEXT,
                     FOREIGN KEY
                 (
                     application_id
                 ) REFERENCES apps( id )
                    )
                 """)

    conn.commit()
    return conn

class IndexDatabase:
    def __init__(self):
        config = load_config()
        self.conn = create_db_if_not_exists(config.get("index_path"))


    def get_conn(self) -> sqlite3.Connection:
        return self.conn

    def close(self):
        self.conn.close()

    def commit(self):
        self.conn.commit()

    def write_app(self, app: AppEntry):
        ### write app to dbcreated_at
        cursor = self.conn.cursor()
        cursor.execute("""
            INSERT INTO apps (name, comment, icon, exec, try_exec, path, created_at, last_modified)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (app.name, app.comment, app.icon, app.app_exec, app.try_exec, app.path, app.created_at, app.last_modified))

    def update_app(self, app: AppEntry):
        cursor = self.conn.cursor()
        cursor.execute("""
            UPDATE apps
            SET name = ?, comment = ?, icon = ?, exec = ?, try_exec = ?, last_modified = ?
            WHERE path = ?
        """, (app.name, app.comment, app.icon, app.app_exec, app.try_exec, app.last_modified, app.path))

    def delete_app(self, path: str):
        cursor = self.conn.cursor()
        cursor.execute("""
            DELETE FROM apps
            WHERE path = ?
        """, (path,))

    def get_indexed_app_paths(self) -> list[str]:
        cursor = self.conn.cursor()
        cursor.execute("SELECT path FROM apps")
        return [row[0] for row in cursor.fetchall()]


    def get_app_last_modified(self, path: str) -> int:
        cursor = self.conn.cursor()
        cursor.execute("SELECT last_modified FROM apps WHERE path = ?", (path,))
        return cursor.fetchone()[0]
