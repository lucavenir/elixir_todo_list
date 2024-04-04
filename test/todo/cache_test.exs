defmodule Todo.CacheTest do
  use ExUnit.Case

  test "get" do
    {:ok, cache} = Todo.Cache.start()
    bob_pid = Todo.Cache.get(cache, "bob")

    assert bob_pid != Todo.Cache.get(cache, "alice")
    assert bob_pid == Todo.Cache.get(cache, "bob")
  end

  test "add" do
    {:ok, cache} = Todo.Cache.start()
    alice = Todo.Cache.get(cache, "alice")
    d = ~D[2021-01-01]
    t = "Alice's task"

    Todo.Server.add(alice, %{date: d, title: t})
    entries = Todo.Server.entries(alice, d)

    assert [%{date: ^d, title: ^t}] = entries

    Todo.Server.delete(alice, 1)
  end
end
