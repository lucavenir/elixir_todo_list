defmodule KeyValueStore.GenServer do
  use GenServer

  def start, do: GenServer.start(KeyValueStore.GenServer, nil, name: __MODULE__)
  def put(key, value), do: GenServer.cast(__MODULE__, {:put, key, value})
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  @impl GenServer
  def init(_), do: {:ok, %{}}
  @impl GenServer
  def handle_cast({:put, key, value}, state), do: {:noreply, Map.put(state, key, value)}
  @impl GenServer
  def handle_call({:get, key}, _from, state), do: {:reply, Map.get(state, key), state}
end
