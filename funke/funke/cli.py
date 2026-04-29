#!/usr/bin/env python3
import argparse

from funke.indexer_apps import index_apps
from funke.indexer_files import index_files
from funke.query import query_apps
from funke.query import query_directories
from funke.query import query_files
from funke.query import query_web
import json

def main():
    parser = argparse.ArgumentParser(description="Funke")
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser("index")

    search_parser = subparsers.add_parser("query")
    search_parser.add_argument("query", nargs="+")
    search_parser.add_argument("--apps", action="store_true")
    search_parser.add_argument("--files", action="store_true")
    search_parser.add_argument("--dirs", action="store_true")
    search_parser.add_argument("--web", action="store_true")

    args = parser.parse_args()

    if args.command == "index":
        index_apps()
        index_files()
    elif args.command == "query":
        query = " ".join(args.query)
        # if no flags specified, query everything
        query_all = not args.apps and not args.files and not args.dirs and not args.web
        result = {}
        if args.apps or query_all:
            result["apps"] = query_apps(query)
        if args.files or query_all:
            result["files"] = query_files(query)
        if args.dirs or query_all:
            result["dirs"] = query_directories(query)
        if args.web or query_all:
            result["web"] = query_web(query)
        print(json.dumps(result, indent=4))