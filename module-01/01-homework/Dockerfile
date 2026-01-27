FROM python:3.13.11-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /code

ENV PATH="/code/.venv/bin:$PATH"

COPY pyproject.toml .python-version uv.lock ./

# RUN pip install pandas pyarrow

RUN uv sync --locked

COPY ingest_data.py .
COPY green_tripdata_2025-11.parquet taxi_zone_lookup.csv .

ENTRYPOINT ["python", "ingest_data.py"]
