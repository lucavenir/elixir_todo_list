defmodule Todo.CacheTest do
  use ExUnit.Case

  test "cache get" do
    Todo.System.start_link()
    {:ok, _} = Todo.Cache.start_link(nil)
    bob_pid = Todo.Cache.get("bob")

    assert bob_pid != Todo.Cache.get("alice")
    assert bob_pid == Todo.Cache.get("bob")
  end
end
