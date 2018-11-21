defmodule HordeConnectorClusteredTest do
  use ExUnit.ClusteredCase
  require Logger
  @moduletag :distributed

  scenario "3 node cluster", cluster_size: 3, boot_timeout: 60_000 do
    node_setup(:start_apps)

    test "ensure horde is connected properly", %{cluster: c} do
      member = Cluster.random_member(c)

      Patiently.wait_for!(
        fn ->
          horde_member_count(member, Test.Horde.Supervisor) == 3
        end,
        dwell: 100,
        max_tries: 50
      )

      Patiently.wait_for!(
        fn ->
          horde_member_count(member, Test.Horde.Registry) == 3
        end,
        dwell: 100,
        max_tries: 50
      )
    end
  end

  def start_apps(_context) do
    HordeConnector.Supervisor.Support.start([
      {Horde.Supervisor, :start_link, [[name: Test.Horde.Supervisor, strategy: :one_for_one]]},
      {Horde.Registry, :start_link, [[name: Test.Horde.Registry]]}
    ])

    %{start: {Task, :start_link, [start_function]}} =
      HordeConnector.child_spec(supervisor: Test.Horde.Supervisor, registry: Test.Horde.Registry)

    start_function.()
  end

  def horde_member_count(node, horde) do
    node
    |> Cluster.call(Horde.Cluster, :members, [horde])
    |> elem(1)
    |> Enum.count()
  end
end
