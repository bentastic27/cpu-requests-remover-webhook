FROM python:3.12 as parent
WORKDIR /app
RUN pip3 install pipenv
COPY Pipfile /app/
COPY Pipfile.lock /app/

FROM parent AS base
RUN pipenv install --deploy --system

FROM base as Prod
COPY src /app
ENTRYPOINT ["gunicorn"]
CMD ["app:app"]
