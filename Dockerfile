FROM python:3.11
WORKDIR /app

COPY data-integration/ .
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install


CMD [ "poetry", "run", "python3", "main.py"]