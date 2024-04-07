defmodule Todo.Server do
  use Agent, restart: :temporary

  def start_link(user), do: Agent.start_link(fn -> init(user) end, name: via_tuple(user))

  defp init(user) do
    IO.puts("Starting Todo.Server for #{user}")
    Todo.Db.get(user) || Todo.List.new()
  end

  def add(user, entry) do
    Agent.cast(via_tuple(user), fn state -> handle_create(user, state, entry) end)
  end

  defp handle_create(name, state, todo) do
    updated = Todo.List.add_entry(state, todo)
    Todo.Db.put(name, updated)
    {name, updated}
  end

  def update(user, id, updater) do
    Agent.cast(via_tuple(user), fn state -> handle_update(user, state, id, updater) end)
  end

  defp handle_update(name, state, id, updater) do
    updated = Todo.List.update_entry(state, id, updater)
    Todo.Db.put(name, updated)
    {name, updated}
  end

  def delete(user, id) do
    Agent.cast(via_tuple(user), fn state -> handle_delete(user, state, id) end)
  end

  defp handle_delete(name, state, id) do
    updated = Todo.List.delete_entry(state, id)
    Todo.Db.put(name, updated)
    {name, updated}
  end

  def entries(user, date) do
    Agent.get(via_tuple(user), fn state -> Todo.List.entries(state, date) end)
  end

  defp via_tuple(name), do: Todo.Registry.via_tuple({__MODULE__, name})
end
