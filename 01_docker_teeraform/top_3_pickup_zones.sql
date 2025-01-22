select zones, zone_total
from 
	(
	select
		t2."Zone" as zones, 
		sum(t1.total_amount) as zone_total
	from 
		ny_green_taxi t1 
	join 
		ny_zone_lookup t2
	on 
		t1."PULocationID"=t2."LocationID"
	where
		lpep_pickup_datetime >= '2019-10-18 00:00:00' AND lpep_pickup_datetime < '2019-10-19 00:00:00'
	group by 
		t2."Zone"
	) as subquery
where zone_total > 13000
order by zone_total desc
limit 3
