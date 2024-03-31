defmodule TodoList do
  @spec new() :: %{}
  def new(), do: MultiDict.new()

  @spec add_entry(map(), map()) :: map()
  def add_entry(list, entry), do: MultiDict.add(list, entry.date, entry)

  @spec entries(map(), Date.t()) :: map()
  def entries(list, date), do: MultiDict.get(list, date)
end
