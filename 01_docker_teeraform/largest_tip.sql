select
	"Zone",
	tips
from
	(select
		"DOLocationID",
		max(tip_amount) as tips
	from 
		ny_green_taxi a
	join
		ny_zone_lookup b
	on 
		a."PULocationID" = b."LocationID"
	where
		a.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND a.lpep_dropoff_datetime < '2019-11-01 00:00:00' AND b."Zone"='East Harlem North'
	group by "DOLocationID"
	) as t1
join 
	ny_zone_lookup t2
on 
	t1."DOLocationID" = t2."LocationID"
order by tips desc
limit 1
