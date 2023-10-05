import uuid
from pathlib import Path
import requests
from ffmpeg.asyncio import FFmpeg


async def _download_video(url: str, temp_dir: str):
    r = requests.get(url, allow_redirects=True, timeout=10)
    file_name = url.split("/")[-1]
    if not r.ok:
        raise Exception("Download video failed!")
    f_name = Path(temp_dir, file_name)
    with open(f_name, "wb") as f:
        f.write(r.content)
    return f_name


async def transfer_video(url: str, temp_dir: str):
    video = await _download_video(url, temp_dir)
    transfered = Path(temp_dir, f"{uuid.uuid4()}.mp4")
    open(transfered, "xb")
    ffmpeg = (
        FFmpeg()
        .option("y")
        .input(video)
        .output(
            transfered,
            {"codec:v": "libx264"},
            crf=24,
        )
    )
    await ffmpeg.execute()
    return transfered
