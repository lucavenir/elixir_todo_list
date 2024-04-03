defmodule Todo.Server do
  use GenServer

  def start(), do: GenServer.start(Todo.Server, %{})
  def add(user, entry), do: GenServer.cast(user, {:create, entry})
  def update(user, id, updater), do: GenServer.cast(user, {:update, id, updater})
  def delete(user, id), do: GenServer.cast(user, {:delete, id})
  def entries(user, date), do: GenServer.call(user, {:read, date})

  @impl GenServer
  @spec init(list(map())) :: {:ok, Todo.List.t()}
  def init(list), do: {:ok, Todo.List.new(list)}

  @impl GenServer
  def handle_cast({:create, todo}, state), do: {:noreply, Todo.List.add_entry(state, todo)}

  def handle_cast({:update, id, updater}, state),
    do: {:noreply, Todo.List.update_entry(state, id, updater)}

  def handle_cast({:delete, id}, state), do: {:noreply, Todo.List.delete_entry(state, id)}

  @impl GenServer
  def handle_call({:read, date}, _from, state),
    do: {:reply, Todo.List.entries(state, date), state}
end
