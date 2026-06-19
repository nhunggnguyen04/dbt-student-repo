with raw_host as(
    select * from airbnb.raw.raw_host
)
select 
    id as host_id,
    host_name,
    host_url,
    host_since,
    host_location,
    host_response_time,
    host_response_rate,
    host_acceptance_rate,
    host_is_superhost,
    host_thumbnail_url,
    host_picture_url,
    host_neighbourhood,
    host_listings_count,
    host_total_listings_count,
    host_verifications,
    host_has_profile_pic,
    host_identity_verified