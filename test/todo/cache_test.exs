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
    date = ~D[2021-01-01]
    task = "Alice's task"

    Todo.Server.add(alice, %{date: date, title: task})
    entries = Todo.Server.entries(alice, date)

    assert [%{date: date, title: task}] = entries
  end
end
