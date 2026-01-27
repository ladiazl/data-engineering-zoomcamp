# **Module 1 Homework: Docker & SQL**
---
## **Docker**
---
### _**Question 1. Understanding Docker images**_

The following command was executed in the terminal.
```
docker run -it --entrypoint=bash --rm python:3.13
```
Once the container was started, `pip -V` was run, getting `25.3` as the pip version on the python:3.13 image.

### _**Question 2. Understanding Docker networking and docker-compose**_

The `hostname` is either `db` or `postgres` and the `port` is `5432`.

``` yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

## **SQL**
---

### **Preparing the data**

Data was downloaded by running the following commands

```
wget https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```
Data was ingested using the following files:
- [docker-compose.yaml](./docker-compose.yaml)
- [Dockefile](./Dockefile)
- [ingest_data.py](./ingest_data.py)

The queries were run on `PgAdmin`.

### _**Question 3. Counting short trips**_

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a trip_distance of less than or equal to 1 mile?

```sql
SELECT COUNT(*) AS num_trips
FROM public.green_taxi_trips
WHERE (lpep_pickup_datetime BETWEEN '2025-11-01' AND '2025-12-01') AND trip_distance <= 1;
```

The result of this query is: `8007`

### _**Question 4. Longest trip for each day**_

Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles (to exclude data errors).

```sql
WITH v1 AS (
	SELECT MAX(trip_distance)
	FROM public.green_taxi_trips
	WHERE trip_distance < 100
	)

SELECT lpep_pickup_datetime
FROM public.green_taxi_trips
WHERE trip_distance = (SELECT * FROM v1);

```

The result of this query is: `2025-11-14 15:36:27`

### _**Question 5. Biggest pickup zone**_

Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

```SQL
SELECT z."Zone", SUM(t.total_amount) AS total_amount_sum
FROM public.green_taxi_trips t
JOIN public.taxi_zones z
ON t."PULocationID" = z."LocationID"
WHERE DATE_TRUNC('day', lpep_pickup_datetime)::DATE = '2025-11-18'
GROUP BY 1
ORDER BY 2 DESC;
```

The query shows the zone `East Harlem North` with the most `total_amount` (~9281.92)

### _**Question 6. Largest tip**_

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

```SQL
SELECT z."Zone", t.tip_amount
FROM public.green_taxi_trips t
JOIN public.taxi_zones z
ON t."DOLocationID" = z."LocationID"
WHERE t."PULocationID" = (SELECT "LocationID" 
FROM public.taxi_zones 
WHERE "Zone" = 'East Harlem North')
ORDER BY t.tip_amount DESC
LIMIT 1;
```

The query shows that the trip with the largest tip (81.89), among pickups in `East Harlem Noth` was dropped of in the zone `Yorkville West`

## **Terraform**
---

### _**Question 7. Terraform Workflow**_

The sequence `terraform init, terraform apply -auto-approve, terraform destroy` describes the following workflow:

- Downloading the provider plugins and setting up backend,
- Generating proposed changes and auto-executing the plan
- Remove all resources managed by terraform`
