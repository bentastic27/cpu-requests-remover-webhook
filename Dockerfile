ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM python:3.12 as parent
WORKDIR /app
RUN pip3 install pipenv
COPY Pipfile /app/
COPY Pipfile.lock /app/

FROM parent AS base
RUN pipenv install --deploy --system

FROM base as Prod
COPY src /app
RUN groupadd --gid $USER_GID $USERNAME && \
  useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /sbin/nologin -d /app && \
  chown $USER_UID.$USER_GID /app
EXPOSE 8443
ENTRYPOINT ["gunicorn"]
CMD ["app:app"]
