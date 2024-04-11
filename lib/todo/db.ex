defmodule Todo.Db do
  @folder "./db"
  @pool_size 3

  def put(key, value) do
    :poolboy.transaction(__MODULE__, fn pid -> Todo.DbWorker.put(pid, key, value) end)
  end

  def get(key) do
    :poolboy.transaction(__MODULE__, fn pid -> Todo.DbWorker.get(pid, key) end)
  end

  def child_spec(_) do
    IO.puts("Starting DB with pool size #{@pool_size}")
    File.mkdir_p!(@folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DbWorker,
        size: @pool_size
      ],
      [
        @folder
      ]
    )
  end
end
