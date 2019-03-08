FROM elixir:1.8-alpine
ENV MIX_ENV test
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  mix format --check-formatted && \
  mix credo && \
  elixir --name a@127.0.0.1 -S mix test
