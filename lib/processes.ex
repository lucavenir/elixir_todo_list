query = fn input ->
  Process.sleep(2500)
  "#{input} is done"
end

query_runner = fn input ->
  caller = self()

  spawn(fn ->
    result = query.(input)
    send(caller, {:result, result})
  end)
end

results_collector =
  fn ->
    receive do
      {:result, value} -> value
    end
  end

1..5 |> Enum.map(&query_runner.(&1)) |> Enum.map(fn _ -> results_collector.() end)
