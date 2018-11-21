FROM elixir:1.7.4
ENV MIX_ENV test
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get && \
  elixir --name a@127.0.0.1 -S mix test && \
  mix credo
