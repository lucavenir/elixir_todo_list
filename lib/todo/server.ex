defmodule Todo.Server do
  use GenServer

  def start(name), do: GenServer.start(Todo.Server, name)
  def add(user, entry), do: GenServer.cast(user, {:create, entry})
  def update(user, id, updater), do: GenServer.cast(user, {:update, id, updater})
  def delete(user, id), do: GenServer.cast(user, {:delete, id})
  def entries(user, date), do: GenServer.call(user, {:read, date})

  @impl GenServer
  def init(name) do
    {:ok, {name, nil}, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, {name, nil}) do
    todos = Todo.Db.get(name) || Todo.List.new()
    {:noreply, {name, todos}}
  end

  @impl GenServer
  def handle_cast({:create, todo}, {name, todos}) do
    updated = Todo.List.add_entry(todos, todo)
    Todo.Db.put(name, updated)
    {:noreply, updated}
  end

  def handle_cast({:update, id, updater}, {name, todos}) do
    updated = Todo.List.update_entry(todos, id, updater)
    Todo.Db.put(name, updated)
    {:noreply, updated}
  end

  def handle_cast({:delete, id}, {name, todos}) do
    updated = Todo.List.delete_entry(todos, id)
    Todo.Db.put(name, updated)
    {:noreply, updated}
  end

  @impl GenServer
  def handle_call({:read, date}, _from, {_name, todos}) do
    read = Todo.List.entries(todos, date)
    {:reply, read, todos}
  end
end
