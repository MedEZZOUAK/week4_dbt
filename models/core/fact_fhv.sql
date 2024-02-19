{{ config(materialized="table") }}
with
    fhv_trip as (
        select * from {{ ref("stg_staging__fhv_data") }} where pulocationid is not null
    ),
    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')
select dispatching_base_num, pulocationid, dolocationid, sr_flag, affiliated_base_number
from fhv_trip
inner join dim_zones as pickup_zone on fhv_trip.pulocationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone on fhv_trip.dolocationid = dropoff_zone.locationid
