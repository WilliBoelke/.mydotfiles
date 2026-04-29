import json

from funke.db import IndexDatabase
from funke.ddg_search import search_web


def query_apps(query):
    db = IndexDatabase()
    result = db.get_apps_with_text(query)
    db.close()
    result = [dict(row) for row in result]

    return result


def query_directories(query):
    db = IndexDatabase()
    result = db.get_directory_by_name(query)
    db.close()
    result = [dict(row) for row in result]

    return result


def query_files(query):
    db = IndexDatabase()
    result = db.get_file_by_text(query)
    db.close()
    result = [dict(row) for row in result]

    return result

def query_web(query):
    return search_web(query)


if __name__ == "__main__":
    result = query_apps("priv")
    print(result)