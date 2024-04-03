# defmodule TodoList.CsvImporter do
#   @spec import(String.t()) :: TodoList.t()
#   def import(file_path) do
#     File.stream!(file_path)
#     |> Stream.map(&String.trim/1)
#     |> Stream.map(&String.split(&1, ","))
#     |> Stream.map(&parse_line/1)
#     |> Enum.to_list()
#     |> TodoList.new()
#   end

#   defp parse_line([date, task]) do
#     %{date: Date.from_iso8601!(date), task: task}
#   end
# end

# # Todo.List.CsvImporter.import("assets/todos.csv")
