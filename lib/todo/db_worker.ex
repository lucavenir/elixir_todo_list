defmodule Todo.DbWorker do
  use GenServer

  def start_link(folder) do
    GenServer.start_link(__MODULE__, folder)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
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
end
