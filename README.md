# JustTravel

## Tech Decisions

1. We used an index for cities on tickets, for performance on search.
2. We preferred a perfect match to handle this right now, as if use text search with ilike %% we would degrade performance.
3. With the above being said: it's our responsibility to handle right input. We can think about searching and matching a well know and reliable api list of cities handled by frontend for example and validated in the backend.
4. The handling of decimal ticket price to float in API were a problem: for quick win we handled it on resolver (`[Tickets] graphql` commit)
5. If we need better performance to load recurrent nested data, we can think about implement [Dataloader](https://hexdocs.pm/absinthe/dataloader.html)
6. We could setup Faker and ExMachina for factory and data variation - but it's not a must so I avoided the additional complexity.
7. I opted to work all in single schema file, but as API grows, its good to better structure the files, absynthe have features for [import_types and import_fields](https://hexdocs.pm/absinthe/importing-types.html#example) for instance

## External Dependencies

- [Docker Compose](https://docs.docker.com/compose/)
  - [PostgreSQL](https://www.postgresql.org/) (mandatory in any environment)
- [asdf](https://asdf-vm.com/) (optional for running locally)
  - [Erlang](https://www.erlang.org/)
  - [Elixir](https://elixir-lang.org/)

## Getting Started

### Running with Docker Compose

To start the application within Docker Compose:

```bash
docker compose up
```

If you want to force a rebuild:

```bash
docker compose up --build
```

Alternatively, you can set up only PostgreSQL:

```bash
docker compose up -d postgres
```

### Setup dependencies with asdf (optional)

Add all required plugins from `.tool-versions`

```bash
cat .tool-versions | awk '{print $1}' | xargs -I {} asdf plugin add {}
```

Install all dependencies

```bash
asdf install
```

### Checking quality

1. You can run `mix credo`for static analysis.
2. Run `MIX_ENV=test mix setup` to set up database for tests.
3. You can run `mix test` for unit testing.

### Running Locally

To start your Phoenix server locally:

1. Run `mix setup` to install and set up dependencies.
2. Start the Phoenix endpoint with:

```bash
mix phx.server
```

Or, inside IEx with:

```bash
iex -S mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) from your browser to view the application.

## Production Deployment

For deploying the application in a production environment, please refer to our [deployment guides](https://hexdocs.pm/phoenix/deployment.html).
