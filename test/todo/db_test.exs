defmodule Todo.DbTest do
  use ExUnit.Case

  test "init" do
    {:ok, workers} = Todo.Db.init(3)
    assert Map.keys(workers) == [0, 1, 2]
  end
end
