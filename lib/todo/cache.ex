defmodule Todo.Cache do
  use DynamicSupervisor

  def start_link(_arg), do: DynamicSupervisor.start_link(__MODULE__, %{}, name: __MODULE__)

  def get(name) do
    case start_child(name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  @impl DynamicSupervisor
  def init(_) do
    IO.puts("Starting Todo.Cache")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start_child(name) do
    DynamicSupervisor.start_child(__MODULE__, {Todo.Server, name})
  end
end
