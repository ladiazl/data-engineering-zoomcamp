# **Module 2 Homework: Workflow Orchestration with Kestra**
---
## **Quiz**
---
### _**Question 1**_

1. Within the execution for `Yellow` Taxi data for the year `2020` and month `12`: what is the uncompressed file size (i.e. the output file `yellow_tripdata_2020-12.csv` of the `extract` task)?

To determine the file size, the following command was executed in the Google Cloud Shell terminal: 

```bash
export BUCKET_NAME=kestra-gcp-486222-bucket
gsutil du -h gs://$BUCKET_NAME/yellow_tripdata_2020-12.csv
```

The file size is `128.25 MiB`

### _**Question 2**_
2. What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?

```yaml
variables:
  file: "{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv"
```
The rendered value is: `green_tripdata_2020-04.csv`

### _**Question 3**_
3. How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?

The following query was run in BigQuery:

```sql
SELECT COUNT(*)
FROM `kestra-gcp-486222.zoomcamp.yellow_tripdata` 
WHERE tpep_pickup_datetime BETWEEN '2020-01-01' AND '2021-01-01';
```

The number of rows is: `24,648,235`

### _**Question 4**_
4. How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?

The following query was run in BigQuery:

```sql
SELECT COUNT(*)
FROM `kestra-gcp-486222.zoomcamp.green_tripdata` 
WHERE lpep_pickup_datetime BETWEEN '2020-01-01' AND '2021-01-01';
```

The number of rows is: `1,733,999`

### _**Question 5**_

5. How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?

The following query was run in BigQuery:

```sql
SELECT COUNT(*)
FROM `kestra-gcp-486222.zoomcamp.yellow_tripdata` 
WHERE tpep_pickup_datetime BETWEEN '2021-03-01' AND '2021-04-01';
```

The number of rows is: `1,925,130`

Alternatively, the following command was executed in the Google Cloud Shell terminal:

```bash
gsutil cat gs://kestra-gcp-486222-bucket/yellow_tripdata_2021-03.csv | wc -l
```
The number of rows is `1,925,153` (`1,925,152` + the header)

### _**Question 6**_

6. How would you configure the timezone to New York in a Schedule trigger?

> Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration

