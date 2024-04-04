defmodule Todo.Cache do
  use GenServer

  def start, do: GenServer.start(__MODULE__, %{})
  def get(pid, name), do: GenServer.call(pid, {:pid, name})

  @impl GenServer
  def init(_) do
    Todo.Db.start()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:pid, name}, _from, state) do
    case Map.fetch(state, name) do
      {:ok, pid} ->
        {:reply, pid, state}

      :error ->
        {:ok, new_pid} = Todo.Server.start(name)
        {:reply, new_pid, Map.put(state, name, new_pid)}
    end
  end
end
