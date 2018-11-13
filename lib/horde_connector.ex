defmodule HordeConnector do
  @moduledoc """
  Module that automatically connects all nodes to configured
  hordes.
  """
  use GenServer
  require Logger

  def start_link(args, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def init(hordes) do
    :net_kernel.monitor_nodes(true, node_type: :hidden)

    for node <- Node.list(),
        horde <- hordes do
      join_horde(horde, node)
    end

    {:ok, hordes}
  end

  def child_spec(opts) do
    registry = Keyword.get(opts, :registry)
    supervisor = Keyword.get(opts, :supervisor, Horde.Supervisor)

    %{
      id: :horde_connector_starter,
      restart: :transient,
      start:
        {Task, :start_link,
         [
           fn ->
             Horde.Supervisor.start_child(supervisor, connector_child_spec(supervisor, registry))
           end
         ]}
    }
  end

  def handle_info({:nodeup, node, _options}, hordes) do
    Enum.each(hordes, fn horde -> join_horde(horde, node) end)
    {:noreply, hordes}
  end

  def handle_info({:nodedown, node, _options}, hordes) do
    Logger.info("Node #{node} has gone DOWN!")
    {:noreply, hordes}
  end

  def handle_info(unknown_message, state) do
    Logger.info("Unknown message received: #{inspect(unknown_message)}")
    {:noreply, state}
  end

  defp join_horde(horde, node) do
    Horde.Cluster.join_hordes(horde, {horde, node})
    Logger.info("Node #{node} joining horde #{horde}")
  end

  defp name(nil), do: __MODULE__
  defp name(registry), do: {:via, Horde.Registry, {registry, __MODULE__}}

  defp connector_child_spec(supervisor, registry) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [[supervisor, registry], [name: name(registry)]]}
    }
  end
end
