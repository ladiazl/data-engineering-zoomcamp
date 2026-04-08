/*
To Do:
- One row per trip (doesn't matter if yellow or green)
- Add a primary key (trip_id). It has to be unique.
- Find all the duplicates, understand why they happen and fix them
- Find a way to enrich the column payment_type
*/

select
    distinct TO_BASE64(
        CAST(
            CONCAT(vendor_id, 
                rate_code_id, 
                pickup_location_id, 
                dropoff_location_id) 
                AS BYTES)) as trip_id,
    vendor_id,
    rate_code_id,
    pickup_location_id,
    dropoff_location_id,
    pickup_datetime,
    dropoff_datetime,
    store_and_fwd_flag,
    passenger_count,
    trip_distance,
    trip_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount, 
    ehail_fee,
    improvement_surcharge,
    total_amount,
    payment_type as payment_type_id,
    {{ get_payment_type(payment_type) }} as payment_type
from {{ ref('int_trips_unioned')}}