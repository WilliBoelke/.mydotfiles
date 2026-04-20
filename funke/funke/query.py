import json

from funke.db import IndexDatabase

def query_apps(query):
    db = IndexDatabase()
    result = db.get_apps_with_text(query)
    db.close()
    result = [dict(row) for row in result]
    result = json.dumps(result, indent=4)

    return result



if __name__ == "__main__":
    result = query_apps("priv")
    print(result)