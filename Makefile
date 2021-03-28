postgres:
	docker run -d \
	--name postgres12 \
	-p 5432:5432 \
	-e POSTGRES_USER=root \
	-e POSTGRES_PASSWORD=secret  \
	-e PGDATA=/var/lib/postgresql/data/pgdata \
	-v /home/vagrant/docker-containers/postgres/postgresdata:/var/lib/postgresql/data \
	postgres:12-alpine  

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateinit: 
	migrate create -ext sql -dir db/migration -sql init_schema

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@192.168.0.121:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@192.168.0.121:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test: 
	go test -v -cover ./...

test-transgertx:
	go test -v -cover -run TestTransferTx github.com/Arpeet-gupta/simple-bank/v2/db/sqlc

.PHONY: postgres createdb dropdb migrateinit migrateup migratedown sqlc test-transgertx