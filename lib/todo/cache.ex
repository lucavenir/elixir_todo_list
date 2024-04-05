defmodule Todo.Cache do
  use GenServer

  def start_link(_arg), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  def get(name), do: GenServer.call(__MODULE__, {:pid, name})

  @impl GenServer
  def init(_) do
    IO.puts("Starting Todo.Cache")
    Todo.Db.start_link()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:pid, name}, _from, state) do
    case Map.fetch(state, name) do
      {:ok, pid} ->
        {:reply, pid, state}

      :error ->
        IO.puts("Starting a new cache with name #{name}")
        {:ok, new_pid} = Todo.Server.start_link(name)
        {:reply, new_pid, Map.put(state, name, new_pid)}
    end
  end
end
