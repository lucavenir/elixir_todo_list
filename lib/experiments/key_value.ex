defmodule KeyValueStore do
  def start, do: CustomServer.start(KeyValueStore)
  def put(pid, key, value), do: CustomServer.cast(pid, {:put, key, value})
  def get(pid, key), do: CustomServer.call(pid, {:get, key})

  def init, do: %{}

  def cast({:put, key, value}, state), do: Map.put(state, key, value)
  def call({:get, key}, state), do: {Map.get(state, key), state}
end

defmodule CustomServer do
  def start(module) do
    spawn(fn ->
      state = module.init()
      loop(module, state)
    end)
  end

  def call(pid, request) do
    send(pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, request), do: send(pid, {:cast, request})

  defp loop(module, state) do
    new_state =
      receive do
        {:cast, request} ->
          module.cast(request, state)

        {:call, request, caller} ->
          {response, new_state} = module.call(request, state)
          send(caller, {:response, response})
          new_state
      end

    loop(module, new_state)
  end
end
