#!/usr/bin/env python3
import argparse

from funke.indexer import index_apps
from funke.query import query_apps

def main():
    parser = argparse.ArgumentParser(description="Funke")
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser("index")


    search_parser = subparsers.add_parser("query")
    search_parser.add_argument("query", nargs="+")

    args = parser.parse_args()

    if args.command == "index":
        index_apps()
    elif args.command == "query":
        query = " ".join(args.query)
        result = query_apps(query)
        print(result)