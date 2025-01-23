# Question 1 
(base) 23491378@dep66306 data-engineering-zoomcamp % docker run -it python:3.12.8 bash
root@6baf757ec3d2:/# pip --version
pip 24.3.1

# Answer: 24.3.1

# Question 2
The hostname is "postgres", the port is 5432
# Answer: postgres:5432

# Question 3
docker network create my-pgnetwork

docker run -it \
 -e POSTGRES_USER="postgres" \
 -e POSTGRES_PASSWORD="postgres" \
 -e POSTGRES_DB="ny_taxi" \
 -v ~/Desktop/repo/data-engineering-zoomcamp/01_docker_teeraform/ny_taxi_postgres_data:/var/lib/postgresql/ny-data \
 -p 5433:5432 \
 --name=pg-database \
 --network=my-pgnetwork \
 postgres:17-alpine

docker run -it \
 -e PGADMIN_DEFAULT_EMAIL="pgadmin@pgadmin.com" \
 -e PGADMIN_DEFAULT_PASSWORD="pgadmin" \
 -p 8080:80 \
 --network=my-pgnetwork \
 --name pgadmin-2 \
dpage/pgadmin4

## Run SQL query 'count_trips_by_distance.sql', return:

"Up to 1 Miles"	104802
"Between 1 Miles and 3 Miles"	198924
"Between 3 Miles and 7 Miles"	109603
"Between 7 M ilesand 10 Miles"	27678
"Over 10 Miles"	35189

# Answer:104,802; 198,924; 109,603; 27,678; 35,189

# Question 4
## Run query:
select lpep_pickup_datetime, trip_distance
from ny_green_taxi
order by trip_distance desc

# Answer: 2019-10-31

# Question 5
## Run query 'top_3_pickup_zones.sql', return:
"zones"	"zone_total"
"East Harlem North"	18686.680000000084
"East Harlem South"	16797.260000000057
"Morningside Heights"	13029.79000000003

# Answer: East Harlem North, East Harlem South, Morningside Heights

# Question 6
## Run query 'largest_tip.sql', return:
"JFK Airport"	87.3

# Answer: "JFK Airport"

# Question 7
# Answer: terraform init, terraform apply -auto-approve, terraform destroy 
