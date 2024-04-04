defmodule Todo.CacheTest do
  use ExUnit.Case

  test "cache get" do
    {:ok, cache} = Todo.Cache.start()
    bob_pid = Todo.Cache.get(cache, "bob")

    assert bob_pid != Todo.Cache.get(cache, "alice")
    assert bob_pid == Todo.Cache.get(cache, "bob")
  end

  describe "cache tests" do
    setup do
      {:ok, cache} = Todo.Cache.start()
      alice = Todo.Cache.get(cache, "alice")
      date = ~D[2021-01-01]
      title = "Alice's task"
      on_exit(&Todo.Db.clear/0)

      %{
        cache: cache,
        alice: alice,
        date: date,
        title: title
      }
    end

    test "add", context do
      alice = context.alice
      title = context.title
      date = context.date
      Todo.Server.add(alice, %{date: date, title: title})

      entries = Todo.Server.entries(alice, date)

      assert [%{date: ^date, title: ^title}] = entries
    end

    test "delete", context do
      alice = context.alice
      title = context.title
      date = context.date
      Todo.Server.add(alice, %{date: date, title: title})

      Todo.Server.delete(alice, 1)
      entries = Todo.Server.entries(alice, date)

      assert [] = entries
    end
  end
end
