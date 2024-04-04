defmodule Todo.Db do
  use GenServer
  @folder "./db"

  def start, do: GenServer.start(__MODULE__, nil, name: __MODULE__)

  def put(key, value) do
    worker = GenServer.call(__MODULE__, {:choose, key})
    Todo.DbWorker.put(worker, key, value)
  end

  def get(key) do
    worker = GenServer.call(__MODULE__, {:choose, key})
    Todo.DbWorker.get(worker, key)
  end

  def clear do
    File.rm_rf!(@folder)
  end

  def init(_) do
    File.mkdir_p!(@folder)

    workers =
      for i <- 0..2, into: %{} do
        {:ok, worker} = Todo.DbWorker.start(@folder)
        {i, worker}
      end

    {:ok, workers}
  end

  def handle_call({:choose, key}, _, state) do
    worker = choose_worker(state, key)
    {:reply, worker, state}
  end

  defp choose_worker(pool, key) do
    i = :erlang.phash2(key, 3)
    pool[i]
  end
end
