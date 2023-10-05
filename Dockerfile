ARG PYTHON_VERSION=3.11

# Builder
FROM python:${PYTHON_VERSION}-alpine as builder

WORKDIR /root

# Install requirements
COPY requirements.txt /root
RUN pip install --prefix="/install" --no-warn-script-location -r requirements.txt

# Install FFmpeg
ARG TARGETARCH
ARG FFMPEG_VERSION=5.1.1

RUN echo "Download from https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-${FFMPEG_VERSION}-${TARGETARCH}-static.tar.xz" && \
    wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-${FFMPEG_VERSION}-${TARGETARCH}-static.tar.xz -O ffmpeg.tar.xz && \
    tar Jxvf ./ffmpeg.tar.xz && \
    cp ./ffmpeg-${FFMPEG_VERSION}-${TARGETARCH}-static/ffmpeg /usr/local/bin/

# Runtime
FROM python:${PYTHON_VERSION}-alpine

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Copy pip requirements
COPY --from=builder /install /usr/local

# Install FFmpeg
COPY --from=builder /usr/local/bin/ffmpeg /usr/local/bin/

WORKDIR /app
COPY ./ /app

CMD ["python", "main.py"]