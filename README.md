# HordeConnector

This library must be used in conjunction with [Horde](https://github.com/derekkraan/horde).
Horde by itself works in a well defined enviornment where all instances are known at startup.
HordeConnector allows new BEAM nodes to be added to the Horde dynamically at runtime.
Your application will still be responsible for linking nodes (we suggest using [libcluster](https://hexdocs.pm/libcluster/readme.html)).
Once linked, HordeConnector will automatically join nodes to Horde upon connection.

## Installation

This package can be installed by adding `horde_connector` to your list of dependencies in `mix.exs`:

```elixir
def deps() do
  [
    {:horde_connector, "~> 1.0.0"}
  ]
end
```

## Configuration

### <span style="color:red">HordeConnector currently only works with Horde Version 0.2.3</span>
Configure Horde per their documentation [HERE](https://github.com/derekkraan/horde).
Start `HordeConnector` under you application.
```elixir
# application.ex
def start(_type, _args) do
  children = [
    # ....
    {Horde.Registry, [name: MyApp.Registry]},
    {Horde.Supervisor, [name: MyApp.Horde.Supervisor, strategy: :one_for_one]},
    {HordeConnector, [supervisor: MyApp.Horde.Supervisor, registry: MyApp.Registry]}
   ]

    # ....

   Supervisor.start_link(children, opts)
end
```

And that's it! Once HordeConnector is started, any time `Node.connect/1` is called the new node will be added to the Horde cluster.

## License
Released under [Apache 2 license](https://github.com/SmartColumbusOS/horde_connector/blob/master/LICENSE).
