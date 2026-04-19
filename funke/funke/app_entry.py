from dataclasses import dataclass
from typing import Optional

@dataclass
class AppEntry:
    name: str
    app_exec: str
    path: str
    comment: Optional[str] = None
    icon: Optional[str] = None
    try_exec: Optional[str] = None
    created_at: Optional[int] = None
    last_modified: Optional[int] = None

    def __repr__(self):
        return f"<AppEntry {self.name}>"

    def __str__(self):
        return f"{self.name} - {self.path}"

