package main

import (
	"database/sql"
	"log"

	"github.com/Arpeet-gupta/simple-bank/v3/api"
	db "github.com/Arpeet-gupta/simple-bank/v3/db/sqlc"
	"github.com/Arpeet-gupta/simple-bank/v3/util"
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}
	conn, err := sql.Open(config.DBDriver, config.DDSource)
	if err != nil {
		log.Fatal("cannot connect to the database: ", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}
}
