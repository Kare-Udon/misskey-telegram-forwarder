import requests
import json
from dateutil import parser
from datetime import *


class Note:
    createdAt: datetime
    text: str
    files: [
        {
            "type": str,
            "url": str,
        }
    ]


def _get_raw_notes(site: str, user_id: str):
    req_body = {
        "userId": user_id,
        "limit": 10
    }
    req_header = {
        "User-Agent": "MisskeyTelegramForwarder",
        "Accept-Encoding": "gzip, deflate, br"
    }
    res = requests.post(
        url=f"{site}/api/users/notes",
        headers=req_header,
        data=json.dumps(req_body)
    )
    return res.json()


def get_notes(site: str, user_id: str) -> dict:
    res = _get_raw_notes(site, user_id)
    # do some clean up
    notes: [Note] = []
    for n in res:
        note = Note()
        note.createdAt = parser.parse(n["createdAt"])
        note.text = n["text"]
        note.files = []
        for f in n["files"]:
            file = {
                "type": f["type"],
                "url": f["url"]
            }
            note.files.append(file)
        notes.append(note)
    return notes
