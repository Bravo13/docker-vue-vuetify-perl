FROM python:3.6
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD ./backend/ /code/
RUN apt-get update; \
    apt-get install -y python3-dev default-libmysqlclient-dev build-essential
RUN pip install -r requirements.txt