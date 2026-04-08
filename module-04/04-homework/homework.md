# **Module 4 Homework: Analytics Engineering with dbt**

The [provided script](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/02-workflow-orchestration/flows/09_gcp_taxi_scheduled.yaml) was modified to include the `fhv` (For-hire vehicles) input option and the `fhv_schedule` trigger to backfill the FHV trip data with Kestra (the modified script can be found [here](./gcp_taxi_scheduled.yaml)).

## **Quiz**

### _**Question 1. dbt Lineage and Execution**_

1. Given a dbt project with the following structure:

    ```
    models/
    ├── staging/
    │   ├── stg_green_tripdata.sql
    │   └── stg_yellow_tripdata.sql
    └── intermediate/
        └── int_trips_unioned.sql (depends on stg_green_tripdata & stg_yellow_tripdata)
    ```

    If you run `dbt run --select int_trips_unioned`, what models will be built?

To answer this question, the docummentation on Graph operators was consulted consulted [here](https://docs.getdbt.com/reference/node-selection/graph-operators?version=1.12).

> **Answer:** _`int_trips_unioned` only_

---

### _**Question 2. dbt Tests**_


2. You've configured a generic test like this in your `schema.yml`:

    ```yaml
    columns:
      - name: payment_type
        data_tests:
          - accepted_values:
              arguments:
                values: [1, 2, 3, 4, 5]
                quote: false
    ```

    Your model `fct_trips` has been running successfully for months. A new value `6` now appears in the source data.

    What happens when you run `dbt test --select fct_trips`?

> **Answer:** _dbt will fail the test, returning a non-zero exit code_

---

### _**Question 3. Counting Records in `fct_monthly_zone_revenue`**_

3. After running your dbt project, query the `fct_monthly_zone_revenue` model.

    What is the count of records in the `fct_monthly_zone_revenue` model?

The following query was run in BigQuery:

```sql
SELECT COUNT(*)
FROM `data-warehouses-487419.dbt_ldiaz.fct_monthly_zone_revenue`
```

There are `12,232` records in the `fct_monthly_zone_revenue` model.

> **Answer:** _12,184_

---

### _**Question 4. Best Performing Zone for Green Taxis (2020)**_

4. Using the `fct_monthly_zone_revenue` table, find the pickup zone with the **highest total revenue** (`revenue_monthly_total_amount`) for **Green** taxi trips in 2020.

    Which zone had the highest revenue?

The following query was run in BigQuery:

```sql
SELECT z.zone, SUM(f.revenue_monthly_total_amount) AS total_revenue
FROM `data-warehouses-487419.dbt_ldiaz.fct_monthly_zone_revenue` f
JOIN `data-warehouses-487419.dbt_ldiaz.dim_zones` z
  ON f.pickup_location_id = z.location_id
WHERE f.taxi_type = 'Green'
  AND EXTRACT(YEAR FROM f.month_) = 2020
GROUP BY z.zone
ORDER BY total_revenue DESC
LIMIT 1;
```
The zone with the highest revenue was _**East Harlem North**_.

> **Answer:** _East Harlem North_

---

### _**Question 5. Green Taxi Trip Counts (October 2019)**_

5. Using the `fct_monthly_zone_revenue` table, what is the **total number of trips** (`total_monthly_trips`) for Green taxis in October 2019?

The following query was run in BigQuery:

```sql
SELECT SUM(total_monthly_trips) as total_monthly_trips
FROM `data-warehouses-487419.dbt_ldiaz.fct_monthly_zone_revenue`
WHERE taxi_type = "Green" AND month_ = "2019-10-01"
```

The total number of trips for Green taxis in October 2019 is `387006`.

> **Answer:** _384,624_

---

### _**Question 6. Build a Staging Model for FHV Data**_

6. Create a staging model for the **For-Hire Vehicle (FHV)** trip data for 2019.

    1. Load the [FHV trip data for 2019](https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv) into your data warehouse
    2. Create a staging model `stg_fhv_tripdata` with these requirements:
        - Filter out records where `dispatching_base_num IS NULL`
        - Rename fields to match your project's naming conventions (e.g., `PUlocationID` → `pickup_location_id`)

    What is the count of records in `stg_fhv_tripdata`?

The following query was run in BigQuery:

```sql
SELECT COUNT(*) AS total_records
FROM `data-warehouses-487419.dbt_ldiaz.stg_fhv_tripdata`
```

There are `43244693` records in `stg_fhv_tripdata`.

> **Answer:** _43,244,693_