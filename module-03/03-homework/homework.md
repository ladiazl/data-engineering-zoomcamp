# **Module 3 Homework: Data Warehousing & BigQuery**

The data was loaded to a Cloud Storage Bucket with the [provided script](./load_yellow_taxi_data.py) (previously modified).
An external table was created by running the following query in BigQuery:
```sql
CREATE OR REPLACE EXTERNAL TABLE `data-warehouses-487419.taxi_tripdata_2024S1.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://data-warehouses-487419-bucket/yellow_tripdata_2024-*.parquet']
);
```
A regular/materialized table was created from the external table by running the query:
```sql
CREATE OR REPLACE TABLE data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata AS
SELECT * FROM data-warehouses-487419.taxi_tripdata_2024S1.external_yellow_tripdata;
```
## **Quiz**

### _**Question 1. Counting records**_

1. What is count of records for the 2024 Yellow Taxi Data?

According to the details of the materialized table, the number of rows/records is `20,332,093`.

---

### _**Question 2. Data read estimation**_

2. Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.

    What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

<b><u>Regular table</u></b>

```sql
SELECT COUNT(DISTINCT PULocationID)
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata;
```
This query will process 155.12 MB when run.

<b><u>External table</u></b>

```sql
SELECT COUNT(DISTINCT PULocationID)
FROM data-warehouses-487419.taxi_tripdata_2024S1.external_yellow_tripdata;
```

This query will process 0 B when run.

> **Answer:** _0 MB for the External Table and 155.12 MB for the Materialized Table_

---

### _**Question 3. Understanding columnar storage**_

3. Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.

    Why are the estimated number of Bytes different?

```sql
SELECT PULocationID
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata;
```
This query will process 155.12 MB when run.

```sql
SELECT PULocationID, DOLocationID 
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata;
```

This query will process 310.24 MB when run.

> **Answer:** _BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed._

---

### _**Question 4. Counting zero fare trips**_

4. How many records have a fare_amount of 0?

```sql
SELECT COUNT(*)
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata
WHERE fare_amount = 0;
```
> **Answer:** _`8,333`_

---

### _**Question 5. Partitioning and clustering**_

5. What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

> **Answer:** _Partition by `tpep_dropoff_datetime` and Cluster on `VendorID`_

The table was created by running this query:

```sql
CREATE OR REPLACE TABLE data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM data-warehouses-487419.taxi_tripdata_2024S1.external_yellow_tripdata;
```

---

### _**Question 6. Partition benefits**_

6. Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

    Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

<b><u>Materialized table</u></b>

```sql
SELECT DISTINCT VendorID
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
```

This query will process 310.24 MB when run.

<b><u>Partitioned and clustered table</u></b>

```sql
SELECT DISTINCT VendorID
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata_partitioned_clustered
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
```

This query will process 26.84 MB when run.

> **Answer:** _310.24 MB for non-partitioned table and 26.84 MB for the partitioned table_

---

### _**Question 7. External table storage**_

7. Where is the data stored in the External Table you created?

> **Answer:** _GCP Bucket_

---

### _**Question 8. Clustering best practices**_

8. It is best practice in Big Query to always cluster your data: 

> **Answer:** _False_

---

### _**Question 9. Understanding table scans**_

9. No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

```sql
SELECT COUNT(*)
FROM data-warehouses-487419.taxi_tripdata_2024S1.yellow_tripdata;
```
This query will process 0 B when run.

BigQuery is using the table metadata.