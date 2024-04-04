defmodule Todo.DbTest do
  use ExUnit.Case

  test "init" do
    {:ok, workers} = Todo.Db.init(nil)
    assert %{0 => _, 1 => _, 2 => _} = workers
  end
end
