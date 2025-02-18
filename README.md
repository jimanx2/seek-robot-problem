# seek-robot-problem
# quickstart

It's preferrable to use Linux based dev environment

Requirements:
- docker engine
- docker-compose

1. clone this repository to, let's say /home/user
2. `cd /home/user/seek-robot-problem`
3. `docker-compose build base`
4. `docker-compose up -d` # this will start API server at `localhost:3000`
5. [optional] `docker-compose run --rm cli repl DEBUG=true`
6. API docs (swagger) are available at `/home/user/seek-robot-problem/app/http/openapi.yaml`

NOTE: This readme will be updated properly
