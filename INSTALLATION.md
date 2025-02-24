# Installation / Deployment

## Requirements

To test this application you will need:

1. Docker Engine
2. Docker Compose
3. (optional) Linux based terminal

## Getting Started

1. Clone this repository to eg: `REPO_DIR`, and cd into it
   `$ git clone https://github.com/jimanx2/seek-robot-problem.git <REPO_DIR>`
   `$ cd <REPO_DIR>`
2. Run `docker-compose build --no-cache base` (`--no-cache` flag used to invalidate bundler installed gems)
3. Run `docker-compose up -d`
4. Refer `http://localhost:3000/docs/index.html` for API documentation.

## Testing API 

Based on API documentation mentioned above, you may use `curl` or any REST client of your choice to initiate API calls. For example:

```sh
$ # get robot session id
$ curl http://localhost:3000/api/robot/place -H 'Content-Type: application/json' --data '{"x":"1","y":"1","direction":"NORTH"}' # should return 200 response with X-Session-Id header
$ # get robot current position
$ curl -H 'X-Session-Id: <session id from above step>' http://localhost:3000/api/robot/report
$ # make the robot turns
$ curl -X POST  -H 'Content-Length: 0' -H 'X-Session-Id: <session id from above step>' http://localhost:3000/api/robot/<left or right>
$ # ask the robot to move forward
$ curl -X POST  -H 'Content-Length: 0' -H 'X-Session-Id: <session id from above step>' http://localhost:3000/api/robot/move
```

## Testing CLI

You may start the REPL by using command below:

```sh
$ docker-compose run --rm cli repl
```
