defmodule Todo.DbWorker do
  use GenServer

  def start_link({folder, id}) do
    GenServer.start_link(__MODULE__, folder, name: via_tuple(id))
  end

  def put(id, key, value) do
    GenServer.cast(via_tuple(id), {:put, key, value})
  end

  def get(id, key) do
    GenServer.call(via_tuple(id), {:get, key})
  end

  def init(folder) do
    IO.puts("Starting Todo.DbWorker")

    {:ok, folder}
  end

  def handle_cast({:put, key, value}, state) do
    file_name(key, state) |> File.write!(:erlang.term_to_binary(value))
    {:noreply, state}
  end

  def handle_call({:get, key}, _, state) do
    read = file_name(key, state) |> File.read()

    data =
      case read do
        {:ok, content} -> :erlang.binary_to_term(content)
        _ -> nil
      end

    {:reply, data, state}
  end

  defp file_name(key, folder) do
    Path.join(folder, "#{to_string(key)}.todo")
  end

  defp via_tuple(id) do
    Todo.Registry.via_tuple({__MODULE__, id})
  end
end
