# This is an example Dockerfile that builds a minimal container for running LK Agents
# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.11.6
FROM python:${PYTHON_VERSION}-slim

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
#ARG UID=10001
#RUN adduser \
#    --disabled-password \
#    --gecos "" \
#    --home "/home/appuser" \
#    --shell "/sbin/nologin" \
#    --uid "${UID}" \
#    appuser


#ENV LANG=C.UTF-8
#ENV DEBIAN_FRONTEND=noninteractive
# Install gcc and other build dependencies.
    
# RUN apt update -y && apt upgrade -y
# RUN apt-get update && apt-get install -y pkg-config sqlite3 \
#     libopenblas-dev clang git-lfs \
#     software-properties-common ca-certificates \
#     make cmake gcc libsqlite3-dev python3 \
#     npm python3-pip python3-venv git wget \
#     curl protobuf-compiler libhdf5-serial-dev locales python3-dev \
#     #systemctl \
#     && rm -rf /var/lib/apt/lists/* && apt-get autoclean

RUN apt-get update && \
    apt-get install -y \
    gcc pkg-config \
    clang git-lfs \
    software-properties-common \
    make cmake gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

#USER appuser

#RUN mkdir -p /home/appuser/.cache
#RUN chown -R appuser /home/appuser/.cache
#WORKDIR /home/appuser
WORKDIR /root/

COPY requirements.txt .
RUN python -m pip install --user --no-cache-dir -U pip setuptools wheel
RUN python -m pip install --user --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8501
ENTRYPOINT ["python", "-m" ,"streamlit", "run", "portalui.py", "--server.port=8501"] 
