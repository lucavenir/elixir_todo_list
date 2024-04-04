defmodule Todo.Db do
  use GenServer
  @folder "./db"

  def start, do: GenServer.start(__MODULE__, nil, name: __MODULE__)
  def put(key, value), do: GenServer.cast(__MODULE__, {:put, key, value})
  def get(key), do: GenServer.call(__MODULE__, {:get, key})

  def init(_) do
    File.mkdir_p!(@folder)
    {:ok, nil}
  end

  def handle_cast({:put, key, value}, state) do
    key |> file_name() |> File.write!(:erlang.term_to_binary(value))
    {:noreply, state}
  end

  def handle_call({:get, key}, _, state) do
    read = key |> file_name() |> File.read()

    data =
      case read do
        {:ok, content} -> :erlang.binary_to_term(content)
        _ -> nil
      end

    {:reply, data, state}
  end

  defp file_name(key) do
    Path.join(@folder, "#{to_string(key)}.todo")
  end
end
