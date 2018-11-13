Application.load(:horde_connector)

Application.spec(:horde_connector, :applications)
|> Enum.each(&Application.ensure_all_started/1)

Application.ensure_all_started(:ex_unit_clustered_case)

distributed = if Node.alive?(), do: [], else: [:distributed]

ExUnit.start(exclude: [:skip] ++ distributed)
