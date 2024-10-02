# JustTravel

## Tech Decisions

1. We used an index for cities on tickets, for performance on search.
2. We preferred a perfect match to handle this right now, as if use text search with ilike %% we would degrade performance.
3. With the above being said: it's our responsibility to handle right input. We can think about searching and matching a well know and reliable api list of cities handled by frontend for example and validated in the backend.
4. The handling of decimal ticket price to float in API were a problem: for quick win we handled it on resolver (`[Tickets] graphql` commit)
5. If we need better performance to load recurrent nested data, we can think about implement [Dataloader](https://hexdocs.pm/absinthe/dataloader.html)
6. We could setup Faker and ExMachina for factory and data variation - but it's not a must so we avoided the additional complexity.
7. We opted to work all in single `schema` file and `schema_test` for graphql right nows, but a API grows, its good to better structure the files, absynthe have features for [import_types and import_fields](https://hexdocs.pm/absinthe/importing-types.html#example) for instance
8. We opted for doing atomic ticket addition on the cart at first instance: We could handle with Repo.insert_all receiving a list of ticket_ids, but we want to handle this later
9. There is the option to use absinthe relay to handle answers as well. For now we used a [derivation from Kronky](https://hexdocs.pm/absinthe_error_payload) for getting error messages. (`[Carts] add new ticket to cart` commit)
10. After finishing to buy tickets we need to consolidate the order in a PurchaseOrder and clean the cart. Handle the payment status through a payment Broker as Stone, MercadoPago, Pagarme or other. Handle mailing to client through systems as SendGrid, Twilio or Zenvia. After finishing we need to give the client access codes so they can validate and enter their ticket experience. To keep retrying some status fetching or notification we can think about Oban jobs.
11. We could use redis or other cache system with ttl as erlang ets or erlang mnesia, for solve the cart problem: We didn't for simplicity and deploy on `fly.io`.
12. For user auth we can use systems as oauth2, or JWT token, we need a Schema for users as well and we can't forget to add bcrypt on user password changeset, to have phone info and mail info for 2factor auth for instance.
13. There are a lot of things to consider for this system and we can put weeks of effort to round the backend solution into something mature.
14. There are options to observability to consider, as Sentry, Datadog, AppSignal, GrafanaLokiStack.

## Playground

Online: https://just-travel.fly.dev/graphiql

Use [schema_test](https://github.com/just-trial/backend/blob/main/test/just_travel_web/schema_test.exs) as sample for playground.

`Tip 1`: there are 100 random tickets generated to the following cities: `'New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami', 'San Francisco', 'Seattle', 'Boston', 'Austin', 'Denver'`

`Tip 2`: you can use from cart 1 to 10 to simulate your trips.

`Tip 3`: you can import [insomnia file](https://github.com/just-trial/backend/blob/main/api/Insomnia_2024-10-02.json) to test the api as well. 

or instead you can run a fresh db local: http://localhost:4000/graphiql

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
