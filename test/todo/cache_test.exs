defmodule Todo.CacheTest do
  use ExUnit.Case

  test "cache get" do
    bob_pid = Todo.Cache.get("bob")

    assert bob_pid != Todo.Cache.get("alice")
    assert bob_pid == Todo.Cache.get("bob")
  end
end
