defmodule HordeConnector.Supervisor.Support do
  @moduledoc false
  use GenServer

  def start(args) do
    GenServer.start(__MODULE__, args)
  end

  def init(list) when is_list(list) do
    Enum.each(list, fn x -> run_mfa(x) end)
    {:ok, []}
  end

  def init(arg) do
    run_mfa(arg)
    {:ok, []}
  end

  defp run_mfa({m, f, a}) do
    apply(m, f, a)
  end
end
