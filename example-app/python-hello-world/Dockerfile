# Use the official Python image as the base image
FROM python:3.9-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir Flask
EXPOSE 5000
ENV FLASK_APP app.py
CMD ["flask", "run", "--host=0.0.0.0"]
