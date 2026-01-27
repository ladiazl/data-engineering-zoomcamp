#!/usr/bin/env python
# coding: utf-8

import click
import pandas as pd
from sqlalchemy import create_engine
# from tqdm.auto import tqdm



@click.command()
@click.option("--pg-user", default="root", help="PostgreSQL username")
@click.option("--pg-pass", default="root", help="PostgreSQL password")
@click.option("--pg-host", default="localhost", help="PostgreSQL host")
@click.option("--pg-port", default=5432, help="PostgreSQL port")
@click.option("--pg-db", default="ny_taxi", help="PostgreSQL database")
@click.option("--target-table", default="green_taxi_data", help="Target table name")


def run(pg_user, pg_pass, pg_host, pg_port, pg_db, target_table):

    """Ingest NYC taxi data into PostgreSQL database"""

    path = "green_tripdata_2025-11.parquet"

    engine = create_engine(f'postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}')

    df_green_taxi_trips = pd.read_parquet(path)

    first = True
    if first:
        df_green_taxi_trips.head(0).to_sql(
            name=target_table, 
            con=engine, 
            if_exists="replace"
            )
        first = False
    
    df_green_taxi_trips.to_sql(
        name=target_table, 
        con=engine, 
        if_exists="append")

    dtype = {
        "LocationID": "Int64",
        "Borough": "string",
        "Zone": "string",
        "service_zone": "string"
    }

    df_zones = pd.read_csv("taxi_zone_lookup.csv", encoding="latin1")

    first = True
    if first:
        df_zones.head(0).to_sql(
            name="taxi_zones", 
            con=engine, 
            if_exists="replace"
            )
        first = False
    
    df_zones.to_sql(
        name="taxi_zones", 
        con=engine, 
        if_exists="append")


if __name__ == "__main__":
    run()