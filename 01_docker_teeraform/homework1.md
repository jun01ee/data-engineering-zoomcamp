# Question 1 
(base) 23491378@dep66306 data-engineering-zoomcamp % docker run -it python:3.12.8 bash
root@6baf757ec3d2:/# pip --version
pip 24.3.1

# Question 2
The hostname is "postgres", the port is 5432

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
