defmodule TodoList.Server do
  def start do
    spawn(fn ->
      Process.register(self(), :todolist_server)
      loop(TodoList.new())
    end)
  end

  def add(entry), do: send(:todolist_server, {:create, entry})

  def entries(date) do
    send(:todolist_server, {:read, self(), date})

    receive do
      {:result, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  def update(id, updater), do: send(:todolist_server, {:update, id, updater})

  def delete(id), do: send(:todolist_server, {:delete, id})

  defp loop(state) do
    new_state =
      receive do
        message ->
          IO.inspect(message)
          crud(state, message)
      end

    loop(new_state)
  end

  defp crud(state, {:read, pid, date}) do
    filtered = TodoList.entries(state, date)
    send(pid, {:result, filtered})
    state
  end

  defp crud(state, {:create, todo}), do: TodoList.add_entry(state, todo)
  defp crud(state, {:update, id, updater}), do: TodoList.update_entry(state, id, updater)
  defp crud(state, {:delete, id}), do: TodoList.delete_entry(state, id)
end
