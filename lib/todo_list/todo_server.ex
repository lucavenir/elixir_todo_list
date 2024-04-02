defmodule TodoList.TodoServer do
  def start do
    spawn(fn -> loop(TodoList.new()) end)
  end

  def add(pid, entry), do: send(pid, {:create, entry})

  def entries(pid, date) do
    send(pid, {:read, self(), date})

    receive do
      {:result, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  def update(pid, id, updater), do: send(pid, {:update, id, updater})

  def delete(pid, id), do: send(pid, {:delete, id})

  defp loop(state) do
    receive do
      message -> crud(state, message)
    end

    loop(state)
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
