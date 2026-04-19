import json
import os


# Default path to config relative to this file
CONFIG_PATH = os.path.join(os.path.dirname(__file__), "..", "config", "config.json")


def load_config(path: str = CONFIG_PATH) -> dict:
    """Load and return the configuration from config.json."""
    with open(path, "r") as f:
        return json.load(f)

if __name__ == "__main__":
    config = load_config()