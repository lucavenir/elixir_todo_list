defmodule TodoList do
  defstruct next_id: 1, entries: %{}
  @type t() :: %TodoList{next_id: integer(), entries: map()}

  @spec new() :: %TodoList{}
  def new(), do: %TodoList{}

  @spec add_entry(TodoList.t(), map()) :: TodoList.t()
  def add_entry(struct, entry) do
    entry = Map.put(entry, :id, struct.next_id)
    new_entries = Map.put(struct.entries, entry.id, entry)
    %TodoList{struct | entries: new_entries, next_id: struct.next_id + 1}
  end

  @spec entries(TodoList.t(), Date.t()) :: list(map())
  def entries(struct, date) do
    struct.entries
    |> Map.values()
    |> Enum.filter(&(&1.date == date))
  end
end

list =
  TodoList.new()
  |> TodoList.add_entry(%{date: ~D[2024-04-01], task: "Write blog post"})
  |> TodoList.add_entry(%{date: ~D[2024-04-01], task: "Write more blog posts"})
  |> TodoList.add_entry(%{date: ~D[2024-04-02], task: "Write even more more blog posts"})

results = list |> TodoList.entries(~D[2024-04-01])
IO.inspect(results)
