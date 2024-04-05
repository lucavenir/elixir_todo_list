defmodule Todo.CacheTest do
  use ExUnit.Case

  test "cache get" do
    {:ok, _} = Todo.Cache.start_link(nil)
    bob_pid = Todo.Cache.get("bob")

    assert bob_pid != Todo.Cache.get("alice")
    assert bob_pid == Todo.Cache.get("bob")
  end

  describe "cache" do
    setup do
      {:ok, cache} = Todo.Cache.start_link(nil)
      Todo.Db.start_link(nil)
      alice = Todo.Cache.get("alice")
      date = ~D[2021-01-01]
      title = "Alice's task"

      %{
        cache: cache,
        alice: alice,
        date: date,
        title: title
      }
    end
  end
end
