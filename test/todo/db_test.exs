defmodule Todo.DbTest do
  use ExUnit.Case

  test "init" do
    {:ok, workers} = Todo.Db.init(3)
    assert MapSet.equal?(MapSet.new([0, 1, 2]), MapSet.new(Map.keys(workers)))
  end
end
