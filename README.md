# matomo-to-influx

A quickly written [ruby](https://www.ruby-lang.org/en/) script, pushing  [matomo](https://matomo.org) stats to [influxDB](https://www.influxdata.com), running in [Docker](https://www.youtube.com/watch?v=DLzxrzFCyOs).

## Build and run with Docker

1. Clone this repo and `cd` into it.
2. Create a file called `env` with the required variables (see `env.example`).
3. `docker build -t matomo-to-influx -f ./Dockerfile .`
4. `docker run -d --env-file=./env matomo-to-influx`

## Usage without Docker

```sh
bundle install

# export the variables in your shell session

ruby app.rb
```
