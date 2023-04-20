FROM python:3.11.1

# Install cmake because the installation of 
# our 'dlib' dependency requires it
RUN apt-get update && apt-get install -y cmake

# Install some dependencies: pyvips, uwsgi and dlib
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy over the rest of our source files
COPY src/ ./src/

# Our default run command
CMD ["python", "src/main.py"]
