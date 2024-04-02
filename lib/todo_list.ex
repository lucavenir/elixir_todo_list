defmodule TodoList do
  defstruct next_id: 1, entries: %{}
  @type t() :: %TodoList{next_id: pos_integer(), entries: map()}

  @spec new(list(map())) :: %TodoList{}
  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, &add_entry(&2, &1))
  end

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

  @spec update_entry(TodoList.t(), pos_integer(), (map() -> map())) :: TodoList.t()
  def update_entry(struct, id, updater) do
    case Map.fetch(struct.entries, id) do
      :error ->
        struct

      {:ok, entry} ->
        new_entry = updater.(entry)
        new_entries = Map.put(struct.entries, new_entry.id, new_entry)
        %TodoList{struct | entries: new_entries}
    end
  end

  @spec delete_entry(TodoList.t(), pos_integer()) :: TodoList.t()
  def delete_entry(struct, id) do
    new_entries = Map.delete(struct.entries, id)
    %TodoList{struct | entries: new_entries}
  end
end

defmodule TodoList.CsvImporter do
  @spec import(String.t()) :: TodoList.t()
  def import(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
    |> TodoList.new()
  end

  defp parse_line([date, task]) do
    %{date: Date.from_iso8601!(date), task: task}
  end
end

list =
  TodoList.new()
  |> TodoList.add_entry(%{date: ~D[2024-04-01], task: "Write blog post"})
  |> TodoList.add_entry(%{date: ~D[2024-04-01], task: "Write more blog posts"})
  |> TodoList.add_entry(%{date: ~D[2024-04-02], task: "Write even more more blog posts"})

_ = list |> TodoList.entries(~D[2024-04-01])

list |> TodoList.update_entry(1, &%{&1 | task: "LOL"})
list |> TodoList.delete_entry(1)

TodoList.CsvImporter.import("assets/todos.csv") |> IO.inspect()
