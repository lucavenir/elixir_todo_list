defmodule Todo.DbTest do
  use ExUnit.Case

  test "init" do
    # how to close this link on test end?
    {:ok, _pid} = Todo.Registry.start_link()
    {:ok, {_, workers}} = Todo.Db.init(nil)

    assert [0, 1, 2] == Enum.map(workers, fn e -> e.id end)
  end
end
