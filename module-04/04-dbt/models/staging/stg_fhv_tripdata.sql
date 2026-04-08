with 

source as (

    select * from {{ source('raw_data', 'fhv_tripdata_partitioned') }}

),

renamed as (

    select
        dispatching_base_num as vendor_id,
        pickup_datetime,
        dropoff_datetime,
        pulocationid as pickup_location_id,
        dolocationid as dropoff_location_id,
        sr_flag as store_and_fwd_flag,
        affiliated_base_number

    from source

)

select * from renamed
where vendor_id is not null