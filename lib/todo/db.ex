defmodule Todo.Db do
  use GenServer
  @folder "./db"

  def start_link(opts \\ [amount: 3]) do
    GenServer.start_link(__MODULE__, opts[:amount], name: __MODULE__)
  end

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

  def init(amount) do
    File.mkdir_p!(@folder)

    workers =
      for i <- 0..(amount - 1), into: %{} do
        {:ok, worker} = Todo.DbWorker.start_link(@folder)
        {i, worker}
      end

    {:ok, workers}
  end

  def handle_call({:choose, key}, _, state) do
    worker = choose_worker(state, key)
    {:reply, worker, state}
  end

  defp choose_worker(pool, key) do
    size = Kernel.map_size(pool)
    i = :erlang.phash2(key, size)
    pool[i]
  end
end
