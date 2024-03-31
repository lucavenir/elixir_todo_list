defmodule ElixirTodoList do
  @moduledoc """
  Documentation for `ElixirTodoList`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ElixirTodoList.hello()
      :world

  """
  @spec hello(number()) :: {:world, number()}
  def hello(int) do
    {:world, int + 1}
  end

  def example() do
    case hello("world") do
      {:world, _} -> IO.puts("Hello world")
      _ -> IO.puts("Hello")
    end
  end
end
