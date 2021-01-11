FROM python:3.7-slim-buster

# Environment variables
ENV DEBIAN_FRONTEND="noninteractive" \
    AIRFLOW_HOME="/usr/local/airflow" \
    # Python variables
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER root

# Add Airflow user & home
RUN apt-get update && apt-get install -yqq \
    apt-utils \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    postgresql-client \
    curl \
    ca-certificates \
    jq \
    git \
    netcat \
    && apt-get autoremove -yqq --purge \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade pip setuptools wheel

# Python requirements
COPY requirements.txt ./requirements.txt

# Install Airflow and Python libraries (and clean up requirements)
RUN pip install --no-cache-dir -r requirements.txt 

EXPOSE 8080 5555 8793

# Entrypoint config
COPY entrypoint.sh /entrypoint.sh
COPY airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
