FROM python:3.12 AS parent
WORKDIR /app
RUN pip3 install pipenv
COPY Pipfile /app/
COPY Pipfile.lock /app/

FROM parent AS base
RUN pipenv install --deploy --system

FROM base AS release
COPY src /app
RUN groupadd --gid 1000 appuser && \
  useradd --uid 1000 --gid 1000 -M appuser -s /sbin/nologin -d /app && \
  chown 1000.1000 /app
EXPOSE 8443
ENTRYPOINT ["gunicorn"]
CMD ["app:app"]
