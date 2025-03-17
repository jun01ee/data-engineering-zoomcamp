docker run -it \ 
-e PGADMIN_DEFAULT_EMAIL="pgadmin@pgadmin.com" \
-e PGADMIN_DEFAULT_PASSWORD="pgadmin" \
-p 8080:80 \
--network=my-pgnetwork \
--name pgadmin-flink \
dpage/pgadmin4
