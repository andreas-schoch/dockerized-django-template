FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

RUN apk add --update --no-cache postgresql-client jpeg-dev

RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev  # will be removed after install

RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps  # removing everything that was only required to build image

RUN mkdir /app
WORKDIR /app
COPY ./app /app


RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/  # giving user ownership before switching from root to user
RUN chmod -R 755 /vol/web
USER user

EXPOSE 8000