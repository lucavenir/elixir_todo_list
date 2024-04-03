defmodule Todo.List do
  defstruct next_id: 1, entries: %{}
  @type t() :: %Todo.List{next_id: pos_integer(), entries: map()}

  @spec new(list(map())) :: %Todo.List{}
  def new(entries \\ []), do: Enum.into(entries, %Todo.List{})

  @spec add_entry(Todo.List.t(), map()) :: Todo.List.t()
  def add_entry(struct, entry) do
    entry = Map.put(entry, :id, struct.next_id)
    new_entries = Map.put(struct.entries, entry.id, entry)
    %Todo.List{struct | entries: new_entries, next_id: struct.next_id + 1}
  end

  @spec entries(Todo.List.t(), Date.t()) :: list(map())
  def entries(struct, date) do
    struct.entries
    |> Map.values()
    |> Enum.filter(&(&1.date == date))
  end

  @spec update_entry(Todo.List.t(), pos_integer(), (map() -> map())) :: Todo.List.t()
  def update_entry(struct, id, updater) do
    case Map.fetch(struct.entries, id) do
      :error ->
        struct

      {:ok, entry} ->
        new_entry = updater.(entry)
        new_entries = Map.put(struct.entries, new_entry.id, new_entry)
        %Todo.List{struct | entries: new_entries}
    end
  end

  @spec delete_entry(Todo.List.t(), pos_integer()) :: Todo.List.t()
  def delete_entry(struct, id) do
    new_entries = Map.delete(struct.entries, id)
    %Todo.List{struct | entries: new_entries}
  end
end

defimpl Collectable, for: Todo.List do
  def into(original), do: {original, &into_callback/2}

  defp into_callback(struct, {:cont, entry}), do: Todo.List.add_entry(struct, entry)
  defp into_callback(struct, :done), do: struct
  defp into_callback(_, :halt), do: :ok
end

list =
  Todo.List.new()
  |> Todo.List.add_entry(%{date: ~D[2024-04-01], task: "Write blog post"})
  |> Todo.List.add_entry(%{date: ~D[2024-04-01], task: "Write more blog posts"})
  |> Todo.List.add_entry(%{date: ~D[2024-04-02], task: "Write even more more blog posts"})

_ = list |> Todo.List.entries(~D[2024-04-01])

list |> Todo.List.update_entry(1, &%{&1 | task: "LOL"})
list |> Todo.List.delete_entry(1)
