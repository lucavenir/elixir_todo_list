defmodule TodoList.GenServer do
  use GenServer

  def start, do: GenServer.start(TodoList.GenServer, %{}, name: __MODULE__)
  def add(entry), do: GenServer.cast(__MODULE__, {:create, entry})
  def update(id, updater), do: GenServer.cast(__MODULE__, {:update, id, updater})
  def delete(id), do: GenServer.cast(__MODULE__, {:delete, id})
  def entries(date), do: GenServer.call(__MODULE__, {:read, date})

  @impl GenServer
  @spec init(list(map())) :: {:ok, TodoList.t()}
  def init(list), do: {:ok, TodoList.new(list)}

  @impl GenServer
  def handle_cast({:create, todo}, state), do: {:noreply, TodoList.add_entry(state, todo)}

  def handle_cast({:update, id, updater}, state),
    do: {:noreply, TodoList.update_entry(state, id, updater)}

  def handle_cast({:delete, id}, state), do: {:noreply, TodoList.delete_entry(state, id)}

  @impl GenServer
  def handle_call({:read, date}, _from, state), do: {:reply, TodoList.entries(state, date), state}
end
