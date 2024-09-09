FROM python:3.9-alpine3.13
LABEL maintainer="subash"

# Set Python environment variable to prevent output buffering
ENV PYTHONUNBUFFERED=1

# Copy the requirements file to the temporary directory in the container
COPY ./requirements.txt /tmp/requirements.txt

# Copy the requirements.dev file to the temporary directory in the container
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the application code to the /app directory in the container
COPY ./app /app

# Set the working directory to /app
WORKDIR /app

# Expose port 8000 for the application
EXPOSE 8000

ARG DEV=false

# Create a virtual environment, upgrade pip, install dependencies, clean up
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Add the virtual environment to the PATH
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user
