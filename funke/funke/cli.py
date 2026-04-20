#!/usr/bin/env python3
import argparse

from funke.indexer import index_apps


def main():
    parser = argparse.ArgumentParser(description="Funke")
    subparsers = parser.add_subparsers(dest="command")

    subparsers.add_parser("index")

    args = parser.parse_args()

    if args.command == "index":
        index_apps()