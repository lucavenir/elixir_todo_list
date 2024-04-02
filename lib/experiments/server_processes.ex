defmodule ServerCalculator do
  def start, do: spawn(fn -> loop(0) end)

  def value(pid) do
    send(pid, {:compute, self()})

    receive do
      {:result, value} -> value
    end
  end

  def add(pid, value), do: send(pid, {:add, value})
  def subtract(pid, value), do: send(pid, {:subtract, value})
  def multiply(pid, value), do: send(pid, {:multiply, value})
  def divide(pid, value), do: send(pid, {:divide, value})

  defp loop(current) do
    new_value =
      receive do
        message -> compute(current, message)
      end

    loop(new_value)
  end

  defp compute(current, {:compute, pid}) do
    send(pid, {:result, current})
    current
  end

  defp compute(current, message) do
    Process.sleep(:rand.uniform(10_000))
    operation(current, message)
  end

  defp operation(current, {:add, value}), do: current + value
  defp operation(current, {:subtract, value}), do: current - value
  defp operation(current, {:multiply, value}), do: current * value
  defp operation(current, {:divide, value}), do: current / value

  defp operation(current, invalid) do
    IO.puts("Requested an invalid operation: #{inspect(invalid)}")
    current_value
  end
end
