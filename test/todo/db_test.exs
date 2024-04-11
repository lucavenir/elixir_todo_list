defmodule Todo.DbTest do
  use ExUnit.Case

  test "init" do
    {:ok, {_, workers}} = Todo.Db.init(nil)

    assert [0, 1, 2] == Enum.map(workers, fn e -> e.id end)
  end
end
