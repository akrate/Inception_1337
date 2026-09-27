FROM debian:bookworm

RUN apt update && apt install -y python3 python3-pip python3-venv


COPY components /components

WORKDIR /components

RUN python3 -m venv my_env && ./my_env/bin/pip install httpie

EXPOSE 5500

ENtRYPOINT ["python3", "-m", "http.server", "5500"] 