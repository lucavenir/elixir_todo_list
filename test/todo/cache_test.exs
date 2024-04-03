defmodule Todo.CacheTest do
  use ExUnit.Case

  test "get" do
    {:ok, cache} = Todo.Cache.start()
    bob_pid = Todo.Cache.get(cache, "bob")

    assert bob_pid != Todo.Cache.get(cache, "alice")
    assert bob_pid == Todo.Cache.get(cache, "bob")
  end
end
