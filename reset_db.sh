# load the .env file
eval "$(
  cat .env | awk '!/^\s*#/' | awk '!/^\s*$/' | awk '!/^.*(MESSAGE|RAG).*$/' | while IFS='' read -r line; do
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    echo "export $key=\"$value\""
  done
)"

# stopping / cleaning related dockers
docker stop casdoordb
docker rm casdoordb
# docker rm $(docker stop $(docker ps -a -q --filter ancestor="postgres" --filter name="nomopostgres"))

sudo rm -rf ../storage/databases/_pgsql

sleep 2

# run the containers for Qdrant and PGVector
# -e POSTGRES_INITDB_ARGS: '--encoding=UTF-8' --lc-collate=C --lc-ctype=C'

docker run --name casdoordb -p 5430:5430 -v $(pwd)/../storage/databases/_pgsql:/var/lib/postgresql/data \
                        -e POSTGRES_PASSWORD="postgres" \
                        -e POSTGRES_USER="postgres" \
                        -e POSTGRES_DB="casdoordb" \
                        -e PGPORT=5430 \
                        -e POSTGRES_INITDB_ARGS='--encoding=UTF-8' \
                        -d postgres

# removed this
#                        -v $(pwd)/conf/pgsql/postgresql.conf:/var/lib/postgresql/data/postgresql.conf \
#                        -e PGDATA=/var/lib/postgresql/data/pgdata \

# poppulate the charities
# npx sequelize-cli db:seed --seed 20240813153512-charities.js