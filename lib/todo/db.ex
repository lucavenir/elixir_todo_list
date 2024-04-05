defmodule Todo.Db do
  use Supervisor
  @folder "./db"
  @pool_size 3

  def start_link(_) do
    Supervisor.start_link(__MODULE__, @pool_size, name: __MODULE__)
  end

  def put(key, value) do
    key
    |> choose_worker()
    |> Todo.DbWorker.put(key, value)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DbWorker.get(key)
  end

  @impl Supervisor
  def init(_) do
    IO.puts("Starting DB with pool size #{@pool_size}")
    File.mkdir_p!(@folder)
    workers = Enum.map(0..(@pool_size - 1), &worker_spec/1)
    Supervisor.init(workers, strategy: :one_for_one)
  end

  defp worker_spec(id) do
    spec = {Todo.DbWorker, {@folder, id}}
    Supervisor.child_spec(spec, id: id)
  end

  # def handle_call({:choose, key}, _, state) do
  #   worker = choose_worker(state, key)
  #   {:reply, worker, state}
  # end

  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size)
  end
end
