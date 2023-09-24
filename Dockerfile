ARG PYTHON_VERSION=3.11

# Builder
FROM python:${PYTHON_VERSION}-alpine as builder

WORKDIR /root

# Install requirements
COPY requirements.txt /root
RUN pip install --prefix="/install" --no-warn-script-location -r requirements.txt

# Runtime
FROM python:${PYTHON_VERSION}-alpine

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Copy pip requirements
COPY --from=builder /install /usr/local

WORKDIR /app
COPY ./ /app

CMD ["python", "main.py"]