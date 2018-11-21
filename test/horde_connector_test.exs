defmodule HordeConnectorTest do
  use ExUnit.Case
  use Placebo

  describe "HordeConnector" do
    test "will join the configured hordes when receiving a nodeup message" do
      allow Horde.Cluster.join_hordes(term(), term()), return: :ok

      HordeConnector.handle_info({:nodeup, :nodeX10, []}, [H.Sup, H.Reg])

      assert_called Horde.Cluster.join_hordes(H.Sup, {H.Sup, :nodeX10})
      assert_called Horde.Cluster.join_hordes(H.Reg, {H.Reg, :nodeX10})
    end

    test "child_spec will start task that starts HordeConnector" do
      allow Horde.Supervisor.start_child(term(), term()), return: :ok
      spec = HordeConnector.child_spec(supervisor: H.Sup)

      assert :horde_connector_starter == spec[:id]
      assert :transient == spec[:restart]
      assert {Task, :start_link, [starter_function]} = spec[:start]

      starter_function.()

      assert_called Horde.Supervisor.start_child(H.Sup, %{
                      id: HordeConnector,
                      start: {HordeConnector, :start_link, [[H.Sup], [name: HordeConnector]]}
                    })
    end

    test "child_spec will register with Horde.Registry if supplied" do
      allow Horde.Supervisor.start_child(term(), term()), return: :ok
      spec = HordeConnector.child_spec(supervisor: H.Sup, registry: H.Reg)

      assert {Task, :start_link, [starter_function]} = spec[:start]

      starter_function.()

      assert_called Horde.Supervisor.start_child(H.Sup, %{
                      start:
                        {HordeConnector, :start_link,
                         [[H.Sup, H.Reg], [name: {:via, Horde.Registry, {H.Reg, HordeConnector}}]]}
                    })
    end
  end
end
