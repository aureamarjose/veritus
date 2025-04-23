After cloning the repository, build the application.
docker compose build

Run the application.
docker compose up -d

Check the application's status.
docker ps

Access the Rails container using the terminal.
docker exec -it veritus-app-1 bash

Create the database, run the migrations, and seed the database.
rails db:create db:migrate dev:setup

Access the application at http://0.0.0.0:3000/
login: admin@admin.com
senha: asdasd

Other Commands
Check the application logs.
docker logs -f veritus-app-1

Stop the containers.
docker compose down or docker compose down --remove-orphans
